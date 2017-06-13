<?php
/**************************
 *媒体控制器
 **************************/
namespace Home\Controller;

class MediaController extends CommonController
{
    //表的表名-自增主键
    protected $tab_id = 'empid';
    protected $models = ['pe_video_list'=>'Enforce\PeVideoList',    //媒体信息
                         'area'=>'Enforce\AreaDep',                 //部门
                         'employee'=>'Enforce\Employee'];           //警员
    protected $actions = ['area'=>'Area',
                          'role'=>'Role',
                          'user'=>'User',
                          'employee'=>'Employee'];
    protected $views = ['play_video'=>'playVideo'];
    protected $logContent = '数据管理/媒体数据';
    //单文件播放页面
    public function play_video()
    {
        $wjbh = I('wjbh');
        $db = D($this->models['pe_video_list']);
        $where['wjbh'] = u2g($wjbh);
        $videoInfo = $db->where($where)->find();
        $this->assign('videoInfo',$videoInfo);
        $this->display('play_video');
    }
    public function show_sat()
    {
        $this->assignInfo();
        $pages = array('work_sat'=>'work_sat',  //工作量统计
                       'lay_sat'=>'lay_sat',    //执法统计
                       'assessmeny_sat'=>'assessmeny_sat',  //考核统计
                       'unusual_sat'=>'unusual_sat');       //异常统计
        $page = I('satType','work_sat');
        $this->display($pages[$page]);
    }
    public function assignInfo()
    {
        $action = A($this->actions['area']);
         //如果没有
        $areaTree = $action->tree_list();
        $rootId = !empty($areaTree) ? $areaTree[0]['id'] : '';
        $rootName = !empty($areaTree) ? g2u($areaTree[0]['text']) : '系统根部门';
        $this->assign('areaid',$rootId);
        $this->assign('areaname',$rootName);
    }
    //执法查询
    public function law_query()
    {
        $this->assignInfo();
        $this->display('law_query');
    }
    //典型案列
    public function typical_case()
    {
        $this->assignInfo();
        $this->display('typical_case');
    }
    /**
     * 统计数据，根据权限排除不是自己能管理的警员
     * @param  array $where  筛选条件
     * @param  string $field  搜索字段
     * @param  string $group  分组
     * @param  int $areaid 部门ID
     * @param  string $order 排序
     * @param  string $jybh 多个用,号隔开   123,1236,12311
     * @return array   没有符合条件的警员  error 其他返回数据 无法保证一定有数据
     */
    public function media_info_sta($where,$field='',$group,$areaid='',$order,$jybh='')
    {
        $empsinfo = $this->emps_s_info($areaid);
        if($empsinfo['total'] <1){
            $res['error'] = '没有警员信息可查看';
            $this->ajaxReturn($res);
        }
        $total = $empsinfo['total'];
        $allowCodes = $empsinfo['allowCodes'];
        if($jybh != ''){
            $jybh = explode(',', $jybh);
            $allowCodes = array_intersect($jybh,$allowCodes);
        }
        if(!empty($allowCodes)){
            $data['error'] = '没有警员信息可查看';
            return $data;
        }
        $db = D($this->models['pe_video_list']);
        //检索文件是不要用in  没有索引是全文检索  速度会很慢
        foreach ($allowCodes as $allowCode) {
            $where['jybh'][] = array('EQ',$allowCode);
        }
        $where['jybh'][] = 'OR';

        if($field != '')  $db = $db->field($field);

        $data = $db->where($where)->group($group)->order($order)->select();
        $data['emps'] = $allowCodes;
        return $data;
    }
    /**
     * 允许的警员信息进行缓存，根据部门ID,登录用户进行缓存
     * @param  int $areaid 部门ID
     * @return array
     */
    public function emps_s_info($areaid='')
    {
        if(!S(session('user').'search_area'.$areaid) || !S(session('user').'total')){
            $action = A($this->actions['employee']);
            $emps = $action->get_manger_emp($areaid);
            $allowCodes = array_keys($emps);
            //根据登录用户，检索区域，保存缓存5分钟
            S(session('user').'search_area'.$areaid,$allowCodes,5*60);
            $total = count($allowCodes);
            S(session('user').'total',$total,5*60);
        }else{
            $total = S(session('user').'total');
            $allowCodes = S(session('user').'search_area'.$areaid);
        }
        $res['total'] = $total;
        $res['allowCodes'] = $allowCodes;
        return $res;
    }
     /**
     * 显示数据，根据权限排除不是自己能管理的警员
     * @param  array $where  筛选条件
     * @param  int $page 页数
     * @param  int $rows 条数
     * @param  int $areaid 部门ID
     * @param  string $order 排序
     * @param  string $jybh 多个用,号隔开   123,1236,12311
     * @return array   没有符合条件的警员  error 其他返回数据 无法保证一定有数据
     */
    public function media_info_list($where,$page,$rows,$areaid='',$order,$jybh='')
    {
        $empsinfo = $this->emps_s_info($areaid);
        if($empsinfo['total'] <1){
            $res['error'] = '没有可统计的警员';
            return $res;
        }
        $total = $empsinfo['total'];
        $allowCodes = $empsinfo['allowCodes'];
        if($jybh != ''){
            $jybh = explode(',', $jybh);
            $allowCodes = array_intersect($jybh,$allowCodes);
        }
        if(!empty($allowCodes)){
            $data['error'] = '没有警员信息可查看';
            return $data;
        }
        $db = D($this->models['pe_video_list']);
        foreach ($allowCodes as $allowCode) {
            $where['jybh'][] = array('EQ',$allowCode);
        }
        $where['jybh'][] = 'OR';
        $data = $db->where($where)->order($order)->page($page,$rows)->select();
        $count = $db->where($where)->count('jybh');
        $res['rows'] = $data ? $data : array();
        $res['total'] = $count;
        return $res;
    }
    //民警统计
    public function emps_sta($jybhs,$where,$field='',$group,$order)
    {
        $db = D($this->models['pe_video_list']);
        if($field != '')  $db = $db->field($field);
        foreach ($jybhs as $jybh) {
            $where['jybh'][] = array('EQ',$jybh);
        }
        $where['jybh'][] = 'OR';
        $data = $db->where(u2gs($where))->group($group)->order($order)->select();

        //echo $db->getLastSql()."<br>";
        return $data;
    }
    //部门统计
    public function areas_sta($areaids,$where,$field='',$group,$order)
    {
        $db = D($this->models['pe_video_list']);
        if($field != '')  $db = $db->field($field);
        foreach ($areaids as $areaid) {
            $where['areaid'][] = array('EQ',$areaid);
        }
        $where['areaid'][] = 'OR';
        $data = $db->where(u2gs($where))->group($group)->order($order)->select();

        //echo $db->getLastSql()."<br>";
        return $data;
    }
    /**
     * 分析数据
     * @param  array $init  初始化的数据
     * @param  array $data       需要处理的数据
     * @param  array $fields     处理的字段  保存信息=>处理字段 ['nomark'=>'num','wjcd'=>'wjcd']
     * @param  array $mark      标识字段     'jybh'
     * @param  array $paress 需要分析的字段 ['wflx'=>['field'=>'num','info'=>['video'=>1]]]  field,info 为必须字段
     * @param  array $doOne  仅仅处理一次的字段 ['areaname']
     * @return array             整合之后的数据
     */
    public function pares_data($init,$data,$fields,$mark = '',$paress,$doOne)
    {
        if(empty($data) || empty($init) || $mark == '') return $init;
        foreach ($data as $info) {
            if(!empty($doOne)){
                foreach ($doOne as $k => $value) {
                    $init[$info[$mark]][$k] = $info[$value];
                }
                unset($k);
            }
            if(!empty($fields)){
                foreach ($fields as $key => $field) {
                    $init[$info[$mark]][$key] = $init[$info[$mark]][$key] + $info[$field];
                }
                unset($key);
            }
            if(!empty($paress)){
                foreach ($paress as $ke => $pares) {
                    $field = $pares['field'];
                    foreach ($pares['info'] as $key => $value) {
                        if($info[$ke] == $value){
                            $init[$info[$mark]][$key] = $init[$info[$mark]][$key] + $info[$field];
                        }
                    }
                }
            }
        }
        return $init;
    }
    /**
     * 民警工作量统计
     * @return
     */
    public function work_emp_sat()
    {
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $request['unusual'] = I('unusual',false);       //异常数据请求
        $areaid = I('areaid','');    //部门ID
        $page = I('page',1);
        $rows = I('rows',20);
        $jybh = I('jybh','');       //支持多民警查询  用,隔开
        $where['start_time'][] = array('EGT',$request['btime']);
        $where['start_time'][] = array('ELT',$request['etime']);
        $ismarkWhere = $where;
        $nomarkWhere = $where;
        //未编辑
        $nomarkWhere['mark'][] = array('EQ','无');
        $nomarkWhere['mark'][] = array('EQ','');
        $nomarkWhere['mark'][] = array('exp','is null');
        $nomarkWhere['mark'][] = array('or');
        //编辑
        $ismarkWhere['mark'][] = array('NEQ','无');
        $ismarkWhere['mark'][] = array('NEQ','');
        $ismarkWhere['mark'][] = array('exp','is not null');
        //异常数据请求
        if($request['unusual']){
            $nomarkWhere[] = $this->unusual_where();
            $ismarkWhere[] = $this->unusual_where();
        }
        //选择字段
        $field = 'jybh,wjlx,sum(wjcd) as wjcd,count(wjbh) as num,areaname';
        $empsinfo = $this->emps_s_info($areaid);
        if($empsinfo['total'] <1){
            $res['error'] = '没有可统计的警员';
            $this->ajaxReturn($res);
        }
        $total = $empsinfo['total'];
        $allowCodes = $empsinfo['allowCodes'];

        if($jybh != ''){
            $jybhs = explode(',',$jybh);
            $allowCodes = array_intersect($allowCodes,$jybhs);
        }
        //print_r($allowCodes);
        //需要检索的数据
        $satEmps = array_slice($allowCodes,($page-1)*$rows,$rows);
        if(empty($satEmps)){
            $res['error'] = '没有可统计的警员';
            $this->ajaxReturn($res);
        }
        //$satEmps = ['123456','000000'];
        $dataw = $this->emps_sta($satEmps,$nomarkWhere,$field,'wjlx,jybh', 'num desc');
        $datay = $this->emps_sta($satEmps,$ismarkWhere,$field,'wjlx,jybh', 'num desc');

        //初始化信息 总数，视频，图片，音频，未知，未编辑，已编辑,文件长度
        $initInfo = array('num'=>0,'video'=>0,'picture'=>0,'vioce'=>0,
                          'unkonwn'=>0,'nomark'=>0,'ismark'=>0,'wjcd'=>0,'name'=>'','areaname'=>'');
        $empInfo = D($this->models['employee'])->getField('code,name,areaid');
        $areaInfo = D($this->models['area'])->getField('areaid,areaname');
        foreach ($satEmps as $emp) {
            //添加警员
            $initInfo['name'] = $empInfo[$emp]['name'];
            $initInfo['areaname'] = $areaInfo[$empInfo[$emp]['areaid']];
            $satInfo[$emp] = $initInfo;
        }
        $fields = array('num'=>'num','nomark'=>'num','wjcd'=>'wjcd');
        $markField = 'jybh';
        $paresFields = array('wjlx'=>array('field'=>'num',
                                           'info'=>array('video'=>1,
                                                         'vioce'=>2,
                                                         'picture'=>3,
                                                         'unkonwn'=>0)));
        //$doOneFileds = array('areaname'=>'areaname');
        //$this->ajaxReturn(g2us($dataw));
        $satInfo = $this->pares_data($satInfo,$dataw,$fields,$markField,$paresFields);
        unset($fields['nomark']);
        $fields['ismark'] = 'num';
        $satInfo = $this->pares_data($satInfo,$datay,$fields,$markField,$paresFields);
        $res['total'] = $total;
        $res['rows'] = array_values($satInfo);
        $this->saveExcel($res); //监测是否为导出
        $this->ajaxReturn(g2us($res));
    }
    /**
     * 按部门统计
     * @return
     */
    public function area_sat()
    {
        //准备显示数据
        $where = array();
        $mooDarea = I('areaid','');
        //显示的树
        $action = A($this->actions['area']);
        $currentUserAreas = $action->all_user_area();
        $userAreas = array();
        foreach ($currentUserAreas as $currentUserArea) {
            $userAreas[] = $currentUserArea['areaid'];
        }
        $areaids = explode(',',session('userarea'));
        $areadb = D($this->models['area']);
        $parent = array(0);             //父级部门ID
        if($mooDarea != ''){
            $parent = (array)$areadb->where('areaid='.$mooDarea)->getField('fatherareaid');
            $show = $action->carea($areaid);
            //需要查询的数据
            $areaids = array_intersect($areaids,$show);
            //页面需要显示的数据
            $userAreas = array_intersect($userAreas,$show);
        }
        //准备初始化的显示数据
        $showWhere = array();
        foreach ($userAreas as $areaid) {
            $showWhere['areaid'][] = array('EQ',$areaid);
        }
        $showWhere['areaid'][] = 'OR';
        $initInfos = $areadb->field('areaid,areaname,fatherareaid as _parentId')->where($showWhere)->select();
        $satInfo = array();
        $initShow = array('num'=>0,'video'=>0,'picture'=>0,'vioce'=>0,
                          'unkonwn'=>0,'nomark'=>0,'ismark'=>0,'wjcd'=>0,'name'=>'');
        foreach ($initInfos as $initInfo) {
            $initInfo = array_merge($initInfo,$initShow);
            $satInfo[$initInfo['areaid']] = $initInfo;
        }
        //准备查询数据
        foreach ($areaids as $areaid) {
            $where['areaid'][] = array('EQ',$areaid);
        }
        $where['areaid'][] = 'OR';
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $request['unusual'] = I('unusual',false);       //异常数据请求
        $where['start_time'][] = array('EGT',$request['btime']);
        $where['start_time'][] = array('ELT',$request['etime']);
        $field = 'areaid,wjlx,sum(wjcd) as wjcd,count(wjbh) as num';
        $ismarkWhere = $where;
        $nomarkWhere = $where;
        //未编辑
        $nomarkWhere['mark'][] = array('EQ','无');
        $nomarkWhere['mark'][] = array('EQ','');
        $nomarkWhere['mark'][] = array('exp','is null');
        $nomarkWhere['mark'][] = array('or');
        //编辑
        $ismarkWhere['mark'][] = array('NEQ','无');
        $ismarkWhere['mark'][] = array('NEQ','');
        $ismarkWhere['mark'][] = array('exp','is not null');
        //异常数据请求
        if($request['unusual']){
            $nomarkWhere[] = $this->unusual_where();
            $ismarkWhere[] = $this->unusual_where();
        }
        $dataw = $this->areas_sta($areaids,$nomarkWhere,$field,'wjlx,areaid', 'num desc');
        $datay = $this->areas_sta($areaids,$ismarkWhere,$field,'wjlx,areaid', 'num desc');
        $fields = array('num'=>'num','nomark'=>'num','wjcd'=>'wjcd');
        $markField = 'areaid';
        $paresFields = array('wjlx'=>array('field'=>'num',
                                           'info'=>array('video'=>1,
                                                         'vioce'=>2,
                                                         'picture'=>3,
                                                         'unkonwn'=>0)));
        //$doOneFileds = array('areaname'=>'areaname');
        $satInfo = $this->pares_data($satInfo,$dataw,$fields,$markField,$paresFields);
        unset($fields['nomark']);
        $fields['ismark'] = 'num';
        $satInfo = $this->pares_data($satInfo,$datay,$fields,$markField,$paresFields);
        //倒叙排序 确保上级菜单 在最后执行
        $satInfo = $this->ksort_sat_data($satInfo,'_parentId',array_keys($initShow),$parent[0]);
        $res['total'] = count($userAreas);
        $res['rows'] = array_values($satInfo);
        $res = g2us($res);
        $this->saveExcel($res); //监测是否为导出
        $this->ajaxReturn($res);
    }
    /**
     * 异常数据where条件定义
     * @param  integer $sccs 超时时长
     * @param  integer $bjcs 编辑时长
     * @return where语句
     */
    public function unusual_where($sccs = 3,$bjcs = 2)
    {
        $where = array('exp','ABS(timestampdiff(day,now(),scsj)) > '.$sccs.' OR ABS(timestampdiff(day,start_time,scsj)) > '.$bjcs);
        return $where;
    }
    //媒体数据显示
    public function media_list()
    {
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));   //开始时间
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));              //结束时间
        $areaid = I('areaid','');       //部门ID
        $jybh = I('jybh','');           //警员编号
        $request['wjlx'] = I('wjlx','');            //文件类型
        $request['bzlx'] = I('bzlx','');            //标注类型
        $request['mark'] = I('mark','');        //备注
        $request['unusual'] = I('unusual',false);   //异常数据请求
        $page = I('page');
        $rows = I('rows');
        $request['video_type'] = I('video_type','');    //视频类型
        //异常数据请求
        $where = array();
        if($request['unusual']){
            $where[] = $this->unusual_where();
            $where[] = $this->unusual_where();
        }
        if($request['video_type'] != '') $where['video_type'] = $request['video_type'];
        if($request['wjlx'] != '') $where['wjlx'] = $request['wjlx'];
        if($request['bzlx'] != '') $where['bzlx'] = $request['bzlx'];
        if($request['mark'] != '') $where['mark'] = array('like','%'.$request['mark'].'%');
        $where['start_time'][] = array('EGT',$request['btime']);
        $where['start_time'][] = array('ELT',$request['etime']);
        $data = $this->media_info_list($where,$page,$rows,$areaid,'start_time desc',$jybh);
        $this->ajaxReturn(g2us($data));
    }
    //数据更新
    public function media_update()
    {
        $request = I();
        $wjbhs = explode(',',$request['wjbh']);
        $where = $this->where_key_or($wjbhs,'wjbh');
        $db = D($this->models['pe_video_list']);
        $result = $db->getTableEdit($request);
        $this->write_log('更新文件'.$request['wjbh'],$this->logContent);
        $this->ajaxReturn($result);
    }
    //数据更新
    public function media_remove()
    {
        $request = I();
        $wjbhs = explode(',',$request['wjbh']);
        $where = $this->where_key_or($wjbhs,'wjbh');
        $db = D($this->models['pe_video_list']);
        $result = $db->getTableDel($request);
        $this->write_log('删除文件'.$request['wjbh'],$this->logContent);
        $this->ajaxReturn($result);
    }
    /**
     * 按照需求上下级进行数据叠加
     * @param  array $data   [id]=>['id'=>id,'num'=>num,'pid'=>pid]
     * @param  string $pidFiled pid字段
     * @param  array $fields 需要叠加的字段
     * @return array         格式化之后的数据
     */
    public function ksort_sat_data($data,$pidFiled,$fields,$root)
    {
        krsort($data);
        foreach ($data as $key => $value) {
            $checkArr[$value[$pidFiled]][] = $key;
        }
        foreach ($data as $key => $value) {
            if($data[$key]['_parentId'] == $root)  unset($data[$key]['_parentId']);
            if(empty($checkArr[$key])) continue;
            foreach ($checkArr[$key] as $val) {
                foreach ($fields as $field) {
                    $data[$key][$field] = $data[$key][$field]+$data[$val][$field];
                }
            }
        }
        return $data;
    }
}
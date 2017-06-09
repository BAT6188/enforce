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
    //单文件播放页面
    public function play_video()
    {
        $wjbh = I('wjbh');
        $db = D($this->models['pe_video_list']);
        $where['wjbh'] = u2g($wjbh);
        $videoInfo = $db->where($where)->find();
        $this->assign('videoInfo',$videoInfo);
        $this->disolay('play_video');
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
         if(!S(session('user').$areaid) || !S(session('user').'total')){
            $action = A($this->actions['employee']);
            $emps = $action->get_manger_emp($areaid);
            $allowCodes = array_keys($emps);
            //根据登录用户，检索区域，保存缓存5分钟
            S(session('user').$areaid,$allowCodes,5*60);
            $total = count($allowCodes);
            S(session('user').'total',$total,5*60);
        }else{
            $total = S(session('user').'total');
            $allowCodes = S(session('user').$areaid);
        }
        return compact($total,$allowCodes);
    }
     /**
     * 显示数据，根据权限排除不是自己能管理的警员
     * @param  array $where  筛选条件
     * @param  string $group  分组
     * @param  int $areaid 部门ID
     * @param  string $order 排序
     * @param  string $jybh 多个用,号隔开   123,1236,12311
     * @param  int $page 页数
     * @param  int $rows 条数
     * @return array   没有符合条件的警员  error 其他返回数据 无法保证一定有数据
     */
    public function media_info_list($where,$page,$rows,$areaid='',$order,$jybh='')
    {
        $empsinfo = $this->emps_s_info($areaid);
        if($empsinfo['total'] <1){
            $res['error'] = '没有可统计的警员';
            $this->ajaxReturn($res);
        }
        $total = $empsinfo['total'];
        $allowCodes = $empsinfo['allowCodes'];
        $db = D($this->models['pe_video_list']);
        foreach ($allowCodes as $allowCode) {
            $where['jybh'][] = array('EQ',$allowCode);
        }
        $where['jybh'][] = 'OR';
        $data = $db->where($where)->order($order)->select();
        return $data;
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
                    if($init[$info[$mark]][$k] == '') $init[$info[$mark]][$k] = $info[$value];
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
        $areaid = I('areaid','');    //部门ID
        $page = I('page');
        $page = I('rows');
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
        //选择字段
        $field = 'jybh,wjlx,sum(wjcd) as wjcd,count(wjbh) as num,areaname';
        $empsinfo = $this->emps_s_info($areaid);
        if($empsinfo['total'] <1){
            $res['error'] = '没有可统计的警员';
            $this->ajaxReturn($res);
        }
        $total = $empsinfo['total'];
        $allowCodes = $empsinfo['allowCodes'];
        //需要检索的数据
        $satEmps = array_slice($allowCodes,($page-1)*$rows,$rows);
        //$satEmps = ['123456','000000'];
        $dataw = $this->emps_sta($satEmps,$nomarkWhere,$field,'wjlx,jybh', 'num desc');
        $datay = $this->emps_sta($satEmps,$ismarkWhere,$field,'wjlx,jybh', 'num desc');

        //初始化信息 总数，视频，图片，音频，未知，未编辑，已编辑,文件长度
        $initInfo = array('num'=>0,'video'=>0,'picture'=>0,'vioce'=>0,
                          'unkonwn'=>0,'nomark'=>0,'ismark'=>0,'wjcd'=>0,'name'=>'','areaname'=>'');
        $empInfo = D($this->models['employee'])->getField('code,name');
        foreach ($satEmps as $emp) {
            //添加警员
            $initInfo['name'] = $empInfo[$emp];
            //$initInfo['areaname'] = '一中队';
            $satInfo[$emp] = $initInfo;
        }
        $fields = array('num'=>'num','nomark'=>'num','wjcd'=>'wjcd');
        $markField = 'jybh';
        $paresFields = array('wjlx'=>array('field'=>'num',
                                           'info'=>array('video'=>1,
                                                         'vioce'=>2,
                                                         'picture'=>3,
                                                         'unkonwn'=>0)));
        $doOneFileds = array('areaname'=>'areaname');
        $satInfo = $this->pares_data($satInfo,$dataw,$fields,$markField,$paresFields,$doOneFileds);
        unset($fields['nomark']);
        $fields['ismark'] = 'num';
        $satInfo = $this->pares_data($satInfo,$datay,$fields,$markField,$paresFields,$doOneFileds);
        /*//为处理数据
        foreach ($dataw as $data) {
            //添加部门
            if($satInfo[$data['jybh']]['areaname'] == '') $satInfo[$data['jybh']]['areaname'] = $data['areaname'];
            $satInfo[$data['jybh']]['num'] = $satInfo[$data['jybh']]['num'] + $data['num'];
            $satInfo[$data['jybh']]['nomark'] = $satInfo[$data['jybh']]['nomark'] + $data['num'];
            $satInfo[$data['jybh']]['wjcd'] = $satInfo[$data['jybh']]['num'] + $data['wjcd'];
            if($data['wjlx'] == 1){
                $satInfo[$data['jybh']]['video'] = $satInfo[$data['jybh']]['video'] + $data['num'];
            }
            if($data['wjlx'] == 2){
                $satInfo[$data['jybh']]['vioce'] = $satInfo[$data['jybh']]['vioce'] + $data['num'];
            }
            if($data['wjlx'] == 3){
                $satInfo[$data['jybh']]['picture'] = $satInfo[$data['jybh']]['picture'] + $data['num'];
            }
            if($data['wjlx'] == 0){
                $satInfo[$data['jybh']]['unkonwn'] = $satInfo[$data['jybh']]['unkonwn'] + $data['num'];
            }
        }
        //处理数据
        foreach ($datay as $data) {
            //添加部门
            if($satInfo[$data['jybh']]['areaname'] == '') $satInfo[$data['jybh']]['areaname'] = $data['areaname'];
            $satInfo[$data['jybh']]['num'] = $satInfo[$data['jybh']]['num'] + $data['num'];
            $satInfo[$data['jybh']]['ismark'] = $satInfo[$data['jybh']]['ismark'] + $data['num'];
            $satInfo[$data['jybh']]['wjcd'] = $satInfo[$data['jybh']]['num'] + $data['wjcd'];
            if($data['wjlx'] == 1){
                $satInfo[$data['jybh']]['video'] = $satInfo[$data['jybh']]['video'] + $data['num'];
            }
            if($data['wjlx'] == 2){
                $satInfo[$data['jybh']]['vioce'] = $satInfo[$data['jybh']]['vioce'] + $data['num'];
            }
            if($data['wjlx'] == 3){
                $satInfo[$data['jybh']]['picture'] = $satInfo[$data['jybh']]['picture'] + $data['num'];
            }
            if($data['wjlx'] == 0){
                $satInfo[$data['jybh']]['unkonwn'] = $satInfo[$data['jybh']]['unkonwn'] + $data['num'];
            }
        }*/
        $res['total'] = $total;
        $res['rows'] = array_values($satInfo);
        $this->ajaxReturn($res);
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
        if($mooDarea != ''){
            $show = $action->carea($areaid);
            //需要查询的数据
            $areaids = array_intersect($areaids,$show);
            //页面需要显示的数据
            $userAreas = array_intersect($userAreas,$show);
        }
        foreach ($areaids as $areaid) {
            $where['areaid'][] = array('EQ',$areaid);
        }
        $where['areaid'][] = 'OR';
        //准备初始化的数据
        $areadb = D($this->models['area']);
        $initInfos = $areadb->field('areaid,areaname,fatherareaid')->where($where)->select();
        $satInfo = array();
        foreach ($initInfos as $initInfo) {
            $satInfo[$initInfo['areaid']] = $initInfo;
        }
        //准备查询数据
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
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
        $dataw = $this->emps_sta($areaids,$nomarkWhere,$field,'wjlx,areaid', 'num desc');
        $datay = $this->emps_sta($areaids,$ismarkWhere,$field,'wjlx,areaid', 'num desc');
        $fields = array('num'=>'num','nomark'=>'num','wjcd'=>'wjcd');
        $markField = 'areaid';
        $paresFields = array('wjlx'=>array('field'=>'num',
                                           'info'=>array('video'=>1,
                                                         'vioce'=>2,
                                                         'picture'=>3,
                                                         'unkonwn'=>0)));
        //$doOneFileds = array('areaname'=>'areaname');
        $satInfo = $this->pares_data($satInfo,$dataw,$fields,$markField,$paresFields,$doOneFileds);
        unset($fields['nomark']);
        $fields['ismark'] = 'num';
        $satInfo = $this->pares_data($satInfo,$datay,$fields,$markField,$paresFields,$doOneFileds);
        $res['total'] = $total;
        $res['rows'] = array_values($satInfo);
        $this->ajaxReturn($res);
    }
    
}
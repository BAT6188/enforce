<?php
namespace Home\Controller;

class EmployeeController extends CommonController
{
    //表的表名-自增主键
    protected $tab_id = 'empid';
    protected $models = ['employee'=>'Enforce\Employee',    //警员
                         'area'=>'Enforce\AreaDep'];           //部门
    protected $actions = ['area'=>'Area',
                          'role'=>'Role'];
    protected $views = ['index'=>'employee'];
    //展示
    public function index()
    {
        $action = A($this->actions['area']);
        //如果没有
        $areaTree = $action->tree_list();
        $rootId = !empty($areaTree) ? $areaTree[0]['id'] : 0;
        $rootName = !empty($areaTree) ? g2u($areaTree[0]['text']) : '系统根部门';
        $this->assign('areaid',$rootId);
        $this->assign('areaname',$rootName);
        $this->assignInfo();
        $this->display($this->views['index']);
    }
   	public function showPhoto(){
   		$ucTab = ucwords($this->tab);
        $url['datagridUrl'] = U($ucTab.'/dataList');
        $url['addUrl'] = U($ucTab.'/dataAdd');
        $url['editUrl'] = U($ucTab.'/dataEdit');
        $url['removeUrl'] = U($ucTab.'/dataRemove');
        $url['uplaodImgUrl'] = U($ucTab.'/uplaodImg');
        $url['get_empImagesUrl'] = U($ucTab.'/get_empImages');
        $url['removeImageUrl'] = U($ucTab.'/removeImage');
        $this->assign('url',$url);
        $this->assignInfo();
        $this->display('showPhoto');
   	}
    //数据获取
    public function dataList()
    {
        $request = I();
        $request = u2gs($request);
        $page = I('page');
        $rows = I('rows');
        unset($request['page'],$request['rows'],$request['rand']);
        if(!empty($request)){
            foreach($request as $key=>$value){
                if($key != 'areaid'){
                    $check[$key] = array('like','%'.$value.'%');
                }
            }
        }
        $db = D($this->models['employee']);

        $dbc = D($this->models['area']);
        $areaid = $request['areaid'];
        //初始数据展示限制只显示自身和下级角色
        $where['areaid'] = $areaid;
        $data = $dbc->where($where)->select();
        $areas = $dbc->getField('areaid,areaname');
        $l_arr = [0=>'areaid',1=>'fatherareaid'];
        $info_f = $this->getChData($data,$this->models['area'],$l_arr);
        $info_f= array_merge($data,$info_f);
        $all_list = array();
        foreach ($info_f as  $info_c) {
            $all_list[] = $info_c['areaid'];
        }
        //实际管理区域
        $c_area = explode(',', session('userarea'));
        $all_list = array_intersect($c_area, $all_list);
        $check['areaid'] = array('in',$all_list);
        $data = $db->getTableList($check,$page,$rows);
        foreach ($data['rows'] as &$value) {
            $value['areaname'] = array_key_exists($value['areaid'],$areas) ? $areas[$value['areaid']]  : u2g('系统根区域');
        }
        $this->ajaxReturn(g2us($data));
    }
    //增加事件
    public function dataAdd()
    {
        $request = I();
        if($_FILES['photo']['name']){
            $res = $this->save_image($_FILES['photo']);
            if($res){
                $request['photo_path'] = $res;
            }else{
                $info = '照片保存失败，可能原因服务器权限不足，';
            }
        }
        $request['password'] = I('code');           //登录密码 默认为警号
        $db = D($this->models['employee']);
        if($db->where('code ='.$request['code'])->find()){
            $result['message'] = '该警员已经录入！';
            exit(json_encode($result));
        }
        $c_area = explode(',', session('userarea'));
        if(in_array($request['areaid'],$c_area)){
            $result = $db->getTableAdd(u2gs($request));
        }else{
            $result['message'] = '对不起，你无法向该部门添加警员！因为该部门不在你的管辖范围，或者不全在管辖范围';
        }
        if($info)  $result['message'] .= $info;
        exit(json_encode($result));
    }
    //删除事件
    public function dataRemove()
    {
        $request = I();
        $db = D($this->models['employee']);
        if($request[$this->tab_id] == ''){
            $result['message'] = '删除数据不能为空';
            $this->ajaxReturn($result);
        }
        $where = $this->tab_id.' in('.$request[$this->tab_id].')';
        $photos = $db->where($where)->getField('photo_path',true);
        foreach ($photos as  $photo) {
            unlink('./Public/'.$photo);
        }
        //删除初始表数据
        $result = $db->getTableDel($where);
        $this->ajaxReturn($result);
    }
    //编辑事件
    public function dataEdit()
    {
        $request = I();
        $db = D($this->models['employee']);
        if($_FILES['photo']['name']){
            $res = $this->save_image($_FILES['photo']);
            if($res){
                $request['photo_path'] = $res;
                //照片更新时删除原来的照片
                $photoPath = $db->where('empid = '.$request['empid'])->getField('photo_path');
                unlink('./Public/'.$photoPath);
            }else{
                $info = '照片保存失败，可能原因服务器权限不足，';
            }
        }
        $request = u2gs($request);
        
        $where[$this->tab_id] = $request[$this->tab_id];
        unset($request[$this->tab_id]);
        $result = $db->getTableEdit($where,$request);
        if($info)  $result['message'] .= $info;
        exit(json_encode($result));
    }
    //准备前端页面数据
    public function assignInfo()
    {
        $db = D($this->models['area']);
        $info['areareg'] = $db->select();
        $info['areareg'] = g2us($info['areareg']);
        $info['arearegJson'] = json_encode(g2us($info['areareg']));
        $action = A($this->actions['role']);
        $check['type'] = 1;
        //警员记录
        $info['role'] = $action->get_role_info($check)['rows'];
        $info['role'] = g2us($info['role']);
        $info['roleJson'] = json_encode($info['role']);
        $this->assign('info',$info);
    }
    /**
     * 保存图片
     * @param  array $file    包含图片的所有信息
     * @param  string $imagename 保存图片名
     * @return string          保存结果
     */
    public function save_image($file,$imagename)
    {
        //2w张分目录
        $upload = new \Think\Upload(); //实例化上传类
        $upload->maxSize = 3145728; //设置附件上传大小
        $upload->exts = array('jpg', 'gif', 'png', 'jpeg','ico'); //设置附件上传类型

        $upload->autoSub = false;
        //$upload->subName = ''; //设置上传子目录
        $upload->replace = true; //设置是否覆盖上传文件
        //$upload->saveName = $imagename; //设置上传文件名
        $upload->rootPath = './Public/upload/'; //设置上传文件位置
        //$upload->savePath = (string)$subName; // 设置附件上传目录
        // 上传文件
        $result = $upload->uploadOne($file);
        return $result ? 'upload/'.$result['savepath'].$result['savename'] : false;  //$upload->getError();
    }
    /**
     * 显示警员管理的部门
     * @param  int $empid 警员ID
     * @return
     */
    public function show_emp_manger_area()
    {
        $empid  = I('empid');
        $action = A($this->actions['area']);
        $empdb = D($this->models['employee']);
        $areaid = $empdb->where('empid='.$empid)->getField('areaid');
        $careas = $action->carea($areaid);
        $pareas = $action->parea($areaid);
        $areas = array_merge($careas,$pareas);
        $db = D($this->models['area']);
        $where['areaid'] = array('in',$areas);
        $areas = $db->where($where)->select();
        $ids = array(0);
        //$l_arr 保存菜单的一些信息  0-id  1-text 2-iconCls 3-fid 4-odr
        $l_arr = ['areaid','areaname','fatherareaid','areaid'];
        //$L_attributes 额外需要保存的信息
        //$L_attributes = ['arearcode','rperson','rphone'];
        $icons = ['icon-map_go','icon-map'];
        $noclose = $db->where('fatherareaid = 0')->getField('areaid',true);
        $checks = $empdb->where('empid='.$empid)->getField('userarea');
        $checks = explode(',',$checks);
        $data_tree = $this->formatTree($ids,$areas,$l_arr,'',$checks,$icons,$noclose);
        $this->ajaxReturn(g2us($data_tree));
    }
    /**
     * 保存员工的权限信息
     * @param  
     * @return
     */
    public function save_other_info()
    {
        $request = I();
        //如果分配区域
        if($request['userarea']){
            
        }
    }
    //获取员工图片
    public function get_empImages()
    {
        $empid = I('empid');
        $emph_db = D($this->photo_tab);
        $where['empid'] = $empid;
        $res = $emph_db->where($where)
             ->join($this->photolib_tab.' ON '.$this->photo_tab.'.employeephoid = '.$this->photolib_tab.'.employeephoid')
             ->select();
        $this->ajaxReturn($res);
    }

    public function removeImage()
    {
        $request = I();
        $removeImage = $request['photo'];

        $removeImage = $this->parse_file($removeImage);
        $emph_db = D($this->photo_tab);
        $phlib_db = D($this->photolib_tab);
        $where = 'employeephoid in('.$request['employeephoid'].')';
        $res = $emph_db->where($where)->delete();
        $resu = $phlib_db->where($where)->delete();
        if($res && $resu){
            $result['message'] = '删除成功';
            unlink($removeImage);
        }else{
            $result['message'] = '删除失败';
        }
        $this->ajaxReturn($result);
    }
    /**
     * 根据图片的http地址分析出本机图片地址
     * @param  string $fileUrl 图片http地址
     * @return string           本机图片地址
     */
    public function parse_file($fileUrl)
    {
        $removeImageArr = explode('/', $fileUrl);
        unset($removeImageArr[0],$removeImageArr[1],$removeImageArr[2]);
        $removeImage = '/'.implode('/', $removeImageArr);
        return $_SERVER['CONTEXT_DOCUMENT_ROOT'].$removeImage;
    }
    /**
     *
     * @return
     */
    public function show_employee()
    {
        $empDb = D($this->models['employee']);
        //普通用户信息展示
        if(session('usertype') == 'normal'){
            //当前用户的管理区域
            $action = A($this->actions['area']);
            $userarea = $action->tree_list();    //easyui tree
            //dump($userarea);
            $c_area = explode(',', session('userarea'));        //实际管理区域
            $where['areaid'] = array('in',$c_area);

            $emps = $empDb->where($where)->select();
            //dump($emps);
            $l_arr = ['areaid','empid','name'];
            $icon = 'icon-user';
            $empAreaTree = $this->add_other_info($userarea,$emps,$l_arr,$icon);
            $this->ajaxReturn($empAreaTree);
        }
        //警员信息展示
        if(session('usertype') == 'police'){
            $empInfo = $empDb->where($where)->find();
            $nowareaid = $empInfo['areaid'];
            $areaDb = D($this->models['area']);
            $request['areaid'] = $nowareaid;
            $arearInfo = $areaDb->where($request)->select();
            $l_arr = ['areaid','fatherareaid'];
            $areas = $this->getParentData($arearInfo,$this->link_tab,$l_arr);
            $areas[] = $arearInfo[0];
            $ids = array(0);
            //$l_arr 保存菜单的一些信息  0-id  1-text 2-iconCls 3-fid 4-odr
            $l_arr = ['areaid','areaname','fatherareaid','areaid'];
            //$L_attributes 额外需要保存的信息
            $L_attributes = ['arearcode','rperson','rphone'];
            $icons = ['icon-map_go','icon-map'];
            $data_tree = $this->formatTree($ids,$areas,$l_arr,$L_attributes,'',$icons);

            //dump($emps);
            $emps[] = $empInfo;
            $l_arr = ['areaid','empid','name'];
            $icon = 'icon-user';
            $empAreaTree = $this->add_other_info($data_tree,$emps,$l_arr,$icon);
            $this->ajaxReturn($empAreaTree);
        }
    }
}
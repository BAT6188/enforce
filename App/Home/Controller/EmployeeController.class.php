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
        $request['password'] = I('code');           //登录密码 默认为警号
        $db = D($this->models['employee']);
        $c_area = explode(',', session('userarea'));
        if(in_array($request['areaid'],$c_area)){
            $result = $db->getTableAdd(u2gs($request));
        }else{
            $result['message'] = '对不起，你无法向该部门添加警员！因为该部门不在你的管辖范围，或者不全在管辖范围';
        }
        $this->ajaxReturn($result);
    }
    //删除事件
    public function dataRemove()
    {
        $request = I();
        $db = D($this->models['employee']);
        $where = $this->tab_id.' in('.$request[$this->tab_id].')';
        //关联表
        $emph_db = D($this->photo_tab);
        $phlib_db = D($this->photolib_tab);
        $employeephoids = $emph_db->where($where)->getField('employeephoid',true);
        if(!empty($employeephoids)){
            //删除$this->photolib_tab $this->photo_tab相关数据
            $requests['employeephoid'] = array('in',$employeephoids);
            $phlib_db->where($requests)->delete();

            $photos = $emph_db->where($where)->getField('photo',true);
            foreach ($photos as $value) {
                $removeImage = $this->parse_file($value);
                unlink($removeImage);
            }
            $emph_db->where($where)->delete();
        }
        //删除初始表数据
        $result = $db->getTableDel($where);
        $this->ajaxReturn($result);
    }
    //编辑事件
    public function dataEdit()
    {
        $request = I();
        $request = u2gs($request);
        $db = D($this->models['employee']);
        $where[$this->tab_id] = $request[$this->tab_id];
        unset($request[$this->tab_id]);
        $result = $db->getTableEdit($where,$request);
        $this->ajaxReturn($result);
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
//上传图片
    public function uplaodImg()
    {
        $data = I();
        $num = count($_FILES['photo']['name']);
        $emph_db = D($this->photo_tab);
        $phlib_db = D($this->photolib_tab);
        $emph_data['empid'] = $data['empid'];

        if($num <= 0 ) {
            $result['message'] = '请选择图片再添加';
            $this->ajaxReturn($result);
            return false;
        }
        //检查能上传图片张数
        $total = $emph_db->where($emph_data)->count();
        if((int)((int)$total + (int)$num) > 5 ){
            $maxNum = 5 - (int)$total;
            $result['message'] = '图片上传失败，还能上传'.$maxNum.'张图片！';
            $this->ajaxReturn($result);
            return false;
        }
        //获取单文件信息
        $images = array();
        for ($i=0; $i < $num; $i++) {
            $addIds[] = $emph_db->add($emph_data);
            foreach ($_FILES['photo'] as $key => $value) {
                $images[$i][$key] = $value[$i];
            }

        }
        //保存图片信息
        foreach ($images as $key => $value) {
            $res = $this->save_image($value,$addIds[$key]);
            if($res){
                $where['employeephoid'] = $addIds[$key];
                //'http://'.$_SERVER['SERVER_ADDR'].
                $host = isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : (isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : '');
                $insertData['photo'] = 'http://'.$host.__ROOT__.'/Public/lib/'.$res;
                $emph_db->where($where)->save($insertData);
                $where['libid'] = $data['photolib'];
                $where['libnum'] = -1;
                $phlib_db->add($where);
                $result['message'] = '图片上传成功';
            }else{
                $result['message'] = '图片上传失败，可能原因：文件类型错误，服务器权限问题！';
            }
        }
        $this->ajaxReturn($result);
    }
    /**
     * 保存图片
     * @param  array $file    包含图片的所有信息
     * @param  int/string $imageId 保存图片的id
     * @return string          保存结果
     */
    public function save_image($file,$imageId)
    {
        //2w张分目录
        $subFileName = (int)((((int)$imageId-1) / 20000)+1);
        $upload = new \Think\Upload(); //实例化上传类
        $upload->maxSize = 3145728; //设置附件上传大小
        $upload->exts = array('jpg', 'gif', 'png', 'jpeg'); //设置附件上传类型

        $upload->autoSub = true;
        $upload->subName = (string)$subFileName; //设置上传子目录
        $upload->replace = true; //设置是否覆盖上传文件

        $upload->saveName = $imageId; //设置上传文件名

        $upload->rootPath = './Public/lib/'; //设置上传文件位置
        //$upload->savePath = (string)$subName; // 设置附件上传目录
        // 上传文件
        $result = $upload->uploadOne($file);
        return $result ? $result['savepath'].$result['savename'] : false;  //$upload->getError();
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
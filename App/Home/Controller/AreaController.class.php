<?php
namespace Home\Controller;

class AreaController extends CommonController
{
    protected $tab_id = 'areaid';           //表主键
    //模型
    protected $models = ['area'=>'Enforce\AreaDep',
                         'user'=>'Enforce\User',
                         'areapro'=>'Enforce\AreaPro'];
    protected $remove_link_tabs = ['enforce'=>'Enforce\Employee'];    //删除部门时需要删除的警员
    //控制器
    protected $actions = ['user'=>'User'];
    protected $views = ['index'=>'area'];
    public function index()
    {
        $areaTree = $this->tree_list();
        $rootId = !empty($areaTree) ? $areaTree[0]['id'] : 0;
        $rootName = !empty($areaTree) ? g2u($areaTree[0]['text']) : '系统根部门';
        $this->assign('areaid',$rootId);
        $this->assign('areaname',$rootName);
        $this->display($this->views['index']);
    }

    public function dataList()
    {
        $request = I();
        $request = u2gs($request);
        $page = I('page');
        $rows = I('rows');
        unset($request['page'],$request['rows'],$request['rand']);
        if(!empty($request)){
            foreach($request as $key=>$value){
                if($key!='areaid')
                    $check[$key] = array('like','%'.$value.'%');
            }
        }
        $db = D($this->models['area']);

        $userarea = $this->userarea();

        $areaid = $request['areaid'];
        //初始数据展示限制只显示自身和下级角色
        $all_list = $this->carea($areaid);
        //将不属于自身区域的数据排除
        $all_list = array_intersect($all_list, $userarea);

        $check['areaid'] = array('in',$all_list);
        $data['total'] = 0;
        $data['rows'] = array();
        if(!empty($all_list)){
            $order = 'areaid asc';
            $data = $db->getTableList($check,$page,$rows,$order);
            $areas = $db->getField('areaid,areaname');
            foreach ($data['rows'] as &$value) {
                $value['pareaname'] = array_key_exists($value['fatherareaid'], $areas) ? $areas[$value['fatherareaid']] : u2g('系统根区域');
            }
        }
        $this->ajaxReturn(g2us($data));
    }

    public function dataAdd()
    {
        $request = I();
        $db = D($this->models['area']);
        $userarea = $this->userarea();
        $result = $db->getTableAdd(u2gs($request));
        $add_area = $result['add_id'];
        //增加时将所有自身,父用户添加相关区域
        $link_db = D($this->models['user']);
        $userarea[] = $add_area;
        $data['userarea'] = implode(',', $userarea);
        $where['userid'] = session('userid');
        $link_db->getTableEdit($where,$data);

        $puserarea = $this->puserarea();
        foreach ($puserarea as $key => $value) {
            $value[] = $add_area;
            $data['userarea'] = implode(',', $value);
            $where['userid'] = $key;
            $link_db->getTableEdit($where,$data);
        }
        $this->ajaxReturn($result);
    }

    public function dataRemove()
    {
        $request = I();
        $db = D($this->models['area']);
        $userarea = $this->userarea();
        $removearea = explode(',', $request[$this->tab_id]);
        //算出用户管理的区域与要删除的区域的交集 得到真正能删除的区域
        $intersect = array_intersect($removearea,$userarea);
        if(!empty($intersect)){
            $link_db = D($this->models['user']);
            //删除时将所有自身,父,子用户包含相关区域一起删除 保留剩下的区域
            $holdArae = array_diff($userarea, $intersect);
            $data['userarea'] = implode(',', $holdArae);
            $check['userid'] = session('userid');
            $result = $link_db->getTableEdit($check,$data);
            $puserarea = $this->puserarea();
            foreach ($puserarea as $key => $value) {
                $holdArae = array_diff($value, $intersect);
                $data['userarea'] = implode(',', $holdArae);
                $check_p['userid'] = $key;
                $result = $link_db->getTableEdit($check_p,$data);
            }
            $cuserarea = $this->cuserarea();
            foreach ($cuserarea as $key => $value) {
                $holdArae = array_diff($value, $intersect);
                $data['userarea'] = implode(',', $holdArae);
                $check_c['userid'] = $key;
                $result = $link_db->getTableEdit($check_c,$data);
            }
            $where[$this->tab_id] = array('in',$intersect);
            $result = $db->getTableDel($where);
            //删除与区域相关表的数据
            foreach ($this->remove_link_tabs as $tab) {
                $db_rm = D($tab);
                $db_rm->getTableDel($where);
            }
        }else{
            $result['message'] = '对不起,你没有权限删除这些部门';
        }
        $this->ajaxReturn($result);
    }

    public function dataEdit()
    {
        $request = I();
        $db = D($this->models['area']);
        $where[$this->tab_id] = $request[$this->tab_id];
        unset($request[$this->tab_id]);
        $result = $db->getTableEdit($where,u2gs($request));
        $this->ajaxReturn($result);
    }
    //获取自身展示部门
    public function all_user_area()
    {
        $db = D($this->models['area']);
        $userarea = $this->userarea();
        $data_f = array();
        $data_s = array();
        if(!empty($userarea)){
            $where['areaid'] = array('in',$userarea);
            $data_f = $db->where($where)->select();
        }
        if(!empty($data_f)){
            $lc=['areaid','fatherareaid'];
            $data_s = $this->getParentData($data_f,$this->models['area'],$lc);
        }
        if(!empty($data_s)){
            $data = array_merge($data_f,$data_s);
        }else{
            $data = $data_f;
        }
        return $data;
    }
    /**
     * 获取当前用户管理区域
     * @return array easyui-tree
     */
    public function tree_list()
    {
        $db = D($this->models['area']);
        $data = $this->all_user_area();
        $ids = array(0);
        //$l_arr 保存菜单的一些信息  0-id  1-text 2-iconCls 3-fid 4-odr
        $l_arr = ['areaid','areaname','fatherareaid','areaid'];
        //$L_attributes 额外需要保存的信息
        $L_attributes = ['arearcode','rperson','rphone'];
        $icons = ['icon-map_go','icon-map'];
        $noclose = $db->where('fatherareaid = 0')->getField('areaid',true);
        $data_tree = $this->formatTree($ids,$data,$l_arr,$L_attributes,'',$icons,$noclose);
        return $data_tree;
    }
    //前端请求
    public function data_tree_list()
    {
        $data_tree = $this->tree_list();
        $this->ajaxReturn(g2us($data_tree));
    }
    /**
     * 所有部门加上  自身管理的权限
     * @return
     */
    public function tree_list_all()
    {
        $userid = I('userid');
        $action = A($this->actions['user']);
        $m_userarea = $action->m_userarea($userid);
        $m_userarea = explode(',', $m_userarea);
        $db = D($this->models['area']);
        $area_all = $db->select();
        $ids = array(0);
        //$l_arr 保存菜单的一些信息  0-id  1-text 2-iconCls 3-fid 4-odr
        $l_arr = ['areaid','areaname','fatherareaid','areaid'];
        //$L_attributes 额外需要保存的信息
        $L_attributes = [];
        $icons = ['icon-map_go','icon-map'];
        $noclose = array(0);
        $data_tree = $this->formatTree($ids,$area_all,$l_arr,$L_attributes,$m_userarea,$icons,$noclose);
        $this->ajaxReturn(g2us($data_tree));
    }

    public function userarea()
    {
        $action = A($this->actions['user']);
        return $action->s_userarea();
    }
    /**
     * 子用户管理区域
     * @return array 用户id=>管理区域
     */
    public function cuserarea()
    {
        $action = A($this->actions['user']);
        $cuser = $action->cuser(session('userid'));
        $cuserarea = array();
        foreach ($cuser as $value) {
            $area = explode(',', $value['userarea']);
            $cuserarea[$value['userid']] =  $area;
        }
        return $cuserarea;
    }
    /**
     * 父用户管理区域
     * @return array 用户id=>管理区域
     */
    public function puserarea()
    {
        $action = A($this->actions['user']);
        $cuser = $action->puser(session('userid'));
        $puserarea = array();
        foreach ($cuser as $value) {
            $area = explode(',', $value['userarea']);
            $puserarea[$value['userid']] =  $area;
        }
        return $puserarea;
    }
    /**
     * 获取目标区域的子区域及自身
     * @param  int $areaid 目标区域
     * @return array
     */
    public function carea($areaid)
    {
        $db = D($this->models['area']);
        $where['areaid'] = $areaid;
        $data = $db->where($where)->select();
        $l_arr = [0=>'areaid',1=>'fatherareaid'];
        $info_f = $this->getChData($data,$this->models['area'],$l_arr);
        $info_f = array_merge($data,$info_f);
        $all_list = array();
        foreach ($info_f as  $info_c) {
            $all_list[] = $info_c['areaid'];
        }
        return $all_list;
    }
}
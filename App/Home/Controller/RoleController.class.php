<?php
namespace Home\Controller;

class RoleController extends CommonController
{
    protected $tab_id = 'roleid';
    protected $models = ['role'=>'Enforce\Role',
                         'user'=>'Enforce\User'];
    protected $views = ['index'=>'role'];
    public function index()
    {
        $this->display($this->views['index']);
    }

    public function dataList()
    {
        $request = I();
        $page = I('page');
        $rows = I('rows');
        //$where = $request['rolename'] ? 'rolename like \'%'.$request['rolename'].'%\'' : null;
        if($request['rolename']){
            $check['rolename'] = array('like','%'.$request['rolename'].'%');
        }
        $data = $this->get_role_info($check,$page,$rows);
        $this->ajaxReturn(g2us($data));
    }

    public function get_role_info($check,$page,$rows)
    {
        $db = D($this->models['role']);
        //初始数据展示限制只显示自身和下级角色
        $where['roleid'] = session('roleid');
        $data = $db->where($where)->select();
        $l_arr = [0=>'roleid',1=>'proleid'];
        $info_f = $this->getChData($data,$this->models['role'],$l_arr);
        $info_f= array_merge($data,$info_f);
        $all_list = array();
        foreach ($info_f as  $info_c) {
            $all_list[] = $info_c['roleid'];
        }
        $check['roleid'] = array('in',$all_list);
        return $db->getTableList($check,$page,$rows);
    }
    public function dataAdd()
    {
        $request = I();
        $db = D($this->models['role']);
        $where['rolename'] = $request['rolename'];
        if($db->checkExistence($where)){
            $result['message'] = '角色已存在！换一个吧';
            $result['status']  = true;
        }else{
            $request['proleid'] = session('roleid');
            $result = $db->getTableAdd($request);
        }
        $this->ajaxReturn($result);
    }

    public function dataRemove()
    {
        $request = I();
        $db = D($this->models['role']);
        $roles = explode(',',$request[$this->tab_id]);
        if(in_array(1, (array)$roles) || in_array(2, (array)$roles)){
            $result['message'] = '删除失败，无法删除系统内置的管理员或警员角色！';
            $result['status']  = true;
            $this->ajaxReturn($result);
        }
        //检查外键表是否存在删除的角色
        $link_db = D($this->models['user']);
        $check = $link_db->where("roleid in('".$request[$this->tab_id]."')")->select();
        if(!empty($check)){
            $result['message'] = '删除失败，请先删除分配有该角色的用户！';
            $result['status']  = true;
        }else{
            $where = $this->tab_id.' in('.$request[$this->tab_id].')';
            $result = $db->getTableDel($where);
        }
        $this->ajaxReturn($result);
    }

    public function dataEdit()
    {
        $request = I();
        $db = D($this->models['role']);
        $where[$this->tab_id] = $request[$this->tab_id];
        unset($request[$this->tab_id]);
        $result = $db->getTableEdit($where,$request);
        $this->ajaxReturn($result);
    }

    public function roleMenu()
    {
        $request = I();
        $db = D($this->models['role']);
        $where[$this->tab_id] = $request[$this->tab_id];
        $menu = $db->where($where)->field('functionlist')->find();
        //$menu = $db->where($where)->field('functionlist')->find();
        echo $menu ? $menu['functionlist'] : '';
        exit;
    }

    public function saveMenu()
    {
        $request = I();
        $db = D($this->models['role']);
        /*$check['roleid'] = session('roleid');
        $fun = $db->where($check)->find();*/
        $userfun = explode(',', session('menu'));
        $putfun = explode(',', $request['functionlist']);
        //计算出权限赋值与当前用户实际拥有权限的交集
        $intersect = array_intersect($putfun,$userfun);
        $savefun['functionlist'] = implode(',', $intersect);
        $where[$this->tab_id] = $request[$this->tab_id];
        unset($request[$this->tab_id]);
        $result = $db->getTableEdit($where,$savefun);
        $this->ajaxReturn($result);
    }
}
<?php
namespace Home\Controller;

class IndexController extends CommonController {

    public function index()
    {
        if(!(session('?role'))){
            $this->redirect('Index/login');
            exit;
        }
        $name = M('functionreg')->getField('funname');

        $action = A('Functionreg');

    	  $menus = $action->getFunList();

    	  $this->assign('menus',$menus);
        $this->display();
    }

    public function login()
    {
        $info = '';
        if(IS_POST){
            $request = I();
            $db = D('Userreg');
            //验证登录用户
            $result = $db->check_exist($request);
            $roleDb = D('Rolereg');
            if($result){
                $ip = get_client_ip();
                if($result['bindingip'] == 1){
                    if($ip != $result['clientip']){
                        $info = '请在指定IP登录';
                        $this->assign('info',$info);
                        $this->display();
                        exit;
                    }
                }
                //用户验证
                $data['state'] = date('Y-m-d H:i:s');
                $where['userid'] = $result['userid'];
                $db->getTableEdit($where,$data);
                $where['roleid'] = $result['roleid'];
                $roleData = $roleDb->where($where)->field('rolename,functionlist')->find();
                if(!empty($roleData)){
                    session('menu',$roleData['functionlist']);
                    session('role',$roleData['rolename']);
                    session('user',$result['username']);
                    session('roleid',$result['roleid']);
                    session('userid',$result['userid']);
                    session('userarea',$result['userarea']);
                    session('usertype','normal');       //登陆用户属性
                    $this->redirect('Index/index');
                    exit;
                }else{
                    $info = '用户名，密码错误';
                }
            }else{
                //警员验证
                $where['code'] = I('username');
                $where['password'] = I('userpassword');
                $empDb = D('employee');
                $res = $empDb->where($where)->find();
                if($res){
                    $roleData = $roleDb->where('roleid = 2')->field('rolename,functionlist')->find();
                    session('role',$roleData['rolename']);
                    session('menu',$roleData['functionlist']);
                    session('user',$res['name']);
                    session('code',I('username'));
                    session('usertype','police');       //登陆用户属性
                    $this->redirect('Index/index');
                    exit;
                }else{
                    $info = '用户名，密码错误';
                }
            }
        }
        $this->assign('info',$info);
        $this->display();
    }

    public function loginOut()
    {
        session(null);
        $this->redirect('Index/login');
    }
    public function change_password()
    {
        $newPassword = I('newpassword');
        $result['status'] = false;
        if(session('usertype') == 'normal'){
            $db = D('Userreg');
            $where['username'] = session('user');
            $data['userpassword'] = I('newpassword');
            $res = $db->where($where)->save($data);
            if($res){
                $result['status'] = true;
            }else{
                $result['message'] = '新密码与原密码一致修改失败';
            }
        }
        if(session('usertype') == 'police'){
            $empDb = D('employee');
            $where['code'] = session('code');
            $data['password'] = I('newpassword');
            $res = $empDb->where($where)->save($data);
            if($res){
                $result['status'] = true;
            }else{
                $result['message'] = '新密码与原密码一致修改失败';
            }
        }
        $this->ajaxReturn($result);
    }
    public function home()
    {
        $this->display();
    }
}
<?php
namespace Home\Controller;

class IndexController extends CommonController {
    protected $models = ['area'=>'Enforce\Area',
                         'role'=>'Enforce\Role',
                         'user'=>'Enforce\User',
                         'employee'=>'Enforce\Employee',
                         'menu'=>'Enforce\Menu'];
    protected $actions = ['menu'=>'Menu'];
    public function index()
    {
        if(!(session('?role'))){
            $this->redirect('Index/login');
            exit;
        }
        //$name = M('functionreg')->getField('funname');

        $action = A($this->actions['menu']);
    	$menus = $action->getFunList();
    	$this->assign('menus',g2us($menus));
        $this->display();
    }

    public function login()
    {
        $this->display('login');
    }
    //验证登陆
    public function check_login()
    {
        if(IS_POST){
            $result = array();
            $result['status'] = false;
            $result['message'] = '验证失败';

            $request = I();
            $db = D($this->models['user']);
            //验证登录用户
            $res = $db->check_exist($request);
            $roleDb = D($this->models['role']);
            $ip = get_client_ip();
            if($res){
                if($res['bindingip'] == 1){
                    if($ip != $res['clientip']){
                       $res['message'] = '请在指定IP登录';
                       $this->ajaxReturn($result);
                    }
                }
                //用户验证
                $data['state'] = date('Y-m-d H:i:s');
                $where['userid'] = $res['userid'];
                $db->getTableEdit($where,$data);
                $where['roleid'] = $res['roleid'];
                $roleData = $roleDb->where($where)->field('rolename,functionlist')->find();
                if(!empty($roleData)){
                    $roleData = g2us($roleData);
                    session('menu',$roleData['functionlist']);
                    session('role',$roleData['rolename']);
                    session('user',$res['username']);
                    session('roleid',$res['roleid']);
                    session('userid',$res['userid']);
                    session('userarea',$res['userarea']);
                    session('usertype','normal');       //登陆用户属性
                    $result['status'] = true;
                    $result['message'] = '验证成功';
                }else{
                    $result['message'] = '用户名，密码错误';
                }
            }else{
                //警员验证
                $where['code'] = I('username');
                $where['password'] = I('password');
                $empDb = D($this->models['employee']);
                $res = $empDb->where($where)->find();
                if($res){
                    if($res['bindingip'] == 1){
                        if($ip != $res['clientip']){
                           $res['message'] = '请在指定IP登录';
                           $this->ajaxReturn($result);
                        }
                    }
                    $roleData = $roleDb->where('roleid = '.$res['roleid'])->field('rolename,functionlist')->find();
                    $roleData = g2us($roleData);
                    session('role',$roleData['rolename']);
                    session('menu',$roleData['functionlist']);
                    session('user',$res['name']);
                    session('code',I('username'));
                    session('empid',$res['empid']);
                    session('userarea',$roleData['userarea']);
                    session('usertype','police');       //登陆用户属性
                    $result['status'] = true;
                    $result['message'] = '验证成功';
                }else{
                    $result['message'] = '用户名，密码错误';
                }
            }
            $this->write_log('登录','平台系统');
            $this->ajaxReturn($result);
        }
    }
    //登出
    public function loginOut()
    {
        $this->write_log('登出','平台系统');
        session(null);
        $this->redirect('Index/login');
    }
    //修改密码
    public function change_password()
    {
        $newPassword = I('newpassword');
        $result['status'] = false;
        if(session('usertype') == 'normal'){
            $db = D($this->models['user']);
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
            $empDb = D($this->models['employee']);
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
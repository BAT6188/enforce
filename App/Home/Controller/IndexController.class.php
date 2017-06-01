<?php
namespace Home\Controller;

class IndexController extends CommonController {
    protected $models = array('user'=>'Enforce\User');
    public function index(){
        $this->display();
    }

    public function login()
    {
        $request['username'] = I('username');
        $request['password'] = I('password');
        $db = D($this->models['user']);
        $userInfo = $db->where($request)->find();
    }
}
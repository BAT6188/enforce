<?php
/*******************************
 *权限控制
 *******************************/
namespace Home\Controller;

class DemoController extends CommonController {
    //加载模型
    protected $models = array('user'=>'Enforce\User',     //用户
                              'dep' =>'Enforce\AreaDep',  //部门
                              'menu'=>'Enforce\Menu',      //菜单
                              'employee'=>'Enforce\Employee'      //警员
                             );
    //加载控制器
    protected $actions = array('function'=>'Function',
                               'auth'=>'Auth');    //公共方法控制器
    public function test_tree()
    {
        $auth = A($this->actions['auth']);
        $tree = $auth->format_deps('admin');
        $this->ajaxReturn($this->g2us($tree));
    }
}
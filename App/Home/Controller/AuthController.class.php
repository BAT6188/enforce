<?php
/*******************************
 *权限控制
 *******************************/
namespace Home\Controller;

class AuthController extends CommonController {
    //加载模型
    protected $models = array('user'=>'Enforce\User',     //用户
                              'dep' =>'Enforce\AreaDep',  //部门
                              'menu'=>'Enforce\Menu',      //菜单
                              'employee'=>'Enforce\Employee'      //警员
                             );
    //加载控制器
    protected $actions = array('function'=>'Function');    //公共方法控制器
    /**
     * 格式化树形
     * @param  string $username 用户名
     * @return array
     */
    public function format_deps($username)
    {
        $fun = A($this->actions['function']);
        $farr = array(0);   //父级
        $deps = $this->get_deps($username);
        $l_arr = array('areaid','areaname','fatherareaid','areaid');        //基本信息
        $icons = array('icon-group','icon-group');                          //添加图标
        $easyuiTree = $fun->formatTree($farr,$deps,$l_arr,'','',$icons);
        return  $easyuiTree;
    }

    /**
     * 获取所有能查看的警员
     * string $username 用户名
     * @return string       部门带有警员
     */
    public function get_bowers_emys($username)
    {
        $empInfo = $this->get_user_info($username);
        $empDb = D($this->models['employee']);
        $request['is_adm'] = 0;         //管理员排除 无实际接入数据
        //非警员 拥有本身及所有下级部门的查看权限
        if($empInfo['is_police'] == 0){
            $request['areaid'] = array('in',$empInfo['deps']);
            $emps = $empDb->where($request)->getField('name,areaid');
        }
        //警员 查看自身或下属部门
        if($empInfo['is_police'] == 1){
            $deps = explode(',', $empInfo['deps']);
            //排除自身所属部门
            $otherdeps = array_diff($deps,$empInfo['areaid']);
            $request['areaid'] = array('in',$otherdeps);
            $emps = $empDb->where($request)->getField('name,areaid,empid');
            //加上自己本身
            $emps[$username] = array('name'=>$username,'areaid'=>$empInfo['areaid'],'empid'=>$empInfo['empid']);
        }
        return $emps;
    }
    /**
     * 树形部门加人员一起显示
     * @param  string $username 用户名
     * @return array
     */
    public function deps_emps_tree($username)
    {
        $fun = A($this->actions['function']);
        $emps = array_values($this->get_bowers_emys($username));
        $deps = $this->format_deps($username);
        $checkFiled = array('areaid','empid','name');
        $icon = 'icon-user';
        $formatTree = $fun->add_other_info($deps,$emps,$checkFiled,$icon);
        return $formatTree;
    }
    /**
     * 获取用户的管理部门
     * @param  string $username 用户名
     * @return array
     */
    public function get_deps($username)
    {
        //用户管理的部门
        $deps = $this->get_user_info($username)['deps'];

        $depModel = D($this->models['dep']);
        $where['areaid'] = array('in',$deps);
        $deps = $depModel->where($where)->select();

        $fun = A($this->actions['function']);

        $arr = array('areaid','fatherareaid');  //数据库上下联级字段  0 子级 1 父级
        $alldeps = $fun->getParentData($deps,$this->models['dep'],$arr);    //父级数据集
        $deps = array_merge($deps,(array)$alldeps);         //合并所有数据
        return $deps;
    }
    /**
     * 获取用户有关的权限数据
     * @param  string $username 用户名
     * @return array
     */
    public function get_user_info($username)
    {
        $userDb = D($this->models['user']);
        $empDb = D($this->models['employee']);
        $where['code'] = $request['username'] = $username;
        //用户管理的部门,用户id
        $userInfo = $userDb->field('userarea,userid')->where($request)->find();
        //所属区域，是否为警员，是否为管理员
        $empInfo = $empDb->field('areaid,is_police,is_adm,empid')->where($where)->find();
        $empInfo['deps'] = $userInfo['userarea'];
        $empInfo['userid'] = $userInfo['userid'];
        return $empInfo;
    }
    /**
     * 添加用户
     * @param array $info 用户信息数组
     */
    public function add_emp($info)
    {
        $return = array();
        $userDb = D($this->models['user']);
        $empDb = D($this->models['employee']);
        $username = $this->g2u($info['username']);
        $empInfo = $this->get_user_info($username);
        //核验管理区域
        if(!in_array($info['areaid'], explode(',',$empInfo['deps']))){
            $return['message'] = '抱歉，您无权向此部门添加警员，该部门实际并不在您的管理部门内！';
            return $return;
        }
        //核验警员编号
        $where['code'] = $info['code'];
        $c = $empDb->where($where)->count('id');
        if($c > 0){
            $return['message'] = '抱歉，该警员编号已经录入';
            return $return;
        }
        $userInfo['fatherid'] = $empInfo['userid'];                 //          上级用户
        $empInfo['name'] = $userInfo['truename'] = $info['name'];       //姓名      真实姓名
        $empInfo['code'] = $userInfo['username'] = $info['code'];       //警员编号  登录用户
        $userInfo['userpassword'] = $info['code'];                      //          默认登录密码
        $empInfo['sex'] = $userInfo['sex'] = $info['sex'];              //警员性别  用户性别
        $empInfo['phone'] = $userInfo['mobile'] = $info['phone'];       //警员手机  用户手机
        $empInfo['email'] = $userInfo['email'] = $info['email'];        //警员邮箱  用户邮箱
        $empInfo['remark'] = $info['remark'];                           //警员备注
        $empInfo['is_police'] = $info['is_police'];                     //是否是警员
        $empInfo['is_adm'] = $info['is_adm'];                           //是否为管理者
        $empInfo['aredid'] = $userInfo['userarea'] = $info['aredid'];   //部门      管理部门
        //如果不是警员  或者是 adm 用户 自动添加当前部门的子部门
        if($empInfo['is_police'] == 0 || $empInfo['is_adm'] == 1){
            $deps = $this->get_children_dep((int)$empInfo['aredid']);
            $deps[] = $empInfo['aredid'];
            $userInfo['userarea'] = implode(',',$deps);
        }
        //待处理上传图片   ！！！！！
        $empInfo['photo_path'] = $info['photo'];                        //图片路径

        $result = $userDb->add($this->u2gs($userInfo));              //用户表添加
        $res = $empDb->add($this->u2gs($empInfo));                   //警员表添加
        if($result && $res){
            $return['message'] = '添加警员成功,警员登录帐号密码均为警号,如需其他权限分配请至权限管理';
        }else{
            $return['message'] = '抱歉，添加警员失败。';
        }
        return $return;
    }
    /**
     *添加部门
     */
    public function add_dep($info)
    {
        $return = array();
        $empInfo = $this->get_user_info($username);
        //核验管理部门
        if(!in_array($info['areaid'], explode(',',$empInfo['deps']))){
            $return['message'] = '抱歉，您无权向此部门添加子部门，该部门实际并不在您的管理部门内！';
            $this->ajaxReturn($return);
        }
        $depInfo['proid'] = 1;
        $depInfo['fatherareaid'] = $info['areaid'];                 //上级部门
        $depInfo['areaname'] = $info['areaname'];                   //部门名字
        $depInfo['areacode'] = $info['areacode'];                   //行政编号
        $depInfo['rperson']  = $info['rperson'];                    //负责人
        $depInfo['rphone']    = $info['rphone'];                     //电话
        $depModel = D($this->models['dep']);
        $depInfo = $this->u2gs($depInfo);
        $res = $depModel->add($depInfo);                        //添加
        $result = array();
        if($res){
            $emps = $this->get_dep_manager($info['areaid']);
            $where['username'] = array('in',$emps);
            $userDb = D($this->models['user']);
            $users = $userDb->field('userid,userarea')->where($where)->select();
            foreach ($users as $user) {
                $user['userarea'] = $user['userarea'].','.$res;
                $request['userid'] = $user['userid'];
                unset($user['userid']);
                $userDb->where($request)->save($user);
            }
            $result['message'] = '部门添加成功';
        }else{
            $result['message'] = '部门添加失败';
        }
        return $result;
    }
    /**
     * 删除部门
     * @return [type] [description]
     */
    public function del_dep($deps)
    {
        
    }
    /**
     * 获取部门的管理员
     * @param  int $depid 部门id
     * @return array        修要修改的管理员
     */
    public function get_dep_manager($depid)
    {
        $empDb = D($this->models['employee']);
        $deps = $this->get_parent_dep($depid);      //获取所有的父部门
        $deps[] = $depid;
        $where['areaid'] = array('in',$deps);      //归属区域
        $where['is_police'] = 0;        //非警员 
        $emps = $empDb->where($where)->getFiled('code',true);  //获取所有的管理员
        return $emps;
    }
    /**
     * 获取所有子部门
     * @param  int $depid 部门ID
     * @return array
     */
    public function get_children_dep($depid)
    {
        $l_arr = array('areaid','fatherareaid');
        $depModel = D($this->models['dep']);
        $where[$l_arr[0]] = $depid;
        $depInfo = $depModel->where($where)->select();
        $fun = A($this->actions['function']);
        
        $childrenDeps = $fun->getChData($depInfo,$this->models['dep'],$l_arr);
        $res = array();
        foreach ($childrenDeps as  $dep) {
            $res[] = $dep[$l_arr[0]];
        }
        return $res;
    }
    /**
     * 获取所有上级部门
     * @param  int $depid 部门ID
     * @return array
     */
    public function get_parent_dep($depid)
    {
        $l_arr = array('areaid','fatherareaid');
        $depModel = D($this->models['dep']);
        $where[$l_arr[0]] = $depid;
        $depInfo = $depModel->where($where)->select();
        $fun = A($this->actions['function']);
        
        $childrenDeps = $fun->getParentData($depInfo,$this->models['dep'],$l_arr);
        $res = array();
        foreach ($childrenDeps as  $dep) {
            $res[] = $dep[$l_arr[0]];
        }
        return $res;
    }
}

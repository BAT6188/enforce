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
                         'area'=>'Enforce\AreaDep'];           //部门
    protected $actions = ['area'=>'Area',
                          'role'=>'Role',
                          'user'=>'User',
                          'employee'=>'Employee'];
    protected $views = ['index'=>'employee',
                        'showEmpPhoto'=>'showEmpPhoto'];
    /**
     * 统计文件数量
     * @param  array $where 查询信息
     * @return int
     */
    public function count_media_num($where)
    {
        $db = D($this->models['pe_video_list']);
        $num = $db->where($where)->count('wjbh');
        return $num;
    }
    public function init_media_info()
    {
        $request['areaid']  = I('areaid','');      //部门ID
        //获取能显示的警员
        $action = A($this->actions['employee']);
        $emps = $action->get_manger_emp($request['areaid']);
        $allowCodes = array_keys($emps);
    }
}
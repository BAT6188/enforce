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
                          'user'=>'User'];
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
}
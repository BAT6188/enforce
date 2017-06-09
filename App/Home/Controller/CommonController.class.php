<?php
namespace Home\Controller;

use Think\Controller;
use Think\Model;

class CommonController extends Controller {
	/**
	 * 格式化easyui-tree数据格式
	 * @param  array $ids   父级菜单id
	 * @param  array $datas 修要处理的菜单
	 * @param  array $l_arr 保存菜单的一些信息  0-自身id  1-保存内容 2-父ID 3-排序
	 * @param  array $L_attributes 额外需要保存的信息 ['iconcls']//直接处理  ['iconCls'=>'iconcls']//根据键名处理
     * @param  array $check_arr 需要被勾选的数组
     * @param  array $icons 需要添加的图标 icon-remove 0-父图标 1-子图标
     * @param  array $noclose  无需折叠的数组
	 * @return array
	 */
    public function formatTree($ids,$datas,$l_arr,$L_attributes,$check_arr,$icons,$noclose)
    {
    	$formatTree = array();
        foreach ($ids as $id) {
            $odrData = array();
            foreach ($datas as $key=>$data) {
                if($id == $data[$l_arr[2]]){
                    $odrData[] = $data[$l_arr[3]];
                    $nextIds[] = $data[$l_arr[0]];
                    $doTree['id'] = $data[$l_arr[0]];
                    if(!empty($check_arr)){
                        if(in_array($doTree['id'],$check_arr)){
                            $doTree['checked'] = true;
                        }
                    }
                    $doTree['text'] = $data[$l_arr[1]];
                    foreach ($L_attributes as $k=>$L_attribute) {
                        if(!is_numeric($k)){
                            $doTree[$k] = $data[$L_attribute];
                        }else{
                            $doTree[$L_attribute] = $data[$L_attribute];
                        }
                    }
                    //删除已经符合条件的数据减少下一次循环的次数
                    unset($datas[$key]);
                    $children = $this->formatTree($nextIds,$datas,$l_arr,$L_attributes,$check_arr,$icons,$noclose);
                    $nextIds = '';
                    if(!empty($children)){
                        if(!empty($noclose)){
                            if(!in_array($doTree['id'],$noclose)) $doTree['state'] = 'closed';
                        }else{
                            $doTree['state'] = 'closed';
                        }
                        $doTree['children'] = $children;
                        !empty($icons) ? $doTree['iconCls'] = $icons[0] : '';
                    }else{
                        !empty($icons) ? $doTree['iconCls'] = $icons[1] : '';
                    }
                    $formatTree[] = $doTree;
                    //对于生成的菜单在进行排序
                    array_multisort($odrData,SORT_DESC,$formatTree);
                    $doTree = '';
                }
            }
        }
        //$formatMenu = json_encode($formatMenu);
        return  $formatTree;
    }
    /**
     * 获取所有子联级
     * @param  array $finfos 根元素
     * @param  string $dbc     模型
     * @param  array $l_arr  0-id  1-fid
     * @return array         所有子集
     */
    public function getChData($finfos,$dbc,$l_arr)
    {
    	if(empty($finfos)) return false;

        $db = D($dbc);
    	$infos = array();
    	foreach ($finfos as $key => $finfo) {
    		$id = $finfo[$l_arr[0]];
    		$where[$l_arr[1]] = $id;
    		$infoc = $db->where($where)->select();
    		$info = array();
    		if(!empty($infoc)){
    			$info = $this->getChData($infoc,$dbc,$l_arr);
    		}
            $infos = array_merge($info,$infos,$infoc);
    	}
    	return $infos;
    }
    /**
     * 获取父级数据
     * @param  array $finfos 所有子集
     * @param  string $dbc     模型
     * @param  array $l_arr  0-id  1-fid
     */
    public function getParentData($finfos,$dbc,$l_arr)
    {
        if(empty($finfos)) return false;

        $db = D($dbc);
        $datas = array();
        static $pids = array();
        foreach ($finfos as $value) {
            $pids[] = $value[$l_arr[0]];
        }
        foreach ($finfos as $finfo) {
            if(!in_array($finfo[$l_arr[1]],$pids)){
                $where[$l_arr[0]] = $finfo[$l_arr[1]];
                $data = $db->where($where)->find();
                if($data!='' && !in_array($data[$l_arr[0]],$pids)){
                    $datas[] = $data;
                }
                $pids[] = $finfo[$l_arr[1]];
            }
        }
        $datac = $this->getParentData($datas,$dbc,$l_arr);
        if($datac){
            $datas = array_merge($datas,$datac);
        }
        return $datas;
    }
    /**
     * 获取数据库中的所有表名
     * @param  array $config 数据库的配置信息
     * @return array        数据库一维数组
     */
    public function get_dbTables($config)
    {
        $tables = array();
        try {
            $initdb = M('','',$config);
            $tablesArr = $initdb->query('show tables');
            $tables = array();
            foreach ($tablesArr as  $table) {
                $tables[] = array_pop($table);
            }
            return $tables;
        } catch (Exception $e) {
            return $tables;
        }
    }
    /**
     * 获取两个日期之间的所有日期 包含自身
     * @param  Date $smallDate 较小的日期
     * @param  Date $bigDate   较大的日期
     * @param  string $format  生成日期的格式
     * @return array
     */
    public function get_twoMonthsDates($smallDate,$bigDate,$format)
    {
        $time1 = strtotime($smallDate); // 自动为00:00:00 时分秒 两个时间之间的年和月份
        $time2 = strtotime($bigDate);
        $datearr = array();
        $datearr[] = date($format,$time1);
        while( ($time1 = strtotime('+1 day', $time1)) <= $time2){
              $datearr[] = date($format,$time1); // 取得递增月;
        }
        return $datearr;
    }
    /**
     * 添加其他信息到树
     * @param array $easyuiTree 已经生成好的树
     * @param array $otherData  其他的数据信息
     * @param array $checkFiled  需要验证添加的字段  0-checkid  1-id 2-name
     * @param  array $attributes 额外需要保存的信息 ['iconcls']//直接处理  ['iconCls'=>'iconcls']//根据键名处理
     * @param string $icon       加载的图标
     */
    public function add_other_info($easyuiTree,$otherData,$checkFiled,$icon,$attributes)
    {
        foreach ($easyuiTree as &$node) {
            $children = array();
            foreach ($otherData as $key=>$info) {
                //如果符合验证
                $data = array();
                if($node['id'] == $info[$checkFiled[0]]){
                    $data['id'] = $info[$checkFiled[1]];   //id
                    $data['text'] = $info[$checkFiled[2]]; //内容
                    $data['iconCls'] = $icon;                   //图标
                    if(!empty($attributes)){
                        foreach ($attributes as $k => $attribute) {
                            if(!is_numeric($k)){
                                $data[$k] = $info[$attribute];
                            }else{
                                $data[$attribute] = $info[$attribute];
                            }
                        }
                    }
                    $children[] = $data;
                    unset($otherData[$key]);        //符合条件的删除，减少下一次的循环
                }
            }
            if($node['children']){      //如果有子节点
                //递归调用
                $childrens = $this->add_other_info($node['children'],$otherData,$checkFiled,$icon,$attributes);
                //合并数据
                if(!empty($children)){
                    $node['children'] = array_merge($children,$childrens);
                }else{
                    $node['children'] = $childrens;
                }
            }else{              //没有子节点 删除直接添加人员
                if(!empty($children)){
                    $node['children'] = $children;
                }
            }
        }
        return  $easyuiTree;
    }
    /**
     * 写日志
     * @param  string $action 操作事件 详细内容
     * @param  string $moudle 菜单
     * @return viod
     */
    public function write_log($action,$moudle)
    {
        $data['dte'] = date('Y-m-d H:i:s');
        $data['name'] = u2g(session('user'));
        $data['moudle'] = u2g($moudle);
        $ip = get_client_ip();
        $data['cmt'] = u2g($action.'('.$ip.')');
        $db = D('Enforce\SysLog');
        $db->add($data);
    }
}
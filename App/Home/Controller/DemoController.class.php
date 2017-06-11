<?php
namespace Home\Controller;

class DemoController extends CommonController
{
	public function index()
	{
		$db = D('Functionreg');
		$where['funid'] = 100;
		$data = $db->where($where)->select();
		$l_arr = [0=>'funid',1=>'prefunid'];
		$info = $this->getChData($data,'Functionreg',$l_arr);
		dump($info);
	}
	public function dos()
	{
		echo implode(',', range(56,90));
	}
	public function test()
	{
		$dbc = 'Rolereg';
		$db = D($dbc);
		$where['roleid'] = session('roleid');
		$data = $db->where($where)->select();

		$l_arr = [0=>'roleid',1=>'proleid'];
		$info['role'] = $this->getChData($data,$dbc,$l_arr);
		$info['roleJson'] = json_encode($info['role']);
		dump($info);
		exit;
	}
	public function test_page()
	{
		$page = I('page');
		$this->display($page);
	}
	public function test_slice()
	{
		$arr = range(1,1000);
		dump(array_slice($arr, 10,10));
	}
	public function testDemo()
	{
		$info[15] = ['id'=>15,'num'=>33,'pid'=>0];
		$info[16] = ['id'=>16,'num'=>33,'pid'=>15];
		$info[20] = ['id'=>20,'num'=>33,'pid'=>15];
		$info[17] = ['id'=>17,'num'=>33,'pid'=>16];
		$info[18] = ['id'=>18,'num'=>33,'pid'=>17];
		$info[19] = ['id'=>19,'num'=>33,'pid'=>17];
		krsort($info);
		foreach ($info as $key => $value) {
			$checkArr[$value['pid']][] = $key;
		}
		foreach ($info as $key => $value) {
			if(empty($checkArr[$key])) continue;

			foreach ($checkArr[$key] as $val) {
				$info[$key]['num'] = $info[$key]['num']+$info[$val]['num'];
			}
			echo $key."<br>";
			dump($checkArr[$key]);
			echo '-----'."<br>";
			/*if(in_array($value['pid'], $checkArr[$key])){

			}
			if($key==$value['pid']){
				$info[$key]['num'] = $info[$key]['num'] + $value['num'];
			}*/
		}
		dump($info);
	}
}
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
}
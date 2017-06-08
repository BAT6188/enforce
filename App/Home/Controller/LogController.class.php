<?php
//显示
namespace Home\Controller;

class LogController extends CommonController
{ 
    protected $models = ['peLogList'=>'Enforce\PeLogList',      //记录仪日志
                         'wsLog'=>'Enforce\WsLog',              //工作站日志
                         'sysLog'=>'Enforce\WsLog',             //系统日志
                         'wsbase'=>'Enforce\WsBase',            //工作站   
                         'employee'=>'Enforce\Employee',            //执法仪
                         ];           
    protected $actions = ['employee'=>'Employee'];
    protected $views = ['pelog'=>'peLog',
                        'wslog'=>'wsLog',
                        'syslog'=>'sysLog'];
    //页面显示
    public function log_show()
    {
        $logType = I('logType');
        $this->display($this->views[$logType]);
    }
    public function pe_log_list()
    {
        $wsdb = D($this->models['wsbase']);         
        $empdb = D($this->models['employee']);
        $empInfo = $empdb->getField('code,name');
        $wsInfo  = $wsdb->getField('gzzbh,dz');
        //获取能显示的执法仪信息
        $action = A($this->actions['employee']);
        $emps = $action->get_manger_emp();
        $allowCodes = array();
        foreach ($emps as $emp) {
            $allowCodes[] = $emp['code'];      //警员编号
        }
        if(empy($allowCodes)){
            $res['total'] = 0;
            $res['rows']  = array();
            $this->ajaxReturn($data);
        }
        $db = D($this->models['peLogList']);
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $page = I('page');
        $page = I('rows');
        $where['rzsj'][] = array('EGT',$request['btime']);
        $where['rzsj'][] = array('ELT',$request['etime']);
        $where['jybh'] = array('in',$allowCodes);
        $data = $db->getTableList($where,$page,$rows);
        foreach ($data['rows'] as &$value) {
            $value['name'] = array_key_exists($value['jybh'], $empInfo) ? $empInfo[$value['jybh']] : u2g('未知');
            $value['wsname'] = array_key_exists($value['gzzbh'], $empInfo) ? $wsInfo[$value['gzzbh']] : u2g('未知');
            $value['action'] = $value['rzlx'] == 1 ? '关机' : $value['rzlx'] == 2 ? '开机' : '拍照';
            $value['action'] = u2g($value['action']);
        }
        $this->ajaxReturn(g2us($data));
    }
    public function ws_log_list()
    {
        $wsdb = D($this->models['wsbase']);         
        $wsInfo  = $wsdb->getField('gzzbh,dz');
        $db = D($this->models['wsLog']);
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $page = I('page');
        $page = I('rows');
        $where['rzsj'][] = array('EGT',$request['btime']);
        $where['rzsj'][] = array('ELT',$request['etime']);
        $data = $db->getTableList($where,$page,$rows);
        foreach ($data['rows'] as &$value) {
            $value['wsname'] = array_key_exists($value['gzzbh'], $empInfo) ? $wsInfo[$value['gzzbh']] : u2g('未知');
            $value['action'] = $value['rzlx'] == 2 ? '关机' : $value['rzlx'] == 1 ? '开机' : '接入';
            $value['action'] = u2g($value['action']);
        }
        $this->ajaxReturn(g2us($data));
    }
}

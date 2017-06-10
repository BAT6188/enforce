<?php
//显示
namespace Home\Controller;

class LogController extends CommonController
{
    protected $models = ['peLogList'=>'Enforce\PeLogList',      //记录仪日志
                         'wsLog'=>'Enforce\WsLog',              //工作站日志
                         'sysLog'=>'Enforce\SysLog',             //系统日志
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
    //执法仪日志
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
        if(empty($allowCodes)){
            $res['total'] = 0;
            $res['rows']  = array();
            $this->ajaxReturn($res);
        }
        $db = D($this->models['peLogList']);
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $page = I('page');
        $rows = I('rows');
        $where['rzsj'][] = array('EGT',$request['btime']);
        $where['rzsj'][] = array('ELT',$request['etime']);
        $where['jybh'] = array('in','000113');
        $data = $db->getTableList($where,$page,$rows);
        $peActions = ['其它','关机','开机','拍照','录像','录音','结束录像'];
        foreach ($data['rows'] as &$value) {
            //字段更替 jybh->name  gzzbh->wsname  rzlx->action
            $value['name'] = array_key_exists($value['jybh'], $empInfo) ? $empInfo[$value['jybh']] : u2g('未知');
            $value['wsname'] = array_key_exists($value['gzzbh'], $empInfo) ? $wsInfo[$value['gzzbh']] : u2g('未知');
            $peAction = array_key_exists($value['rzlx'],$peActions) ? $peActions[$value['rzlx']] : '未知';
            $value['action'] = u2g($peAction);
        }
        $this->ajaxReturn(g2us($data));
    }
    //工作站日志
    public function ws_log_list()
    {
        $wsdb = D($this->models['wsbase']);
        $wsInfo  = $wsdb->getField('gzzbh,dz');
        $db = D($this->models['wsLog']);
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $page = I('page');
        $rows = I('rows');
        $where['rzsj'][] = array('EGT',$request['btime']);
        $where['rzsj'][] = array('ELT',$request['etime']);
        $data = $db->getTableList($where,$page,$rows);
        $wsActions = ['其他','开机','关机','接入记录仪','移除记录仪','采集文件'];
        foreach ($data['rows'] as &$value) {
            //字段更替 gzzbh->wsname  rzlx->action
            $value['wsname'] = array_key_exists($value['gzzbh'], $wsInfo) ? $wsInfo[$value['gzzbh']] : u2g('未知');
            $wsAction = array_key_exists($value['rzlx'],$wsActions) ? $wsActions[$value['rzlx']] : '未知';
            $value['action'] = u2g($wsAction);
        }
        $this->ajaxReturn(g2us($data));
    }
    //系统日志
    public function sys_log_list()
    {
        $db = D($this->models['sysLog']);
        $request['btime'] = I('btime',date('Y-m-d H:i:s',time()-7*24*60*60));
        $request['etime'] = I('etime',date('Y-m-d H:i:s',time()));
        $page = I('page');
        $rows = I('rows');
        $where['dte'][] = array('EGT',$request['btime']);
        $where['dte'][] = array('ELT',$request['etime']);
        $data = $db->getTableList($where,$page,$rows);
        $this->ajaxReturn(g2us($data));
    }
}

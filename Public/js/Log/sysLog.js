/**
 * Created by Administrator on 2017/6/9.
 */
$(function(){
    var time=new Date();
    $('#etime').datetimebox({value:new Time(time,0).init()});
    $('#btime').datetimebox({value:new Time(time,7).init()});
    $('#datagrid').datagrid({
        url:app.url('Log/sys_log_list'),
        title:'系统日志',
        fitColumns:true,
        fit:true,
        striped:true,
        rownumbers:true,
        pagination:true,
        pageSize:15,
        pageNumber:1,
        pageList:[2,5,10,15,20,25,30,40,50],
        pagePosition:'bottom',
        toolbar:'#toolbar',
        columns:[[
            {field:'roleid',title:'id',checkbox:true},
            {field:'name',title:'用户',width:200,align:'center'},
            {field:'cmt',title:'操作',width:200,align:'center'},
            {field:'module',title:'模块',width:200,align:'center'},
            {field:'dte',title:'操作时间',width:200,align:'center'}
        ]],
    });
    $('#searching').click(function(){
        var data=app.serializeJson('#form');
        $('#datagrid').datagrid({
            queryParams:data
        });
    });
});


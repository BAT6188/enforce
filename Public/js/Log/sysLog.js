var module = {};
module.show = function(){
    $('#searchForm').form('reset');
    $('#datagrid').datagrid('load',{
        rand:Math.random()
    });
}
$(function(){
    $('#datagrid').datagrid({
        url:app.url('Log/sys_log_list'),
        title:'系统日志',       //这里就能改
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[10,20,30],        //这里页数也太多了
        columns:[[
        {field:'roleid',title:'id',checkbox:true},
        {field:'name',title:'用户',width:200,align:'center'},
        {field:'cmt',title:'操作',width:200,align:'center'},
        {field:'module',title:'模块',width:200,align:'center'},
        {field:'dte',title:'操作时间',width:200,align:'center'}
        ]],
        pagination:true
    });
});
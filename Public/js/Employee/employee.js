//树的实例化
var tree = new Tree('#area_list');

var module = {};
module.areaid = app.tp.areaid;
module.areaname = app.tp.areaname;
module.clickTree = function(node){
    module.areaid = node.id;
    module.areaname = node.text;
    $('#mu_ser').html(module.areaname);
    module.search();
}
//基本的搜索
module.show = function(){
    $('#searchForm').form('reset');
    $('#datagrid').datagrid('load',{
        areaid:module.areaid,
        rand:Math.random()
    });
}
//搜索事件 ----
module.search = function(){
    var name = $('#name').val();
    name = $.trim(name);
    $('#datagrid').datagrid('load',{
        areaid:module.areaid,
        name:name
    });
}
module.addBar = function(){
    $('#dialog').dialog('open');
}
$(function(){
    //树的初始化
    tree.init();
    tree.loadData();
    //树的额外参数
    $(tree.dom).tree({
        onClick:module.clickTree
    });
    $('#mu_ser').html(module.areaname);
    $('#datagrid').datagrid({
        url:app.url('Employee/dataList'),
        method:'get',
        queryParams:{
            areaid:module.areaid,
            rand:Math.random()
        },
        title:'警员列表',
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[15,20,25,30],
        columns:[[
        {field:'empid',title:'警员id',checkbox:true},
        {field:'code',title:'警员警号',align:'center'},
        {field:'name',title:'姓名',width:200,align:'center'},
        {field:'sex',title:'性别',width:200,align:'center'},
        {field:'phone',title:'电话',width:200,align:'center'},
        {field:'email',title:'邮箱',width:200,align:'center'},
        {field:'remark',title:'备注',width:200,align:'center'},
        {field:'areaname',title:'所属部门',width:200,align:'center'},
        {field:'otherInfo',title:'其他信息',width:200,align:'center'}
        ]],
        pagination:true
    });
});
//树的实例化
var tree = new Tree('#area_list');

var module = {};
module.areaid = app.tp.areaid;
module.areaname = app.tp.areaname;
module.actionType = 1;
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
module.infoBar = function(type){
    module.actionType = type;
    if (module.areaid == 0) {
        $.messager.alert('操作提示','你无法向系统根部门添加/修改警员,请先创建部门，重新登录后添加警员！','info');
        return false;
    }
    //添加
    if(type == 1){
        var info = {areaid:module.areaid};
        $('#form').form('clear');
        $('#form').form('load',info);
    }
    //修改
    if(type == 2){
        var infos = $('#datagrid').datagrid('getSelections');
        if(infos.length != 1){
            $.messager.alert('操作提示','请选择一个警员进行编辑','info');
            return false;
        }
        //加载数据
        $('#form').form('load',infos[0]);
    }
    $('#dialog').dialog('open');
}
module.changeinfo = function(){
    var params = app.serializeJson('#form');
    var formData = new FormData();
        formData.append('file', $("#form input[name='photo']")[0].files[0]);
    console.log(formData);
    return false;
    //增加 删除ID
    if(module.actionType == 1){
        delete(params.empid);
        var requestUrl = app.url('Employee/dataAdd');
    }else{
        var requestUrl = app.url('Employee/dataEdit');
    }
    $.ajax({
        url:requestUrl,
        type:'post',
        dataType:'json',
        data:params,
        success:function(data){
            $.messager.alert('结果提示',data.message,'info');
            $('#dialog').dialog('close');
            $('#datagrid').datagrid('reload',{
                areaid:module.areaid,
                rand:Math.random()
            });
        },
        error:function(data){
            $('#dialog').dialog('close');
            $.messager.alert('操作提示','网络故障','info');
        }
    })
}
module.remove = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    if(infos.length = 0) return false;
    var ids = [];
    $.each(infos,function(n,m){
        var id= m.empid;
        if(id == module.empid){
            $.messager.alert('删除提示','你无法删除自身,该操作只有上级用户可执行','info');
            return false;
        }
        ids.push(id);
    });
    ids = ids.join(',');
    $.ajax({
        url:app.url('Employee/dataRemove'),
        type:'post',
        data:{
            empid:ids
        },
        success:function(data){
            $.messager.alert('结果提示',data.message,'info');
            $('#datagrid').datagrid('reload',{
                areaid:module.areaid,
                rand:Math.random()
            });
        }
    });
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
        {field:'otherInfo',title:'权限信息',width:200,align:'center',formatter:function(v,r,i){
            return '点击查看';
        },styler:function(v,r,i){
            return 'color:#0E2D5F;cursor:pointer;';
        }}
        ]],
        pagination:true
    });
});
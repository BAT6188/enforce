(function(){
    typeof app == 'undefined' ? console.log('请引入Public/js/App.js，并在使用 var app = new App() 进行实例化');
})()
var thisPageThings = {};
//操作所需的url
thisPageThings.datagridUrl = app.url('Area/dataList');
thisPageThings.addUrl = app.url('Area/dataAdd');
thisPageThings.editUrl = app.url('Area/dataEdit');
thisPageThings.removeUrl = app.url('Area/dataRemove');
thisPageThings.areaid;
//基本的搜索
thisPageThings.show = function(){
    $('#searchForm').form('reset');
    $('#datagrid').datagrid('load',{
        areaid:thisPageThings.areaid,
        rand:Math.random()
    });
}
//接收数据之后的操作
thisPageThings.callback = function(data){
   // data = eval('('+data+')');
    $.messager.alert('操作提示',data.message,'info');
    $('#datagrid').datagrid('load',{
        areaid:thisPageThings.areaid,
        rand:Math.random()
    });
}
//打开增加dialog
thisPageThings.addBar = function(){
    $('#addForm').form('load',{fatherareaid:thisPageThings.areaid});
    console.log(thisPageThings.areaid);
    $('#addDialog').dialog('open');
}
//打开编辑dialog
thisPageThings.editBar = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    if(infos.length > 1){
        $.messager.alert('操作提示','请选择单个进行操作','info');
        return false;
    }
    if(infos.length == 1){
        $('#editForm').form('load',infos[0]);
        $('#editDialog').dialog('open');
    }
}
//提交增加
thisPageThings.add = function(){
    $('#addForm').form('submit',{
        url:thisPageThings.addUrl,
        success:function(data){
            data = eval('('+data+')');
            $('#addDialog').dialog('close');
            $.messager.alert('操作提示',data.message,'info');
            $('#datagrid').datagrid('load',{
                areaid:thisPageThings.areaid,
                rand:Math.random()
            });
            loadData();
        }
    });
}
//提交编辑
thisPageThings.edit = function(){
    $('#editForm').form('submit',{
        url:thisPageThings.editUrl,
        success:function(data){
            data = eval('('+data+')');
            $('#editDialog').dialog('close');
            $.messager.alert('操作提示',data.message,'info');
            $('#datagrid').datagrid('load',{
                areaid:thisPageThings.areaid,
                rand:Math.random()
            });
            loadData();
        }
    });
}
//删除事件
thisPageThings.remove = function(){
    var nodes = $('#area_list').tree('getChecked');
    var ids = [];
    if(nodes.length == 0)
        return false;
    $.messager.confirm('重要提醒','删除前请确定位于该区域下的设备/人员已无用/不在职！',function(r){
        if(r){
            $.each(nodes,function(n,m){
                var id= m.id;
                ids.push(id);
            });
            ids = ids.join(',');
            $.ajax({
                url:thisPageThings.removeUrl,
                type:'post',
                data:{
                    areaid:ids
                },
                success:function(data){
                    thisPageThings.callback(data);
                    loadData();
                }
            });
        }
    });
}
//搜索事件 ----！  需要额外写
thisPageThings.search = function(){
    var areaname = $('#areaname').val();
    areaname = $.trim(areaname);
    $('#datagrid').datagrid('load',{
        areaid:thisPageThings.areaid,
        areaname:areaname
    });
}
function checkAreareg(v,r,i){
    var fies = {:$info['arearegJson']};
    var name = '主区域';
    $.each(fies,function(n,m){
        if(m.areaid == v){
            name = m.areaname;
        }
    });
    return name;
}
//初始化表格
$(function(){
    $('#datagrid').datagrid({
        url:thisPageThings.datagridUrl,
        method:'get',
        title:'区域列表',
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[2,5,10,15,20,25,30,40,50],
        columns:[[
        {field:'areaid',title:'区域id',hidden:true},
        {field:'areaname',title:'区域名称',width:200,align:'center'},
        {field:'areacode',title:'区域编号',width:200,align:'center'},
        {field:'rperson',title:'联系人',width:200,align:'center'},
        {field:'rphone',title:'联系方式',width:200,align:'center'},
        {field:'fatherareaid',title:'父区域',width:200,align:'center',formatter:checkAreareg},
        ]],
        pagination:true
    });
    loadData();
    $('#area_list').tree({
        checkbox:true,
        'onClick':function(node){
            $('#mu_area').html(node.text);
            thisPageThings.areaid = node.id;
            thisPageThings.show();
        }
    });
});
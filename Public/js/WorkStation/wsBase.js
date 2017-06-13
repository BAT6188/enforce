var things = {};
things.datagridUrl = app.url('WorkStation/ws_base_list');
things.addUrl = app.url('WorkStation/ws_base_add');
things.editUrl = app.url('WorkStation/ws_base_edit');
things.removeUrl = app.url('WorkStation/ws_base_remove');
things.statusUrl = app.url('WorkStation/ws_status_statistics');
things.show = function(){
    $('#searchForm').form('reset');
    $('#datagrid').datagrid('load',{
        rand:Math.random()
    });
}
things.callback = function(data){
   // data = eval('('+data+')');
    $.messager.alert('操作提示',data.message,'info');
    $('#datagrid').datagrid('reload',{
        rand:Math.random()
    });
}
things.addBar = function(){
    $('#addDialog').dialog('open');
    $('#addForm').form('clear');
}
things.editBar = function(){
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
things.change_info = function(form,url,dialog){
    var params = app.serializeJson(form);
    if(!$(form).form('validate')){
        $.messager.alert('操作提示','有未满足条件的选项，无法提交','info');
        return false;
    }
    $.ajax({
        url:url,
        type:'post',
        dataType:'json',
        data:params,
        success:function(data){
            $(dialog).dialog('close');
            things.callback(data);
        },
        error:function(data){
            $(dialog).dialog('close');
            $.messager.alert('操作提示','网络故障','info');
        }
    });
}
things.add = function(){
    things.change_info('#addForm',things.addUrl,'#addDialog');
}
things.edit = function(){
    things.change_info('#editForm',things.editUrl,'#editDialog');
}
things.remove = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    var ids = [];
    if(infos.length == 0)
        return false;

    $.each(infos,function(n,m){
        var id= m.id;
        ids.push(id);
    });
    ids = ids.join(',');

    $.ajax({
        url:things.removeUrl,
        type:'post',
        data:{
            id:ids
        },
        success:function(data){
            things.callback(data);
        }
    });
}
things.search = function(){
  var dz = $('#dzInput').val();
  var hzr = $('#hzrInput').val();
  var zxzt = $('#zxztInput').val();
  dz = $.trim(dz);
  $('#datagrid').datagrid('load',{
    dz: dz,
    hzr: hzr,
    zxzt:zxzt
  });
}
$(function(){
    $('#datagrid').datagrid({
        url:things.datagridUrl,
        title:'工作站',
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[2,5,10,15,20,25,30,40,50],
        columns:[[
          { field: 'id', title: 'id', checkbox: true },
          {field:'gzz_ip',title:'工作站IP',align:'center'},
          {field:'dz',title:'地址', width: 200, align:'center'},
          {field: 'hzr', title: '负责人', width: 200, align: 'center' },
          {field: 'dh', title: '负责人电话', width: 200, align: 'center' },
          {field:'zxztname',title:'在线状态',width:200,align:'center'},
          {field: 'ztsj', title: '最后在线时间', width: 200, align: 'center' },
          {field: 'qyztname', title: '启用状态', width: 200, align: 'center' }
        ]],
        pagination:true
    });
});
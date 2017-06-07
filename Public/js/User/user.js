var tree = new Tree('#areaList');
var module = {};
module.datagridUrl = app.url('User/dataList');
module.addUrl =  app.url('User/dataAdd');
module.editUrl = app.url('User/dataEdit');
module.removeUrl = app.url('User/dataRemove');
module.userareaUrl = app.url('User/userarea');
module.saveareaUrl = app.url('User/savearea');
module.userid = app.tp.userid;
module.select_userid;
module.show = function(){
    $('#searchForm').form('reset');
    $('#datagrid').datagrid('load',{
        rand:Math.random()
    });
}
module.callback = function(data){
    $.messager.alert('操作提示',data.message,'info');
    $('#datagrid').datagrid('reload');
}
module.addBar = function(){
    $('#addDialog').dialog('open');
}
module.editBar = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    if(infos.length > 1){
        $.messager.alert('操作提示','请选择单个进行操作','info');
        return false;
    }
    if(infos.length == 1){
        module.select_userid = infos[0].userid;
        if(module.userid == module.select_userid){
            $('#role_con').hide();
        }else {
            $('#role_con').show();
        }
        $('#editForm').form('load',infos[0]);
        $('#editDialog').dialog('open');
    }
}
module.change_info = function(form,url,dialog){
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
            module.callback(data);
        },
        error:function(data){
            $(dialog).dialog('close');
            $.messager.alert('操作提示','网络故障','info');
        }
    });
}
module.add = function(){
    module.change_info('#addForm',module.addUrl,'#addDialog');
}
module.edit = function(){
    module.change_info('#editForm',module.editUrl,'#editDialog');
}
module.removeit = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    var ids = [];
    if(infos.length == 0)
        return false;

    $.each(infos,function(n,m){
        var id= m.userid;
        if(id == module.userid){
            $.messager.alert('删除提示','你无法删除自身,该操作只有上级用户可执行','info');
            return false;
        }
        ids.push(id);
    });
    ids = ids.join(',');
    $.ajax({
        url:module.removeUrl,
        type:'post',
        data:{
            userid:ids
        },
        success:function(data){
            module.callback(data);
        }
    });
}
module.search = function(){
    var username = $('#searchInput').val();
    var truename = $('#truename').val();
    username = $.trim(username);
    truename = $.trim(truename);
    $('#datagrid').datagrid('load',{
        username:username,
        truename:truename
    });
}
module.areaBar = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    if(infos.length > 1){
        $.messager.alert('操作提示','请选择单个进行操作','info');
        return false;
    }
    if(infos.length == 1){

        module.select_userid = infos[0].userid;
        if(module.userid==module.select_userid){
            $.messager.alert('操作提示','你无法对自己进行部门分配,如有需求请联系上级,如是系统管理员,已有全部部门管理权限');
            return false;
        }
        var userid = infos[0].userid;
        $.ajax({
            type:'GET',
            url:module.userareaUrl,
            data:{
                userid:userid
            },
            success:function(data){
                $(tree.dom).tree({
                    data:data
                })
            },
            error:function(){
                $.messager.alert('信息提示','网络错误，部门加载失败','error');
            }
        });
        $('#area_sure').show();
        $('#areaDialog').dialog('open');
    }
}
module.area = function(){

    var areaSelect = $('#areaList').tree('getChecked');
    var userRow = $('#datagrid').datagrid('getSelections');
    var userid = userRow[0].userid;
    if(areaSelect.length>0){
        var ids=[];
        for(var i=0;i<areaSelect.length;i++){
            ids.push(areaSelect[i].id);
        }
        var userarea = ids.join(',');
        $.ajax({
            type:'GET',
            url:module.saveareaUrl,
            data:{
                userarea:userarea,
                userid:userid
            },
            success:function(result){
                var result=eval(result);
                $.messager.alert('操作提示',result.message,'info');
                $('#areaDialog').dialog('close');
                $('#datagrid').datagrid('reload');
            }
        });
    }else{
        $.messager.alert('操作提示','没有分配区域','info');
    }
}
$(function(){

    tree.init();
    $(tree.dom).tree({
        checkbox:true
    });
    $('#datagrid').datagrid({
        url:module.datagridUrl,
        title:'用户列表',
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[2,5,10,15,20,25,30,40,50],
        onClickCell:function(r,f,v){
            if(f=='seeArea'){
                var rowData = $(this).datagrid('getData').rows[r];
                var userid = rowData.userid;
                //console.log(userid);
                tree.loadUserArea(userid);
                $('#area_sure').hide();
                $('#areaDialog').dialog('open');
            }
        },
        columns:[[
        {field:'userid',title:'id',checkbox:true},
        {field:'username',title:'登录账号',width:200,align:'center'},
        //{field:'userpassword',title:'登录密码',width:200,align:'center'},
        {field:'truename',title:'真实姓名',width:200,align:'center'},
        {field:'sex',title:'用户性别',width:200,align:'center'},
        {field:'mobile',title:'联系电话',width:200,align:'center'},
        {field:'clientip',title:'客户端IP',width:200,align:'center'},
        {field:'bindingip',title:'是否绑定',width:200,align:'center',formatter:function(v,r,i){
            return v == '0' ? '×':'√';
        }},
        {field:'email',title:'email',width:200,align:'center'},
        {field:'usertag',title:'备注',width:200,align:'center'},
        {field:'rolename',title:'所属角色',width:200,align:'center'},
        {field:'seeArea',title:'区域查看',width:200,align:'center',formatter:function(v,r,i){
            return '点击查看';
        },styler:function(v,r,i){
            return 'color:#0E2D5F;cursor:pointer;';
        }}
        ]],
        pagination:true
       });

});
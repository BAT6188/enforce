var things = {};
things.datagridUrl = app.url('Role/dataList');
things.addUrl = app.url('Role/dataAdd');
things.editUrl = app.url('Role/dataEdit');
things.removeUrl = app.url('Role/dataRemove');
things.menuListUrl = app.url('Menu/dataList');
things.roleMenuUrl = app.url('Role/roleMenu');
things.saveMenuUrl = app.url('Role/saveMenu');
things.roleid = app.tp.roleid;
things.select_roleid;
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
        var id= m.roleid;
        if(id == things.roleid){
            $.messager.alert('删除提示','你无法删除自身,该操作只有上级用户可执行','info');
            return false;
        }
        ids.push(id);
    });
    ids = ids.join(',');
    $.ajax({
        url:things.removeUrl,
        type:'post',
        data:{
            roleid:ids
        },
        success:function(data){
            things.callback(data);
        }
    });
}
things.search = function(){
    var rolename = $('#searchInput').val();
    rolename = $.trim(rolename);
    $('#datagrid').datagrid('load',{
        rolename: rolename
    });
}
things.allowMenu = function () {
    var menuSelect = $('#menuList').tree('getChecked');
    var roleRow = $('#datagrid').datagrid('getSelections');
    var roleid = roleRow[0].roleid;
    if(menuSelect.length>0){
        var ids=[];
        for(var i=0;i<menuSelect.length;i++){
            ids.push(menuSelect[i].id);
        }
        var functionlist = ids.join(',');
        $.ajax({
            type:'GET',
            url:things.saveMenuUrl,
            data:{
                functionlist:functionlist,
                roleid:roleid
            },
            success:function(result){
                var result=eval(result);
                $.messager.alert('操作提示',result.message,'info');
                $('#menuDialog').dialog('close');
                $('#datagrid').datagrid('reload');
            }
        });
    }else{
        $.meassager.alert('信息提示','没有分配权限','info');
    }
}
things.allowMenuBar = function(){
    var row =$('#datagrid').datagrid('getSelections');
    if (row.length>1){
        $.messager.alert('提示','一次只能修改一条记录!','info');
        return false;
    }
    if(row.length==0){
        //$.messager.alert('提示','请选择角色进行权利分配!','info');
        return false;
    }
    if(row.length==1){
        things.select_roleid = row[0].roleid;
        if(things.roleid==things.select_roleid){
            $.messager.alert('操作提示','你无法对自己进行权限分配,如有需求请联系上级,如是系统管理员,已拥有全部权限');
            return false;
        }
        $('#menu_sure').show();
        $('#menuDialog').dialog('open').dialog('setTitle','权限分配');

    }
    var roleid = row[0].roleid;
    $('#menuList').tree('reload');
    things.load_have_menu(roleid);
}
//载入已拥有权限
things.load_have_menu = function(roleid){
    $.ajax({
        type:'GET',
        url:things.roleMenuUrl,
        dataType:'json',
        data:{
            roleid:roleid
        },
        success:function(getRoleMenu){
            $('#menuList').tree({
                data:getRoleMenu
            });
        }
    });
}
$(function(){
    $('#datagrid').datagrid({
        url:things.datagridUrl,
        title:'角色列表',
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[2,5,10,15,20,25,30,40,50],
        onClickCell:function(r,f,v){
            if(f=='functionlist'){
                var rowData = $(this).datagrid('getData').rows[r];
                var roleid = rowData.roleid;
                $('#menuDialog').dialog('setTitle','权限查看').dialog('open');
                $('#menuList').tree('reload');
                $('#menu_sure').hide();
                things.load_have_menu(roleid);
            }
        },
        columns:[[
        {field:'roleid',title:'id',checkbox:true},
        {field:'rolename',title:'角色名',width:200,align:'center'},
        {field:'remark',title:'角色说明',width:200,align:'center'},
        {field:'typename',title:'角色类型',width:200,align:'center'},
        {field:'functionlist',title:'权限清单',width:200,align:'center',formatter:function(v,r,i){
            return '<span style="color:#0E2D5F;cursor:pointer;">点击查看</span>';
        }}
        ]],
        pagination:true
    });
    $('#menuList').tree({
        method:'get',
        animate:true,
        lines:true,
        checkbox:true,
        cascadeCheck:true,
    });
});
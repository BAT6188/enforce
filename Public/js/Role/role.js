var things = {};
things.datagridUrl = app.url('Role/dataList');
things.addUrl = app.url('Menu/dataList');
things.editUrl = app.url('Role/dataEdit');
things.removeUrl = app.url('Role/dataRemove');
things.menuListUrl = app.url('Menu/dataList');
things.roleMenuUrl = app.url('Role/roleMenu');
things.saveMenuUrl = app.url('Role/saveMenu');
things.roleid = "{:session('roleid')}";
things.select_roleid;
things.show = function(){
    $('#searchForm').form('reset');
    $('#datagrid').datagrid('load',{});
}
things.callback = function(data){
   // data = eval('('+data+')');
    $.messager.alert('操作提示',data.message,'info');
    $('#datagrid').datagrid('reload');
}
things.addBar = function(){
    $('#addDialog').dialog('open');
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
things.add = function(){
    $('#addForm').form('submit',{
        url:things.addUrl,
        success:function(data){
            data = eval('('+data+')');
            $('#addDialog').dialog('close');
            $.messager.alert('操作提示',data.message,'info');
            $('#datagrid').datagrid('reload');
        }
    });
}
things.edit = function(){
    $('#editForm').form('submit',{
        url:things.editUrl,
        success:function(data){
            data = eval('('+data+')');
            $('#editDialog').dialog('close');
            $.messager.alert('操作提示',data.message,'info');
            $('#datagrid').datagrid('reload');
        }
    });
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
        data:{
            roleid:roleid
        },
        success:function(getRoleMenu){
            var roleMenu = new Array();
            if(getRoleMenu=='')
                return false;

            roleMenu = getRoleMenu.split(',');
            var tag = $('#menuList').tree('getChildren');
            $.each(tag,function(i,j){
                var node = $('#menuList').tree('find', j.id);
                $('#menuList').tree('uncheck', node.target);
            });
            $.each(roleMenu,function(n,m){
                var node = $('#menuList').tree('find', m);
                if(typeof(node)!='undefined'&&node!=null){
                    $('#menuList').tree('check', node.target);
                }
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
                //console.log(userid);
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
        {field:'functionlist',title:'权限清单',width:200,align:'center',formatter:function(v,r,i){
            return '<span style="color:#0E2D5F;cursor:pointer;">点击查看</span>';
        }}
        ]],
        pagination:true
    });
    $('#menuList').tree({
        //url:things.menuListUrl,
        method:'get',
        animate:true,
        lines:true,
        checkbox:true,
        cascadeCheck:true,
        loadFilter:function(rows){
            var info = eval(rows);
            return info;
        }
    });
});
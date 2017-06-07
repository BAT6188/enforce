//树的实例化
var tree = new Tree('#area_list');
var managerTree = new Tree('#areaList');
var module = {};
module.areaid = app.tp.areaid;
module.areaname = app.tp.areaname;
module.actionType = 1;
module.clickTree = function(node){
    module.areaid = node.id;
    module.areaname = node.text;
    $('#mu_ser').html(module.areaname);
    $('#infoAreaname').html('*'+module.areaname+'*添加/修改添加警员！');
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
        var info = {areaid:module.areaid,name:'',code:'',phone:'',remark:'',email:''};
        //$('#form').form('clear');
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
        infos[0].photo = infos[0].photo_path;
        $('#form').form('load',infos[0]);
    }
    $('#dialog').dialog('open');
}
module.changeinfo = function(){
    var requestUrl = module.actionType == 1 ? app.url('Employee/dataAdd') : app.url('Employee/dataEdit');
    $('#form').form('submit',{
        url:requestUrl,
        onSubmit:function(param){
            if(module.actionType == 1) delete(param.empid);
            //console.log(param.photo);
            var photo = $("#form input[name='photo']").val();
            if(photo != ''){
                var photoArr = photo.split('.');
                var type = photoArr[photoArr.length-1];
                if(type != 'jpg'){
                    $.messager.alert('上传提示','上传图片仅支持jpg格式','info');
                    return false;
                }
            }
        },
        success:function(data){
            data = eval('('+data+')');
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
    });
}
module.remove = function(){
    var infos = $('#datagrid').datagrid('getSelections');
    if(infos.length == 0) return false;
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
        },
        error:function(data){
            $('#dialog').dialog('close');
            $.messager.alert('操作提示','网络故障','info');
        }
    });
}
module.allowAreaBar = function(){
    var rowData = $('#datagrid').datagrid('getSelections');
    if(rowData.length != 1){
        $.messager.alert('操作提示','请选择一个警员进行权限分配','info');
            return false;
    }
    rowData = rowData[0];
    var empid = rowData.empid;
    managerTree.init();
    managerTree.show_emp_manger_area(empid);
    $(managerTree.dom).tree({
        checkbox:true
    });
    $('#otherInfoForm').form('load',rowData);
    $("#clientip").combobox('readonly',false);
    $("#bindingip").textbox('readonly',false);
    $('#menu_sure').show();
    $('#otherdialog').dialog('open');
}
module.allowOther = function(){
    var params = app.serializeJson('#otherInfoForm');
    var areas = $(managerTree.dom).tree('getChecked');
    if(areas.length>0){
        var ids=[];
        for(var i=0;i<areas.length;i++){
            ids.push(areas[i].id);
        }
        var userarea = ids.join(',');
        params.userarea = userarea;
    }
    $.ajax({
            type:'post',
            url:app.url('Employee/save_other_info'),
            data:params,
            dataType:'json',
            success:function(result){
                $.messager.alert('操作提示',result.message,'info');
                $('#otherdialog').dialog('close');
                $('#datagrid').datagrid('reload',{
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
    $('#infoAreaname').html('*'+module.areaname+'*添加/修改添加警员！');
    $('#mu_ser').html(module.areaname);
    $('#datagrid').datagrid({
        url:app.url('Employee/dataList'),
        method:'get',
        queryParams:{
            areaid:module.areaid,
            rand:Math.random()
        },
        onClickCell:function(r,f,v){
            if(f=='otherInfo'){
                var rowData = $(this).datagrid('getData').rows[r];
                var empid = rowData.empid;
                managerTree.init();
                managerTree.show_emp_manger_area(empid);
                $(managerTree.dom).tree({
                    checkbox:true
                });
                $('#otherInfoForm').form('load',rowData);
                $("#clientip").combobox('readonly',true);
                $("#bindingip").textbox('readonly',true);
                $('#menu_sure').hide();
                $('#otherdialog').dialog('open');
            }
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
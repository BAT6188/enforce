//树的实例化
var tree = new Tree('#area_list');
var managerTree = new Tree('#areaList');
var module = {};
module.areaid = app.tp.areaid;
module.areaname = app.tp.areaname;
module.actionType = 1;
module.page  = 1;
module.rows  = 20;
module.clickTree = function(node){
    module.areaid = node.id;
    module.areaname = node.text;
    var params = {areaid:module.areaid,page:module.page,rows:module.rows,rand:Math.random()};
    $('#mu_ser').html(module.areaname);
    module.ajaxSerach(params);
}
//基本的搜索
module.show = function(){
    var params = {areaid:module.areaid,page:module.page,rows:module.rows,rand:Math.random()};
    $('#mu_ser').html(module.areaname);
    module.ajaxSerach(params);
}
//搜索事件 ----
module.search = function(){
    var name = $('#name').val();
    name = $.trim(name);
    var params = {areaid:module.areaid,page:module.page,rows:module.rows,name:name,rand:Math.random()};
    $('#mu_ser').html(module.areaname);
    module.ajaxSerach(params);
}
module.parseInfo = function(data){
    var total = data.total;
    var info = data.rows;
    $('#pagination').pagination({
        total:total
    });

    if(info.length > 0){
        var string = '';
        $.each(info,function(n,empInfo){
            empInfo.areaname = empInfo.areaname == '' ? '未知部门' : empInfo.areaname;
            empInfo.name = empInfo.name == '' ? '姓名' : empInfo.name;
            empInfo.remark = empInfo.remark == '' ? '备注' : empInfo.remark;
            empInfo.code = empInfo.code == '' ? '警员编号' : empInfo.code;
            empInfo.photo_path = empInfo.photo_path == '' ? app.public+'image/empPhoto.jpg' : app.public+empInfo.photo_path;
            string += '<div class="photo">'+
            '<div>'+empInfo.areaname+'</div>'+
            '<img src="'+empInfo.photo_path+'" width="150px" height="200px">'+
            '<div class="imgInfo">'+
            '<div>'+empInfo.name+'</div>'+
            '<div>'+empInfo.remark+'</div>'+
            '<div>'+empInfo.code+'</div>'+
            '</div>'+
            '</div>';
        });
    }else{
        string = '<div class="no-photo">'+module.areaname+'及其子部门没有警员</div>';
    }
    $('#showPhoto').html(string);
}
module.ajaxSerach = function(params){
    $.ajax({
        url:app.url('Employee/dataList'),
        type:'post',
        data:params,
        dataType:'json',
        success:function(data){
            module.parseInfo(data);
        },
        error:function(data){
            $.messager.alert('操作提示','网络故障','info');
        }
    })
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

    $('#pagination').pagination({
        pageSize:initRows,
        pageList:[20,30,40],
        onSelectPage:function(pageNumber,pageSize){
            module.page = pageNumber;
            module.rows = pageSize;
            var params = {areaid:module.areaid,page:module.page,rows:module.rows,rand:Math.random()};
            module.ajaxSerach(params);
        }
    });
    var initRows = 20;
    var params = {areaid:module.areaid,page:1,rows:initRows,rand:Math.random()};
    //初始化面板搜索数据
    module.ajaxSerach(params);
});
//树的实例化
var tree = new Tree('#area_list');
var managerTree = new Tree('#areaList');
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
    $('#datagrid').datagrid('load',{
        areaid:module.areaid
    });
}
module.init_search_form = function(){
    var time=new Date();
     $("#searcForm input[name='start_time[btime]']").datetimebox('setValue',new Time(time,7).init());
    $("#searcForm input[name='start_time[btime]']").datetimebox({value:new Time(time,7).init()});
    $("#searcForm input[name='start_time[etime]']").datetimebox({value:new Time(time,0).init()});
    $("#searcForm input[name='scsj[btime]']").datetimebox({value:new Time(time,7).init()});
    $("#searcForm input[name='scsj[etime]']").datetimebox({value:new Time(time,0).init()});
}
$(function(){
    //树的初始化
    tree.init();
    tree.loadData();
    //树的额外参数
    $(tree.dom).tree({
        onClick:module.clickTree
    });
    //初始化搜索表单
    module.init_search_form();
    $('#mu_ser').html(module.areaname);
    $('#datagrid').datagrid({
        url:app.url('Media/media_list'),
        method:'get',
        queryParams:{
            areaid:module.areaid,
            rand:Math.random()
        },
        title:'统计信息',
        onClickCell:function(r,f,v){
            if(f=='detail'){}
        },
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[15,20,25,30],
        columns:[[
            {field:'wjbh',title:'文件名',align:'center'},
            {field:'wjbm',title:'文件别名',width:200,align:'center'},
            {field:'wjlx_name',title:'文件类型',width:200,align:'center'},
            {field:'wjcd',title:'文件长度(s)',width:200,align:'center'},
            {field:'jyxm',title:'拍摄警员',width:200,align:'center'},
            {field:'areaname',title:'所属部门',width:200,align:'center'},
            {field:'start_time',title:'拍摄时间',align:'center'},
            {field:'scsj',title:'上传时间',align:'center'},
            {field:'bzlx_name',title:'标注类型',width:200,align:'center'},
            {field:'mark',title:'备注',width:200,align:'center'},
            {field:'video_type_name',title:'视频类型',width:200,align:'center'},
            {field:'detail',title:'查看详情',width:200,align:'center',formatter:function(v,r,i){
                    return '点击查看';
                 },styler:function(v,r,i){
                    return 'color:#0E2D5F;cursor:pointer;';
                }}
            ]],
        pagination:true
    });
});
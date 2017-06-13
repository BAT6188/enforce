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
        url:app.url('Media/work_emp_sat'),
        method:'get',
        queryParams:{
            areaid:module.areaid,
            rand:Math.random()
        },
        title:'统计信息',
        fitColumns:true,
        rownumbers:true,
        fit:true,
        pageSize:15,
        pageNumber:1,
        pageList:[15,20,25,30],
        columns:[[
            {field:'name',title:'警员',width:200,align:'center'},
            {field:'areaname',title:'所属部门',width:200,align:'center'},
            {field:'num',title:'总数',width:200,align:'center'},
            {field:'video',title:'视频',width:200,align:'center'},
            {field:'vioce',title:'音频',width:200,align:'center'},
            {field:'wjcd',title:'文件长度(s)',width:200,align:'center'},
            {field:'picture',title:'图片',width:200,align:'center'},
            {field:'unkonwn',title:'未知文件',width:200,align:'center'},
            {field:'ismark',title:'已编辑',width:200,align:'center'},
            {field:'nomark',title:'未编辑',width:200,align:'center'}
        ]],
        pagination:true,
        onLoadSuccess : function(data) {
            console.log(data);
            var info = {};
            info.total = 0;
            info.rows = [];
            return info;
            if (data.error) {
                var body = $(this).data().datagrid.dc.body2;
                console.info(body);
                body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 35px; text-align: center;"><h1>暂无数据</h1></td></tr>');
            }
        }
    });
});
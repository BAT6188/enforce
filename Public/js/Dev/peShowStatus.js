/**
 * Created by Administrator on 2017/6/10.
 */
var obj={pagesize:20,areaid:53};
$(function(){
    //左侧tree的加载
    var tree=new Tree('#tree');
    tree.init();
    tree.loadData();
    $('#datagrid').datagrid({
        title:'执法仪状态',
        pagination:true,
        pageSize:15,
        pageNumber:1,
        pageList:[10,20,30,40,50],
        pagePosition:'bottom',
        toolbar:'#toolbar'
    });
    ajaxStatus(obj.pagesize,obj.areaid);
    $('#tree').tree({
        onSelect:function(node){
            console.log(node);
            obj.areaid=node.id;
            ajaxStatus(obj.pagesize,obj.areaid);
        }
    });

    $('#datagrid').datagrid('getPager').pagination({
        onChangePageSize:function(pagesize){
             obj.pagesize=pagesize;
             ajaxStatus(obj.pagesize,obj.areaid);
        }
   });

});

function ajaxStatus(n,id){
    $.ajax({
        url:app.url('Dev/pe_base_list'),
        type:'GET',
        data:{status:true,areaid:id},
        success:function(data){
            var count=Math.min(data.total,n);
            //var str='';
            //var div2='<div class="d2"><p class="p"></p><div class="d3"><div class="d41"></div><form class="d42"></form></div></div></div>';
            var f='<div><label>姓名:</label><input type="text" name="jyxm"/></div>' +
                '<div><label>警号:</label><input type="text" name="jyxm"/></div>' +
                '<div><label>使用次数:</label><input type="text" name="jyxm"/></div>';
            //var m;
            for(var i=0;i<count;i++){
                //str+='<div class="d2">' +
                //    '<p>执法产品序号：'+data.rows[i].cpxh+'</p>' +
                //    '<div class="d3">' +
                //    '<div class="d41"></div>'+
                //    '<div class="d42">姓名：'+data.rows[i].jyxm+'</br>警号：'+data.rows[i].jybh+'</br>使用次数：'+data.rows[i].times+'/7</div>'+
                //    '</div>'+
                //'</div>'

                data.rows[i].times=data.rows[i].times+'/7';
                data.rows[i].statusCN=data.rows[i].status==0?'停用':'1'?'使用率低':'活跃';
                console.log(data.rows[i]);
                //divmsg(div2,form, m.cpxh, m.status, m.jyxm, m.jybh, m.times+'/7');
                divmsg(f,data.rows[i]);
            }
        }
    });
}
function divmsg(f,data){
    var p=document.createElement('p');
    $(p).addClass('p').html('执法产品序号:'+data.cpxh);
    var div3=document.createElement('div');
    var div41=document.createElement('div');
    $(div41).addClass('d41');
    $(div41).append('<img src="'+app.public+'image/status_'+data.status+'.png" />').append('<span>'+data.statusCN+'</span>');
    var form=document.createElement('form');
    $(form).addClass('form').append(f).form('load',data);
    console.log($(form));
    $(div3).append(div41).append(form);
    var div2=document.createElement('div');
    $(div2).addClass('d2').append(p).append(div3);
    $('#d1').append(div2);
    console.log(div2);
}
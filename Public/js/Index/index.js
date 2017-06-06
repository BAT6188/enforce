function createFrame(url) {
    var s = '<iframe scrolling="auto" frameborder="0"  style="width:100%;height:99.5%;" src="' + url + '" ></iframe>';
    return s;
}

function showTab(url,title,icon){
    if ($('#tabs').tabs('exists',title)){
        $('#tabs').tabs('select',title);
    } else {
        var tabNum = $('#tabs').tabs('tabs').length;
        //console.log($('#SystemTabs').tabs('tabs'));
        if(tabNum > 9){
            $.messager.alert('信息提示','目前的打开窗口太多了！关闭一些在打开吧。','info');
            return false;
        }
        $('#tabs').tabs('add',{
            title:title,
            content:createFrame(url),
            closable:true,
            border:false,
            iconCls:icon,
            onLoadError:function(data){
                var info=eval('('+data.responseText+')');
                $.messager.confirm('错误提示',info.message,function(r){
                    $('#tabs').tabs('close',title);
                });
                return false;
            }
        });
    }
}
function closeTab () {
    var alltabs = $('#tabs').tabs('tabs');
    var allTitle = new Array();
    $.each(alltabs,function(n,m){
        allTitle.push($(m).panel('options').title);
    });
    $.each(allTitle,function(i,j){
         if(j != '首页'){
            $('#tabs').tabs('close', j);
            return true;
        }
    });
}
function menuHandler(item) {
    if(item.url!=''){
        showTab(item.url,item.text,item.iconCls);
    }
}
function change_password(){
    var newpassword = $('#newpassword').textbox('getValue');
    var surepassword = $('#surepassword').textbox('getValue');
    if((newpassword == '') || (surepassword == '') || (newpassword != surepassword)){
        $.messager.alert('信息提示','密码不能为空或两次输入的密码不一致','error');
        return false;
    }
    $.ajax({
        url:"{:U('Index/change_password')}",
        dataType:'json',
        data:{
            newpassword:newpassword
        },
        success:function(data){
            if(data.status){
                $.messager.alert('结果提示','修改密码成功，下次登陆时生效','info');
            }else{
                $.messager.alert('结果提示',data.message,'info');
            }
            $('#dialog').dialog('close');
        }
    });
}
$(function(){
    $('#tabs').tabs({
        tools: [
            {
            iconCls: 'icon-reload',
            handler: function () {
                    var tab = $('#tabs').tabs('getSelected');
                    var iframe = $(tab.panel('options').content);
                    var src = iframe.attr('src');
                    $('#tabs').tabs('update', {
                        tab: tab,
                        options: {
                            content: createFrame(src)
                        }
                    });
                    return false;
                }
            },
            {
            iconCls: 'icon-cancel',
            handler: function () {
                $.messager.confirm('操作提示','亲，确认要关闭所有窗口吗？',function(n){
                    if(n){
                        closeTab();
                    }
                });
            }
        }],
        onBeforeClose:function(title){
            if(title=='首页'){
                $.messager.alert('操作提示','首页无法关闭哦!','info');
                return false;
            }
        }
    });
    showTab(app.url('Index/home'),'首页','icon-house');
    $('#changePassword').click(function(){
        $('#dialog').dialog('open');
    });
    var date = new Date();
    var year = date.getFullYear();
    $("#year").html(year);
});
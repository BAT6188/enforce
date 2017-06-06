function login(){

    var username = $.trim($("#username").val());
    var password = $.trim($("#password").val());
    if(username == ''){
         $('#info').html('用户名不能为空!');
        return false;
    }
    if(password == ''){
        $('#info').html('密码不能为空!');
        return false;
    }
    $('#info').html('正在验证登陆...');
    $.ajax({
        url:app.url('Index/check_login'),
        type:'post',
        dataType:'json',
        data:{
            username:username,
            password:password
        },
        success:function(data){
            if(data.status){
                window.location.href = app.url('Index/index');
            }else{
                $('#info').html(data.message);
            }
        },
        error:function(){
            $('#info').html('抱歉网络发生错误,无法登录！');
        }
    });
}
$(function(){
    $('#loginButton').click(function(){
        login();
    });
    $('#resetButton').click(function(){
        $('#loginBox').form('clear');
        $('#info').html('');
    });

    $('#info').html(info);
    document.onkeydown = keyDownSearch;

    function keyDownSearch(e) {
        // 兼容FF和IE和Opera
        var theEvent = e || window.event;
        var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
        if (code == 13) {
            login();
            return false;
        }
        return true;
    }
});
$(function(){
    var playVlc = new PlayVlc('#con','vlc');
    $('#con').width($(window).width()/1.5);
    $('#con').height($(window).width()/1.5*9/16);
    playVlc.setWH($(playVlc.container).width(),$(playVlc.container).height());
    $(window).resize(function () {          //当浏览器大小变化时
        $(playVlc.container).width($(this).width()/1.5);
        $(playVlc.container).height($(this).width()/1.5*9/16);
        playVlc.setWH($(playVlc.container).width(),$(playVlc.container).height());
    });
    playVlc.play();
});
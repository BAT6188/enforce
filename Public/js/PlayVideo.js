var PlayVideo = function(container){
    this.container = container;         //vlc的容器
    this.get_explorer();
}
PlayVideo.prototype.loadVLC = function(){
    var vlcString;
    if(this.explorer == 'ie'){
        vlcString = '<object classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" '+
                    'codebase="http://download.videolan.org/pub/videolan/vlc/last/win32/axvlc.cab">'+
                        '<param name="autostart" value="true" />'+
                        '<param name="allowfullscreen" value="false" />'+
                    '</object>';
    }
    if(this.explorer == 'Firefox'){
        vlcString = '<embed type="application/x-vlc-plugin" pluginspage="http://www.videolan.org" />';
    }
}
//获取浏览器信息
PlayVideo.prototype.get_explorer = function(){
    var explorer = window.navigator.userAgent;
    //ie
    if (explorer.indexOf("MSIE") >= 0) {
        this.explorer = "ie";
    }
    //firefox
    else if (explorer.indexOf("Firefox") >= 0) {
        this.explorer = "Firefox";
    }
    //Chrome
    else if(explorer.indexOf("Chrome") >= 0){
        this.explorer = "Chrome";
    }
    //Opera
    else if(explorer.indexOf("Opera") >= 0){
        this.explorer = "Opera";
    }
    //Safari
    else if(explorer.indexOf("Safari") >= 0){
        this.explorer = "Safari";
    }
}

PlayVideo.prototype.vlcWH = function(){

    this.vlcWidth = $(this.container).width();
    this.vlcHeight = $(this.container).height();
}
PlayVideo.prototype.containerResize = function(){
    var self = this;
    $(self.container).resize(function(){
        $(this).height();
        $(this).width();
    })
}
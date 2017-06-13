/**
 * Created by Administrator on 2017/6/8.
 */
//t:当前时间
//n:当前时间的前n天
//function times(t,n){
//    var time=new Date(t.getTime()-n*24*3600*1000);
//    var y=time.getFullYear();
//    var m=(m=(time.getMonth()+1))<10?'0'+m:m;
//    var d=(d=time.getDate())<10?'0'+d:d;
//    var hh=(hh=time.getHours())<10?'0'+hh:hh;
//    var mm=(mm=time.getMinutes())<10?'0'+mm:mm;
//    var ss=(ss=time.getMilliseconds()*60/1000)<10?'0'+ss:ss;
//    return y+'-'+m+'-'+d+' '+hh+':'+mm+':'+ss;
//}
function Time(t,n){
    this.t=t;
    this.n=n;
}
Time.prototype.init=function(){
    var time=new Date(this.t.getTime()-this.n*24*3600*1000);
    var y=time.getFullYear();
    var m=(m=(time.getMonth()+1))<10?'0'+m:m;
    var d=(d=time.getDate())<10?'0'+d:d;
    var hh=(hh=time.getHours())<10?'0'+hh:hh;
    var mm=(mm=time.getMinutes())<10?'0'+mm:mm;
    var ss=(ss=time.getMilliseconds()*60/1000)<10?'0'+ss:ss;
    return y+'-'+m+'-'+d+' '+hh+':'+mm+':'+ss;
};

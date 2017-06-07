var Tree = function(dom){
    this.dom = dom;
}
Tree.prototype.loadData = function (){
    var self = this;
    var dom = this.dom;
    $.ajax({
        url:app.url('Area/data_tree_list')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        success:function(data){
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.loadUserArea = function (userid){
    var dom = this.dom;
    $.ajax({
        url:app.url('Area/tree_list_all')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        data:{
            userid:userid
        },
        success:function(data){
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.load_dev_area = function(){
    var dom = this.dom;
    $.ajax({
        url:app.url('Dev/show_dev')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        success:function(data){
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.load_emp_tree = function(){
    var dom = this.dom;
    $.ajax({
        url:app.url('Employee/show_employee')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        success:function(data){
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.show_emp_manger_area = function(empid){
    var dom = this.dom;
    $.ajax({
        url:app.url('Employee/show_emp_manger_area')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        data:{
            empid:empid
        },
        success:function(data){
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.init = function(){
    $(this.dom).tree({
        animate:true,
        lines:true,
        cascadeCheck:true
    });
}
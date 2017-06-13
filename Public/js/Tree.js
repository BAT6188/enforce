var Tree = function(dom){
    this.dom = dom;
    this.data;
}
Tree.prototype.loadData = function (noS){
    var self = this;
    var dom = this.dom;
    var load = typeof noS == 'undefined' ? false : noS;
    $.ajax({
        url:app.url('Area/data_tree_list')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        data:{
            new:load
        },
        success:function(data){
            self.data = jQuery.extend(true, [], data);
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.loadUserArea = function (userid){
    var dom = this.dom;
    var self = this;
    $.ajax({
        url:app.url('Area/tree_list_all')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        data:{
            userid:userid
        },
        success:function(data){
            self.data = jQuery.extend(true, [], data);
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.load_dev_area = function(){
    var dom = this.dom;
    var self = this;
    $.ajax({
        url:app.url('Dev/show_dev')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        success:function(data){
            self.data = jQuery.extend(true, [], data);
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.load_emp_tree = function(){
    var dom = this.dom;
    var self = this;
    $.ajax({
        url:app.url('Employee/show_employee')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        success:function(data){
            self.data = jQuery.extend(true, [], data);
            $(dom).tree('loadData',data);
        }
    });
}
Tree.prototype.show_emp_manger_area = function(empid){
    var dom = this.dom;
    var self = this;
    $.ajax({
        url:app.url('Employee/show_emp_manger_area')+'?&rand='+Math.random(),
        type:'get',
        dataType:'json',
        data:{
            empid:empid
        },
        success:function(data){
            self.data = jQuery.extend(true, [], data);
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
/**
 * 搜索树
 * @param  string info 搜索内容
 * @param  int type 搜索类型 1为部门 2为警员
 * @return json
 */
Tree.prototype.search_data = function(data,info,type){
    var searchData = [];
    for (var i = 0; i < data.length; i++) {
        //判断有没有子集
        if(typeof data[i].children == 'undefined'){
            if(type == 2){
                //判断有没有警号
                if(typeof data[i].code != 'undefined'){
                    //搜索警号,姓名
                    if(data[i].code.indexOf(info) > -1 || data[i].name.indexOf(info) > -1){
                        searchData.push(data[i]);
                    }
                }
            }
            if(type == 1){
                //搜索部门
                if(data[i].text.indexOf(info) > -1){
                    searchData.push(data[i]);
                }
            }
        }else{
            //判断子集
            children = this.search_data(data[i].children,info,type);
            //如果子集有满足条件的那么直接叠加
            if(children.length > 0){
                var info = {};
                info.children = children;
                for(var field in data[i]){
                    if(field != 'children'){
                        info[field] = data[i][field];
                    }
                }
                searchData.push(info);
            }else{
                //否则判断自身是否满足条件
                if(type == 1){      //如果是部门
                    if(data[i].text.indexOf(info) > -1){
                        //searchData.push(data[i]);
                        var text = {};
                        for(var field in data[i]){
                            if(field != 'children'){
                                text[field] = data[i][field];
                            }
                        }
                        searchData.push(text);
                    }
                }
                //如果是警员 理论上是不会出现的这种情况  但是为了程序的健壮性还是加上比较好
                if(type == 2){    
                    if(typeof data[i].code != 'undefined'){  
                        if(data[i].code.indexOf(info) > -1 || data[i].name.indexOf(info) > -1){
                            var text = {};
                            for(var field in data[i]){
                                if(field != 'children'){
                                    text[field] = data[i][field];
                                }
                            }
                            searchData.push(text);
                        }
                    }
                }
            }
        }
    }
    return searchData;
}
Tree.prototype.search_tree = function(info,type){
    var data = this.search_data(this.data,info,type);
    if(type == 2){
        //要想实现在子节点添加复选框 下面的条件是必须的一个都不能少
        $(this.dom).tree({
            multiple:true,
            checkbox:true,
            onlyLeafCheck:true,

        });
    }
    if(type == 1){
        $(this.dom).tree({
            multiple:false,
            checkbox:false,
            onlyLeafCheck:false
        });
    }
    $(this.dom).tree('loadData',data);
    //展开所有节点
    $(this.dom).tree('expandAll');
    
}
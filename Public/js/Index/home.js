var tree = new Tree('#emp_area');
$(function(){
    tree.init();
    tree.load_emp_tree();
    
    setTimeout(function(){
        tree.search_tree('王',2);
    },3000)

    
});
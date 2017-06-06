外面建立的js属于公共的js，对于view引入的js按照view目录建立用于引入js。
实例
-App.js
-Index	     //对应与 APP/Home/View/Index目录 Index
--index.js   //Index下的index,js 页面使用

对于公共的js:
    文件名对应对象名（对象有且仅有一个）  
    公共方法使用的变量 普通页面禁止使用
    比如 App.js   App  app APP 等相关全部禁止使用
外面建立的js属于公共的js，对于view引入的js按照view目录建立用于引入js。
实例
-App.js      //公共方法文件
-Index       //对应与 APP/Home/View/Index目录 Index
--index.js   //Index下的index,js 页面使用

对于公共的js:
    文件名对应对象名（对象有且仅有一个）
    公共方法使用的变量 普通页面禁止使用，比如 App.js   App  app APP 等相关全部禁止使用

对于插件引入:
    放置位置 Public/plugins   各个要分目录
    对于插件选择 选择兼容性好的插件 最低 IE8

常用公共方法和变量:
    app.url()   /  app.url('Index/index')       //生成TP标准的URL
    app.serializeJson()   / app.serializeJson('#form')   //序列化表单json
    app.public  对应与Public目录    app.public+'js/App.js'

App.js  文件内容不要随意改动，除非发生bug，不要去新增方法，或删除方法

Tips:
    1.241上面没有按照要求的js公共文件，不要引用。
    2.避免一切在241上面已经发生的bug
    3.虽然可以使用框架内目前在IE下console.log()不会报错，但是尽量移除
    4.对于后端传值一律使用 app.tp  来接收  | app.tp.areaid = "{:$areaid}";  在html页面实现; 使用时可随意
    5.必须严格区分大小写

关于整体项目
    参照大帝平台界面（仅仅是参考数据显示内容，一切样式，布局尽量重新思考）

    目前需要的功能在 移动警务通管理平台功能列表－包头.xlsx

    enforce.sql可使用phpstudy在本地部署，数据库连接时  连接属性>高级>编码  936选第一个

    由于时间紧迫目前没有控制器,数据使用静态的。字段有关联带有id字段的将id改为name  areaid改为areaname
    新建页面访问方法  http://目录/index.php/Home/Demo/test_page/page/___
    比如 新建devStatus.html http://目录/index.php/Home/Demo/test_page/page/devStatus

    一切都可以布局需要的数据内容，格式可以自己定义  json为主  传给后端的多同样属性的使用 , 隔开  比如 '1,2'

    不要随意在Pulic目录下新建目录

    提醒：1.执法查询 支持多文件同时编辑
              2.需要播放视频  使用vlc插件   先写公共方法  IE火狐同时兼容
              3.项目整体需要体现权限管理
              4.http://221.181.209.245:86/web/index.php/Login/index.html  adm 123123
              5.执法仪状态  参照上平台 设备管理  终端设备管理 图形部分

/*
Navicat MySQL Data Transfer

Source Server         : 192.168.0.249
Source Server Version : 50541
Source Host           : 192.168.0.249:3306
Source Database       : enforce

Target Server Type    : MYSQL
Target Server Version : 50541
File Encoding         : 936

Date: 2017-06-01 17:18:16
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `area_dep`
-- ----------------------------
DROP TABLE IF EXISTS `area_dep`;
CREATE TABLE `area_dep` (
  `areaid` int(11) NOT NULL AUTO_INCREMENT,
  `proid` int(11) DEFAULT '1' COMMENT '暂不用，固定填1',
  `fatherareaid` int(11) NOT NULL,
  `areaname` varchar(128) NOT NULL COMMENT '区域(部门)名称',
  `areacode` varchar(64) DEFAULT '0000000000' COMMENT '暂不用',
  `rperson` varchar(64) DEFAULT NULL,
  `rphone` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`areaid`),
  KEY `fk_areareg_areapro_proid` (`fatherareaid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=92 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of area_dep
-- ----------------------------
INSERT INTO `area_dep` VALUES ('57', '1', '55', '机动车监管中心', '00002111', '', '');
INSERT INTO `area_dep` VALUES ('56', '1', '55', '法制科', '00001111', '', '');
INSERT INTO `area_dep` VALUES ('55', '1', '54', '特警大队', '00000111', '', '');
INSERT INTO `area_dep` VALUES ('54', '1', '53', '包头市交管支队', '00000011', '', '');
INSERT INTO `area_dep` VALUES ('53', '1', '0', '内蒙古自治区公安局', '00000001', '', '');
INSERT INTO `area_dep` VALUES ('58', '1', '54', '昆区大队', '00000112', '', '');
INSERT INTO `area_dep` VALUES ('59', '1', '58', '管理中队', '00001112', '', '');
INSERT INTO `area_dep` VALUES ('60', '1', '58', '车管分所', '00002112', '', '');
INSERT INTO `area_dep` VALUES ('61', '1', '58', '昆区一中队', '00003112', '', '');
INSERT INTO `area_dep` VALUES ('62', '1', '58', '昆区二中队', '00004112', '', '');
INSERT INTO `area_dep` VALUES ('63', '1', '58', '昆区三中队', '00005112', '', '');
INSERT INTO `area_dep` VALUES ('64', '1', '58', '昆区四中队', '00006112', '', '');
INSERT INTO `area_dep` VALUES ('65', '1', '58', '昆区五中队', '00007112', '', '');
INSERT INTO `area_dep` VALUES ('66', '1', '58', '昆区六中队', '00008112', '', '');
INSERT INTO `area_dep` VALUES ('67', '1', '58', '昆区事故中队', '00009112', '', '');
INSERT INTO `area_dep` VALUES ('68', '1', '58', '昆区警务督察办', '00010112', '', '');
INSERT INTO `area_dep` VALUES ('69', '1', '54', '青山区大队', '00000113', '', '');
INSERT INTO `area_dep` VALUES ('70', '1', '54', '东河区大队', '00000114', '', '');
INSERT INTO `area_dep` VALUES ('71', '1', '54', '九原区大队', '00000115', '', '');
INSERT INTO `area_dep` VALUES ('72', '1', '54', '高新大队', '00000116', '', '');
INSERT INTO `area_dep` VALUES ('73', '1', '54', '土右大队', '00000117', '', '');
INSERT INTO `area_dep` VALUES ('74', '1', '54', '石拐大队', '00000118', '', '');
INSERT INTO `area_dep` VALUES ('75', '1', '54', '固阳大队', '00000119', '', '');
INSERT INTO `area_dep` VALUES ('76', '1', '54', '达茂大队', '00000120', '', '');
INSERT INTO `area_dep` VALUES ('78', '1', '54', '东兴大队', '00000122', '', '');
INSERT INTO `area_dep` VALUES ('79', '1', '54', '南绕城大队', '00000123', '', '');
INSERT INTO `area_dep` VALUES ('80', '1', '54', '河西大队', '00000124', '', '');
INSERT INTO `area_dep` VALUES ('81', '1', '54', '北郊大队', '00000125', '', '');
INSERT INTO `area_dep` VALUES ('82', '1', '54', '车管所', '00000126', '', '');
INSERT INTO `area_dep` VALUES ('83', '1', '54', '机动大队', '00000127', '', '');
INSERT INTO `area_dep` VALUES ('84', '1', '54', '督察大队', '00000128', '', '');
INSERT INTO `area_dep` VALUES ('85', '1', '74', '石拐一中队', '00001128', '', '');
INSERT INTO `area_dep` VALUES ('86', '1', '74', '石拐二中队', '00002128', '', '');
INSERT INTO `area_dep` VALUES ('87', '1', '74', '石拐三中队', '00003128', '', '');
INSERT INTO `area_dep` VALUES ('88', '1', '74', '石拐四中队', '00004128', '', '');
INSERT INTO `area_dep` VALUES ('89', '1', '74', '石拐事故中队', '00005128', '', '');
INSERT INTO `area_dep` VALUES ('90', '1', '74', '石拐督察法制办', '00006128', '', '');

-- ----------------------------
-- Table structure for `area_pro`
-- ----------------------------
DROP TABLE IF EXISTS `area_pro`;
CREATE TABLE `area_pro` (
  `proid` int(11) NOT NULL AUTO_INCREMENT,
  `proname` varchar(32) NOT NULL,
  PRIMARY KEY (`proid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of area_pro
-- ----------------------------
INSERT INTO `area_pro` VALUES ('1', '部门');

-- ----------------------------
-- Table structure for `employee`
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `empid` int(11) NOT NULL AUTO_INCREMENT,
  `areaid` int(11) NOT NULL DEFAULT '1' COMMENT '区域(部门)ID',
  `name` varchar(32) NOT NULL DEFAULT '无' COMMENT '警员名',
  `code` varchar(32) NOT NULL DEFAULT '无' COMMENT '登陆账号,一般是警员编号,同时变更user.username',
  `sex` char(4) DEFAULT '男',
  `phone` varchar(32) DEFAULT NULL,
  `email` varchar(32) DEFAULT NULL,
  `libnum` varchar(16) DEFAULT '-1',
  `remark` varchar(200) DEFAULT NULL,
  `photo_path` varchar(128) DEFAULT NULL COMMENT '警员相片绝对位置(URL)',
  `is_police` int(2) NOT NULL DEFAULT '1' COMMENT '0:非警员，1：警员',
  `is_adm` int(2) NOT NULL DEFAULT '0' COMMENT '0:非，1：是管理员',
  PRIMARY KEY (`empid`),
  UNIQUE KEY `idx_code` (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES ('11', '88', '王二', '000113', '男', '12345678901', '', '-1', '民警', null, '1', '0');
INSERT INTO `employee` VALUES ('10', '88', '王一', '000112', '男', '12345678902', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('9', '88', '张晓明', '000111', '男', '12345678903', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('16', '88', '王六', '000117', '男', '12345678907', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('13', '88', '王三', '000114', '男', '12345678904', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('14', '88', '王四', '000115', '男', '12345678905', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('15', '88', '王五', '000116', '男', '12345678906', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('17', '88', '王七', '000118', '男', '12345678908', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('18', '88', '王强', '000119', '男', '12345678909', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('19', '88', '王九', '000120', '男', '12345678910', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('20', '88', '李一', '000121', '男', '12345678911', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('21', '88', '李二', '000122', '男', '12345678912', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('22', '88', '李三', '000123', '男', '12345678913', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('23', '88', '李四', '000124', '男', '12345678914', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('24', '88', '李五', '000125', '男', '12345678915', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('25', '88', '李六', '000126', '男', '12345678916', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('26', '88', '李七', '000127', '男', '12345678917', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('27', '88', '文刚', '000128', '男', '12345678918', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('28', '88', '文里', '000129', '男', '12345678919', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('29', '74', '警员', '123456', '男', '123456789030', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('31', '54', '盾华', 'admin', '男', '', '', '-1', '', null, '0', '1');

-- ----------------------------
-- Table structure for `menu`
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `pid` int(11) DEFAULT '0' COMMENT '菜单父ID',
  `name` varchar(64) NOT NULL,
  `url` varchar(128) DEFAULT NULL,
  `ordernum` int(11) DEFAULT '0',
  `iconcls` varchar(64) DEFAULT NULL,
  `enable` int(2) DEFAULT '1' COMMENT '0:禁用,1:启用',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES ('100', '0', '系统管理', '', '0', 'icon-wrench', '1');
INSERT INTO `menu` VALUES ('101', '100', '角色管理', 'Rolereg/index', '1', 'icon-folder_user', '1');
INSERT INTO `menu` VALUES ('102', '100', '用户管理', 'Userreg/index', '2', 'icon-status_online', '1');
INSERT INTO `menu` VALUES ('103', '100', '部门管理', 'Areareg/index', '3', 'icon-world', '1');
INSERT INTO `menu` VALUES ('200', '0', '设备管理', '', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('201', '200', '站点管理', 'Serinfo/index', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('300', '0', '警员管理', '', '2', 'icon-group', '1');
INSERT INTO `menu` VALUES ('301', '300', '基本信息', 'Employee/index', '1', 'icon-vcard', '1');
INSERT INTO `menu` VALUES ('302', '300', '访客管理', '', '2', 'icon-user', '1');
INSERT INTO `menu` VALUES ('303', '300', '照片查询', 'Employee/showPhoto', '3', 'icon-picture_go', '1');
INSERT INTO `menu` VALUES ('304', '300', '底库分析', 'Photolib/index', '4', 'icon-photos', '1');
INSERT INTO `menu` VALUES ('400', '0', '统计分析', '', '3', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('401', '400', '车辆盘查统计', '', '1', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('402', '400', '人员盘查统计', '', '2', 'icon-user_comment', '1');
INSERT INTO `menu` VALUES ('404', '400', '巡警考勤统计', '', '3', 'icon-film_link', '1');
INSERT INTO `menu` VALUES ('500', '0', '综合查询', '', '4', 'icon-script', '1');
INSERT INTO `menu` VALUES ('502', '500', '照片下发', null, '0', null, '1');
INSERT INTO `menu` VALUES ('501', '500', '车辆排查', null, '0', null, '1');
INSERT INTO `menu` VALUES ('503', '500', '数据管理', 'Capturerecord/index', '3', 'icon-report_magnify', '1');
INSERT INTO `menu` VALUES ('403', '400', '用户在线统计', 'Mutisearch/index', '0', 'icon-dvd_link', '1');
INSERT INTO `menu` VALUES ('202', '200', '执法记录仪', 'Dev/index', '0', 'icon-camera', '1');
INSERT INTO `menu` VALUES ('504', '500', '出租车查询', null, '0', null, '1');
INSERT INTO `menu` VALUES ('505', '500', '执法记录查询', 'Recored/index', '0', null, '1');
INSERT INTO `menu` VALUES ('506', '500', '人员排查', null, '0', null, '1');
INSERT INTO `menu` VALUES ('405', '400', '设备统计', null, '5', null, '1');
INSERT INTO `menu` VALUES ('406', '400', '站点统计', null, '6', null, '1');
INSERT INTO `menu` VALUES ('407', '400', '分类统计', null, '7', null, '1');
INSERT INTO `menu` VALUES ('408', '400', '拍摄统计', null, '0', null, '1');

-- ----------------------------
-- Table structure for `pe_base`
-- ----------------------------
DROP TABLE IF EXISTS `pe_base`;
CREATE TABLE `pe_base` (
  `cpxh` varchar(7) NOT NULL COMMENT '产品(执法仪)序号 7位',
  `jybh` varchar(6) NOT NULL COMMENT '警员编号',
  `jyxm` varchar(32) DEFAULT NULL COMMENT '警员姓名',
  PRIMARY KEY (`cpxh`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pe_base
-- ----------------------------
INSERT INTO `pe_base` VALUES ('1111111', '123456', null);

-- ----------------------------
-- Table structure for `pe_log_list`
-- ----------------------------
DROP TABLE IF EXISTS `pe_log_list`;
CREATE TABLE `pe_log_list` (
  `id` int(11) NOT NULL,
  `cpxh` varchar(7) NOT NULL DEFAULT '0000000' COMMENT '产品(执法仪)序号',
  `rzlx` int(2) NOT NULL DEFAULT '0' COMMENT '日志类型,1:关机，2：开机，3：拍照，4：录像，5：录音，7：结束录像，0：其它',
  `wjmc` varchar(100) DEFAULT NULL COMMENT '文件名称',
  `rzsj` datetime NOT NULL COMMENT '日志时间',
  `jybh` varchar(6) NOT NULL COMMENT '警员编号',
  `gzzbh` varchar(12) NOT NULL COMMENT '工作站编号',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '认证密钥',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pe_log_list
-- ----------------------------

-- ----------------------------
-- Table structure for `pe_video_list`
-- ----------------------------
DROP TABLE IF EXISTS `pe_video_list`;
CREATE TABLE `pe_video_list` (
  `wjbh` varchar(100) NOT NULL DEFAULT '0000000@209901010101010000' COMMENT '文件编号 <产口序号>@<年月日><文件序号>',
  `wjbm` varchar(100) DEFAULT NULL COMMENT '文件别名',
  `pssj` datetime NOT NULL COMMENT '拍摄时间',
  `wjdx` varchar(32) DEFAULT NULL COMMENT '文件大小',
  `wjlx` int(2) DEFAULT NULL COMMENT '0:未知,1:视频,2:音频,3:图片',
  `jyxm` varchar(60) DEFAULT NULL COMMENT '警员姓名',
  `jybh` varchar(6) NOT NULL DEFAULT '000000' COMMENT '警员编号',
  `dwbh` varchar(12) DEFAULT NULL COMMENT '单位编号',
  `dwmc` varchar(100) DEFAULT NULL COMMENT '单位名称',
  `cpxh` varchar(7) NOT NULL DEFAULT '0000000' COMMENT '产品(执法仪)序号 7位',
  `ccfwq_ip` varchar(64) DEFAULT NULL COMMENT '存储服务器',
  `ccwz` varchar(200) DEFAULT NULL COMMENT '存储位置',
  `bfwz` varchar(200) NOT NULL DEFAULT 'http://' COMMENT '播放位置',
  `wlwz` varchar(200) DEFAULT NULL COMMENT '物理位置',
  `scsj` datetime NOT NULL DEFAULT '2099-01-01 00:00:00' COMMENT '上传时间',
  `bzlx` int(2) DEFAULT '0' COMMENT '标注类型,0:未标注,1:标注(典型案例)',
  `gzzbh` varchar(12) NOT NULL DEFAULT '0' COMMENT '工作站编号',
  `gzz_ip` varchar(64) NOT NULL COMMENT '工作站IP',
  `mark` varchar(512) DEFAULT '无' COMMENT '备注',
  `upload` int(2) NOT NULL DEFAULT '0' COMMENT '0:不上传，1：上传到中心服务器(重要视频)',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '认证密钥',
  PRIMARY KEY (`wjbh`,`jybh`),
  KEY `idx_jybh` (`jybh`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pe_video_list
-- ----------------------------
INSERT INTO `pe_video_list` VALUES ('1111111@201506250850560000', '吴晓@201506250850560000.mp4', '2015-06-25 08:50:56', '6.5', '1', null, '123456', null, null, '1111111', '192.168.0.249', null, 'http://192.168.0.249/pe_data/1111111/20160523/mp4/1111111@201506250850560000.mp4', null, '2017-05-24 17:44:11', null, '12345', '192.168.0.222', null, '0', null);

-- ----------------------------
-- Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `roleid` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(64) NOT NULL,
  `remark` varchar(128) DEFAULT NULL,
  `functionlist` varchar(4096) DEFAULT NULL,
  `proleid` int(11) DEFAULT NULL COMMENT '角色父id',
  PRIMARY KEY (`roleid`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '系统管理员', '拥有所有操作权限', '100,101,102,103,200,201,202,300,301,302,303,304,400,401,402,403,404,405,406,407,408,500,501,502,503,504,505', '0');
INSERT INTO `role` VALUES ('2', '普通用户', '拥有基本的操作权限', '500,503,502,501,400,404,402,401,403,300,304,303,302,301,200,201,202,100,103,102,101', '1');
INSERT INTO `role` VALUES ('4', '设备用户', '拥有用户对设备管理的权限', '500,503,502,501,303,301,202,100,103,102,101', '2');

-- ----------------------------
-- Table structure for `sys_log`
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aid` int(11) NOT NULL DEFAULT '0',
  `cmt` varchar(128) NOT NULL DEFAULT '',
  `dte` varchar(32) NOT NULL DEFAULT '',
  `module` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sys_log
-- ----------------------------

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL COMMENT '登陆账号,与employee.code相同',
  `userpassword` varchar(32) NOT NULL DEFAULT '123456',
  `roleid` int(11) DEFAULT '1',
  `bindingip` int(11) DEFAULT '0',
  `clientip` varchar(16) DEFAULT NULL,
  `truename` varchar(32) DEFAULT NULL,
  `sex` char(4) DEFAULT '男',
  `mobile` varchar(32) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `usertag` varchar(128) DEFAULT NULL,
  `fatherid` int(11) DEFAULT '1',
  `state` char(20) DEFAULT '1900-01-01 00:00:00',
  `userarea` text COMMENT '用户有权限的区域ID集合，逗号分隔',
  PRIMARY KEY (`userid`),
  UNIQUE KEY `idx_username` (`username`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', '123456', '1', '0', '', '张三', '男', '', '', '', '0', '2017-05-22 13:10:12', '53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,78,79,80,81,82,83,84,85,86,87,88,89,90');
INSERT INTO `user` VALUES ('2', 'face', 'face', '2', '0', '', '', '男', '', '', '', '1', '2016-11-30 16:45:27', '');

-- ----------------------------
-- Table structure for `ws_base`
-- ----------------------------
DROP TABLE IF EXISTS `ws_base`;
CREATE TABLE `ws_base` (
  `gzzbh` varchar(12) NOT NULL COMMENT '工作站编号',
  `gzz_ip` varchar(64) NOT NULL COMMENT '工作站IP',
  `dz` varchar(128) DEFAULT NULL COMMENT '地址',
  `hzr` varchar(64) DEFAULT NULL COMMENT '负责人',
  `dh` varchar(32) DEFAULT NULL COMMENT '负责人电话',
  `zxzt` int(2) NOT NULL DEFAULT '1' COMMENT '在线状态,0:不在线，1：在线',
  `ztsj` datetime NOT NULL COMMENT '状态时间',
  `qyzt` int(2) NOT NULL DEFAULT '1' COMMENT '启用状态 0:未启用，1：启用',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '认证密钥 MD5',
  PRIMARY KEY (`gzzbh`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ws_base
-- ----------------------------
INSERT INTO `ws_base` VALUES ('12345', '192.168.0.222', '派出所', null, null, '1', '2017-05-24 17:52:12', '1', null);

-- ----------------------------
-- Table structure for `ws_log`
-- ----------------------------
DROP TABLE IF EXISTS `ws_log`;
CREATE TABLE `ws_log` (
  `id` int(11) NOT NULL,
  `gzzbh` varchar(12) NOT NULL COMMENT '工作站编号',
  `rzlx` int(2) NOT NULL DEFAULT '0' COMMENT '日志类型,1:开机，2：关机，3：接入记录仪，4：移除记录仪，5：采集文件，',
  `dxbh` varchar(100) DEFAULT NULL COMMENT '对象编号,执法记录仪或文件编号',
  `rzsj` datetime NOT NULL COMMENT '日志时间',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '认证密钥',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ws_log
-- ----------------------------

/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : enforce

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 936

Date: 2017-06-10 17:22:42
*/

SET FOREIGN_KEY_CHECKS=0;

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
INSERT INTO `menu` VALUES ('101', '100', '角色管理', 'Role/index', '1', 'icon-folder_user', '1');
INSERT INTO `menu` VALUES ('102', '100', '用户管理', 'User/index', '2', 'icon-status_online', '1');
INSERT INTO `menu` VALUES ('103', '100', '部门管理', 'Area/index', '3', 'icon-world', '1');
INSERT INTO `menu` VALUES ('200', '0', '设备管理', '', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('201', '200', '执法仪配置', 'Dev/pe_base_show', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('303', '300', '工作站日志', 'Log/log_show?logType=wslog', '2', null, '1');
INSERT INTO `menu` VALUES ('302', '300', '执法仪日志', 'Log/log_show?logType=pelog', '1', null, '1');
INSERT INTO `menu` VALUES ('301', '300', '系统日志', 'Log/log_show?logType=syslog', '0', null, '1');
INSERT INTO `menu` VALUES ('300', '0', '日志查询', null, '2', null, '1');
INSERT INTO `menu` VALUES ('400', '0', '统计分析', '', '3', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('401', '400', '执法仪统计', 'Dev/pe_sat', '1', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('402', '400', '工作量统计', 'Media/work_sat', '2', 'icon-user_comment', '1');
INSERT INTO `menu` VALUES ('404', '400', '考核统计', 'Media/show_sat?satType=assessmeny_sat', '3', 'icon-film_link', '1');
INSERT INTO `menu` VALUES ('500', '0', '数据管理', '', '4', 'icon-script', '1');
INSERT INTO `menu` VALUES ('502', '500', '执法查询', null, '0', null, '1');
INSERT INTO `menu` VALUES ('501', '500', '典型案例', null, '0', null, '1');
INSERT INTO `menu` VALUES ('503', '500', '执法数据录入', '', '3', 'icon-report_magnify', '1');
INSERT INTO `menu` VALUES ('403', '400', '执法统计', '', '0', 'icon-dvd_link', '1');
INSERT INTO `menu` VALUES ('202', '200', '执法仪状态', 'Dev/pe_show_status', '0', 'icon-camera', '1');
INSERT INTO `menu` VALUES ('405', '400', '异常数据统计', null, '5', null, '1');
INSERT INTO `menu` VALUES ('406', '400', '数据比对', null, '6', null, '1');
INSERT INTO `menu` VALUES ('104', '100', '警员录入', 'Employee/index', '4', 'icon-vcard', '1');
INSERT INTO `menu` VALUES ('105', '100', '警员查看', 'Employee/showEmpPhoto', '5', 'icon-picture_go', '1');
INSERT INTO `menu` VALUES ('203', '200', '工作站管理', 'WorkStation/ws_base_show', '3', null, '1');

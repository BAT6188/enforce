/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : enforce

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 936

Date: 2017-06-10 17:22:55
*/

SET FOREIGN_KEY_CHECKS=0;

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
INSERT INTO `role` VALUES ('1', '系统管理员', '拥有所有操作权限', '100,101,102,103,104,105,200,201,202,203,300,301,302,303,400,401,402,403,404,405,406,500,501,502,503', '0');
INSERT INTO `role` VALUES ('2', '普通用户', '拥有基本的操作权限', '100,101,102,103,104,105,200,201,202,203,300,301,302,303,400,401,402,403,404,405,406,500,501,502,503', '1');
INSERT INTO `role` VALUES ('4', '设备用户', '拥有用户对设备管理的权限', '100,101,102,103,104,105,200,201,202,203,300,301,302,303,400,401,402,403,404,405,406,500,501,502,503', '2');

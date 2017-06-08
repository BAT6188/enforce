/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : enforce

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 936

Date: 2017-06-08 23:00:34
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '' COMMENT '用户/警员名',
  `cmt` varchar(128) NOT NULL DEFAULT '',
  `dte` datetime NOT NULL,
  `module` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES ('1', 'admin', '(0.0.0.0)', '2017-06-08 21:00:56', null);
INSERT INTO `sys_log` VALUES ('2', 'admin', '登出(0.0.0.0)', '2017-06-08 21:01:56', null);
INSERT INTO `sys_log` VALUES ('3', 'admin', '登录(0.0.0.0)', '2017-06-08 21:02:11', null);
INSERT INTO `sys_log` VALUES ('4', 'admin', '登出(0.0.0.0)', '2017-06-08 21:03:45', null);
INSERT INTO `sys_log` VALUES ('5', 'face', '登录(0.0.0.0)', '2017-06-08 21:03:51', null);
INSERT INTO `sys_log` VALUES ('6', 'face', '登出(0.0.0.0)', '2017-06-08 21:04:08', null);
SET FOREIGN_KEY_CHECKS=1;

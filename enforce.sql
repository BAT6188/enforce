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
  `proid` int(11) DEFAULT '1' COMMENT '�ݲ��ã��̶���1',
  `fatherareaid` int(11) NOT NULL,
  `areaname` varchar(128) NOT NULL COMMENT '����(����)����',
  `areacode` varchar(64) DEFAULT '0000000000' COMMENT '�ݲ���',
  `rperson` varchar(64) DEFAULT NULL,
  `rphone` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`areaid`),
  KEY `fk_areareg_areapro_proid` (`fatherareaid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=92 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of area_dep
-- ----------------------------
INSERT INTO `area_dep` VALUES ('57', '1', '55', '�������������', '00002111', '', '');
INSERT INTO `area_dep` VALUES ('56', '1', '55', '���ƿ�', '00001111', '', '');
INSERT INTO `area_dep` VALUES ('55', '1', '54', '�ؾ����', '00000111', '', '');
INSERT INTO `area_dep` VALUES ('54', '1', '53', '��ͷ�н���֧��', '00000011', '', '');
INSERT INTO `area_dep` VALUES ('53', '1', '0', '���ɹ�������������', '00000001', '', '');
INSERT INTO `area_dep` VALUES ('58', '1', '54', '�������', '00000112', '', '');
INSERT INTO `area_dep` VALUES ('59', '1', '58', '�����ж�', '00001112', '', '');
INSERT INTO `area_dep` VALUES ('60', '1', '58', '���ܷ���', '00002112', '', '');
INSERT INTO `area_dep` VALUES ('61', '1', '58', '����һ�ж�', '00003112', '', '');
INSERT INTO `area_dep` VALUES ('62', '1', '58', '�������ж�', '00004112', '', '');
INSERT INTO `area_dep` VALUES ('63', '1', '58', '�������ж�', '00005112', '', '');
INSERT INTO `area_dep` VALUES ('64', '1', '58', '�������ж�', '00006112', '', '');
INSERT INTO `area_dep` VALUES ('65', '1', '58', '�������ж�', '00007112', '', '');
INSERT INTO `area_dep` VALUES ('66', '1', '58', '�������ж�', '00008112', '', '');
INSERT INTO `area_dep` VALUES ('67', '1', '58', '�����¹��ж�', '00009112', '', '');
INSERT INTO `area_dep` VALUES ('68', '1', '58', '�������񶽲��', '00010112', '', '');
INSERT INTO `area_dep` VALUES ('69', '1', '54', '��ɽ�����', '00000113', '', '');
INSERT INTO `area_dep` VALUES ('70', '1', '54', '���������', '00000114', '', '');
INSERT INTO `area_dep` VALUES ('71', '1', '54', '��ԭ�����', '00000115', '', '');
INSERT INTO `area_dep` VALUES ('72', '1', '54', '���´��', '00000116', '', '');
INSERT INTO `area_dep` VALUES ('73', '1', '54', '���Ҵ��', '00000117', '', '');
INSERT INTO `area_dep` VALUES ('74', '1', '54', 'ʯ�մ��', '00000118', '', '');
INSERT INTO `area_dep` VALUES ('75', '1', '54', '�������', '00000119', '', '');
INSERT INTO `area_dep` VALUES ('76', '1', '54', '��ï���', '00000120', '', '');
INSERT INTO `area_dep` VALUES ('78', '1', '54', '���˴��', '00000122', '', '');
INSERT INTO `area_dep` VALUES ('79', '1', '54', '���ƳǴ��', '00000123', '', '');
INSERT INTO `area_dep` VALUES ('80', '1', '54', '�������', '00000124', '', '');
INSERT INTO `area_dep` VALUES ('81', '1', '54', '�������', '00000125', '', '');
INSERT INTO `area_dep` VALUES ('82', '1', '54', '������', '00000126', '', '');
INSERT INTO `area_dep` VALUES ('83', '1', '54', '�������', '00000127', '', '');
INSERT INTO `area_dep` VALUES ('84', '1', '54', '������', '00000128', '', '');
INSERT INTO `area_dep` VALUES ('85', '1', '74', 'ʯ��һ�ж�', '00001128', '', '');
INSERT INTO `area_dep` VALUES ('86', '1', '74', 'ʯ�ն��ж�', '00002128', '', '');
INSERT INTO `area_dep` VALUES ('87', '1', '74', 'ʯ�����ж�', '00003128', '', '');
INSERT INTO `area_dep` VALUES ('88', '1', '74', 'ʯ�����ж�', '00004128', '', '');
INSERT INTO `area_dep` VALUES ('89', '1', '74', 'ʯ���¹��ж�', '00005128', '', '');
INSERT INTO `area_dep` VALUES ('90', '1', '74', 'ʯ�ն��취�ư�', '00006128', '', '');

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
INSERT INTO `area_pro` VALUES ('1', '����');

-- ----------------------------
-- Table structure for `employee`
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `empid` int(11) NOT NULL AUTO_INCREMENT,
  `areaid` int(11) NOT NULL DEFAULT '1' COMMENT '����(����)ID',
  `name` varchar(32) NOT NULL DEFAULT '��' COMMENT '��Ա��',
  `code` varchar(32) NOT NULL DEFAULT '��' COMMENT '��½�˺�,һ���Ǿ�Ա���,ͬʱ���user.username',
  `sex` char(4) DEFAULT '��',
  `phone` varchar(32) DEFAULT NULL,
  `email` varchar(32) DEFAULT NULL,
  `libnum` varchar(16) DEFAULT '-1',
  `remark` varchar(200) DEFAULT NULL,
  `photo_path` varchar(128) DEFAULT NULL COMMENT '��Ա��Ƭ����λ��(URL)',
  `is_police` int(2) NOT NULL DEFAULT '1' COMMENT '0:�Ǿ�Ա��1����Ա',
  `is_adm` int(2) NOT NULL DEFAULT '0' COMMENT '0:�ǣ�1���ǹ���Ա',
  PRIMARY KEY (`empid`),
  UNIQUE KEY `idx_code` (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES ('11', '88', '����', '000113', '��', '12345678901', '', '-1', '��', null, '1', '0');
INSERT INTO `employee` VALUES ('10', '88', '��һ', '000112', '��', '12345678902', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('9', '88', '������', '000111', '��', '12345678903', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('16', '88', '����', '000117', '��', '12345678907', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('13', '88', '����', '000114', '��', '12345678904', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('14', '88', '����', '000115', '��', '12345678905', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('15', '88', '����', '000116', '��', '12345678906', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('17', '88', '����', '000118', '��', '12345678908', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('18', '88', '��ǿ', '000119', '��', '12345678909', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('19', '88', '����', '000120', '��', '12345678910', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('20', '88', '��һ', '000121', '��', '12345678911', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('21', '88', '���', '000122', '��', '12345678912', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('22', '88', '����', '000123', '��', '12345678913', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('23', '88', '����', '000124', '��', '12345678914', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('24', '88', '����', '000125', '��', '12345678915', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('25', '88', '����', '000126', '��', '12345678916', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('26', '88', '����', '000127', '��', '12345678917', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('27', '88', '�ĸ�', '000128', '��', '12345678918', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('28', '88', '����', '000129', '��', '12345678919', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('29', '74', '��Ա', '123456', '��', '123456789030', '', '-1', '', null, '1', '0');
INSERT INTO `employee` VALUES ('31', '54', '�ܻ�', 'admin', '��', '', '', '-1', '', null, '0', '1');

-- ----------------------------
-- Table structure for `menu`
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `pid` int(11) DEFAULT '0' COMMENT '�˵���ID',
  `name` varchar(64) NOT NULL,
  `url` varchar(128) DEFAULT NULL,
  `ordernum` int(11) DEFAULT '0',
  `iconcls` varchar(64) DEFAULT NULL,
  `enable` int(2) DEFAULT '1' COMMENT '0:����,1:����',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES ('100', '0', 'ϵͳ����', '', '0', 'icon-wrench', '1');
INSERT INTO `menu` VALUES ('101', '100', '��ɫ����', 'Rolereg/index', '1', 'icon-folder_user', '1');
INSERT INTO `menu` VALUES ('102', '100', '�û�����', 'Userreg/index', '2', 'icon-status_online', '1');
INSERT INTO `menu` VALUES ('103', '100', '���Ź���', 'Areareg/index', '3', 'icon-world', '1');
INSERT INTO `menu` VALUES ('200', '0', '�豸����', '', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('201', '200', 'վ�����', 'Serinfo/index', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('300', '0', '��Ա����', '', '2', 'icon-group', '1');
INSERT INTO `menu` VALUES ('301', '300', '������Ϣ', 'Employee/index', '1', 'icon-vcard', '1');
INSERT INTO `menu` VALUES ('302', '300', '�ÿ͹���', '', '2', 'icon-user', '1');
INSERT INTO `menu` VALUES ('303', '300', '��Ƭ��ѯ', 'Employee/showPhoto', '3', 'icon-picture_go', '1');
INSERT INTO `menu` VALUES ('304', '300', '�׿����', 'Photolib/index', '4', 'icon-photos', '1');
INSERT INTO `menu` VALUES ('400', '0', 'ͳ�Ʒ���', '', '3', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('401', '400', '�����̲�ͳ��', '', '1', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('402', '400', '��Ա�̲�ͳ��', '', '2', 'icon-user_comment', '1');
INSERT INTO `menu` VALUES ('404', '400', 'Ѳ������ͳ��', '', '3', 'icon-film_link', '1');
INSERT INTO `menu` VALUES ('500', '0', '�ۺϲ�ѯ', '', '4', 'icon-script', '1');
INSERT INTO `menu` VALUES ('502', '500', '��Ƭ�·�', null, '0', null, '1');
INSERT INTO `menu` VALUES ('501', '500', '�����Ų�', null, '0', null, '1');
INSERT INTO `menu` VALUES ('503', '500', '���ݹ���', 'Capturerecord/index', '3', 'icon-report_magnify', '1');
INSERT INTO `menu` VALUES ('403', '400', '�û�����ͳ��', 'Mutisearch/index', '0', 'icon-dvd_link', '1');
INSERT INTO `menu` VALUES ('202', '200', 'ִ����¼��', 'Dev/index', '0', 'icon-camera', '1');
INSERT INTO `menu` VALUES ('504', '500', '���⳵��ѯ', null, '0', null, '1');
INSERT INTO `menu` VALUES ('505', '500', 'ִ����¼��ѯ', 'Recored/index', '0', null, '1');
INSERT INTO `menu` VALUES ('506', '500', '��Ա�Ų�', null, '0', null, '1');
INSERT INTO `menu` VALUES ('405', '400', '�豸ͳ��', null, '5', null, '1');
INSERT INTO `menu` VALUES ('406', '400', 'վ��ͳ��', null, '6', null, '1');
INSERT INTO `menu` VALUES ('407', '400', '����ͳ��', null, '7', null, '1');
INSERT INTO `menu` VALUES ('408', '400', '����ͳ��', null, '0', null, '1');

-- ----------------------------
-- Table structure for `pe_base`
-- ----------------------------
DROP TABLE IF EXISTS `pe_base`;
CREATE TABLE `pe_base` (
  `cpxh` varchar(7) NOT NULL COMMENT '��Ʒ(ִ����)��� 7λ',
  `jybh` varchar(6) NOT NULL COMMENT '��Ա���',
  `jyxm` varchar(32) DEFAULT NULL COMMENT '��Ա����',
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
  `cpxh` varchar(7) NOT NULL DEFAULT '0000000' COMMENT '��Ʒ(ִ����)���',
  `rzlx` int(2) NOT NULL DEFAULT '0' COMMENT '��־����,1:�ػ���2��������3�����գ�4��¼��5��¼����7������¼��0������',
  `wjmc` varchar(100) DEFAULT NULL COMMENT '�ļ�����',
  `rzsj` datetime NOT NULL COMMENT '��־ʱ��',
  `jybh` varchar(6) NOT NULL COMMENT '��Ա���',
  `gzzbh` varchar(12) NOT NULL COMMENT '����վ���',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '��֤��Կ',
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
  `wjbh` varchar(100) NOT NULL DEFAULT '0000000@209901010101010000' COMMENT '�ļ���� <�������>@<������><�ļ����>',
  `wjbm` varchar(100) DEFAULT NULL COMMENT '�ļ�����',
  `pssj` datetime NOT NULL COMMENT '����ʱ��',
  `wjdx` varchar(32) DEFAULT NULL COMMENT '�ļ���С',
  `wjlx` int(2) DEFAULT NULL COMMENT '0:δ֪,1:��Ƶ,2:��Ƶ,3:ͼƬ',
  `jyxm` varchar(60) DEFAULT NULL COMMENT '��Ա����',
  `jybh` varchar(6) NOT NULL DEFAULT '000000' COMMENT '��Ա���',
  `dwbh` varchar(12) DEFAULT NULL COMMENT '��λ���',
  `dwmc` varchar(100) DEFAULT NULL COMMENT '��λ����',
  `cpxh` varchar(7) NOT NULL DEFAULT '0000000' COMMENT '��Ʒ(ִ����)��� 7λ',
  `ccfwq_ip` varchar(64) DEFAULT NULL COMMENT '�洢������',
  `ccwz` varchar(200) DEFAULT NULL COMMENT '�洢λ��',
  `bfwz` varchar(200) NOT NULL DEFAULT 'http://' COMMENT '����λ��',
  `wlwz` varchar(200) DEFAULT NULL COMMENT '����λ��',
  `scsj` datetime NOT NULL DEFAULT '2099-01-01 00:00:00' COMMENT '�ϴ�ʱ��',
  `bzlx` int(2) DEFAULT '0' COMMENT '��ע����,0:δ��ע,1:��ע(���Ͱ���)',
  `gzzbh` varchar(12) NOT NULL DEFAULT '0' COMMENT '����վ���',
  `gzz_ip` varchar(64) NOT NULL COMMENT '����վIP',
  `mark` varchar(512) DEFAULT '��' COMMENT '��ע',
  `upload` int(2) NOT NULL DEFAULT '0' COMMENT '0:���ϴ���1���ϴ������ķ�����(��Ҫ��Ƶ)',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '��֤��Կ',
  PRIMARY KEY (`wjbh`,`jybh`),
  KEY `idx_jybh` (`jybh`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pe_video_list
-- ----------------------------
INSERT INTO `pe_video_list` VALUES ('1111111@201506250850560000', '����@201506250850560000.mp4', '2015-06-25 08:50:56', '6.5', '1', null, '123456', null, null, '1111111', '192.168.0.249', null, 'http://192.168.0.249/pe_data/1111111/20160523/mp4/1111111@201506250850560000.mp4', null, '2017-05-24 17:44:11', null, '12345', '192.168.0.222', null, '0', null);

-- ----------------------------
-- Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `roleid` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(64) NOT NULL,
  `remark` varchar(128) DEFAULT NULL,
  `functionlist` varchar(4096) DEFAULT NULL,
  `proleid` int(11) DEFAULT NULL COMMENT '��ɫ��id',
  PRIMARY KEY (`roleid`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', 'ϵͳ����Ա', 'ӵ�����в���Ȩ��', '100,101,102,103,200,201,202,300,301,302,303,304,400,401,402,403,404,405,406,407,408,500,501,502,503,504,505', '0');
INSERT INTO `role` VALUES ('2', '��ͨ�û�', 'ӵ�л����Ĳ���Ȩ��', '500,503,502,501,400,404,402,401,403,300,304,303,302,301,200,201,202,100,103,102,101', '1');
INSERT INTO `role` VALUES ('4', '�豸�û�', 'ӵ���û����豸�����Ȩ��', '500,503,502,501,303,301,202,100,103,102,101', '2');

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
  `username` varchar(32) NOT NULL COMMENT '��½�˺�,��employee.code��ͬ',
  `userpassword` varchar(32) NOT NULL DEFAULT '123456',
  `roleid` int(11) DEFAULT '1',
  `bindingip` int(11) DEFAULT '0',
  `clientip` varchar(16) DEFAULT NULL,
  `truename` varchar(32) DEFAULT NULL,
  `sex` char(4) DEFAULT '��',
  `mobile` varchar(32) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `usertag` varchar(128) DEFAULT NULL,
  `fatherid` int(11) DEFAULT '1',
  `state` char(20) DEFAULT '1900-01-01 00:00:00',
  `userarea` text COMMENT '�û���Ȩ�޵�����ID���ϣ����ŷָ�',
  PRIMARY KEY (`userid`),
  UNIQUE KEY `idx_username` (`username`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', '123456', '1', '0', '', '����', '��', '', '', '', '0', '2017-05-22 13:10:12', '53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,78,79,80,81,82,83,84,85,86,87,88,89,90');
INSERT INTO `user` VALUES ('2', 'face', 'face', '2', '0', '', '', '��', '', '', '', '1', '2016-11-30 16:45:27', '');

-- ----------------------------
-- Table structure for `ws_base`
-- ----------------------------
DROP TABLE IF EXISTS `ws_base`;
CREATE TABLE `ws_base` (
  `gzzbh` varchar(12) NOT NULL COMMENT '����վ���',
  `gzz_ip` varchar(64) NOT NULL COMMENT '����վIP',
  `dz` varchar(128) DEFAULT NULL COMMENT '��ַ',
  `hzr` varchar(64) DEFAULT NULL COMMENT '������',
  `dh` varchar(32) DEFAULT NULL COMMENT '�����˵绰',
  `zxzt` int(2) NOT NULL DEFAULT '1' COMMENT '����״̬,0:�����ߣ�1������',
  `ztsj` datetime NOT NULL COMMENT '״̬ʱ��',
  `qyzt` int(2) NOT NULL DEFAULT '1' COMMENT '����״̬ 0:δ���ã�1������',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '��֤��Կ MD5',
  PRIMARY KEY (`gzzbh`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ws_base
-- ----------------------------
INSERT INTO `ws_base` VALUES ('12345', '192.168.0.222', '�ɳ���', null, null, '1', '2017-05-24 17:52:12', '1', null);

-- ----------------------------
-- Table structure for `ws_log`
-- ----------------------------
DROP TABLE IF EXISTS `ws_log`;
CREATE TABLE `ws_log` (
  `id` int(11) NOT NULL,
  `gzzbh` varchar(12) NOT NULL COMMENT '����վ���',
  `rzlx` int(2) NOT NULL DEFAULT '0' COMMENT '��־����,1:������2���ػ���3�������¼�ǣ�4���Ƴ���¼�ǣ�5���ɼ��ļ���',
  `dxbh` varchar(100) DEFAULT NULL COMMENT '������,ִ����¼�ǻ��ļ����',
  `rzsj` datetime NOT NULL COMMENT '��־ʱ��',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '��֤��Կ',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ws_log
-- ----------------------------

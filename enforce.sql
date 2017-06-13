/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : enforce

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 936

Date: 2017-06-13 17:30:25
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
) ENGINE=MyISAM AUTO_INCREMENT=94 DEFAULT CHARSET=latin1;

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
INSERT INTO `area_dep` VALUES ('86', '1', '74', 'ʯ�ն��ж�', '00002128', '', '');
INSERT INTO `area_dep` VALUES ('87', '1', '74', 'ʯ�����ж�', '00003128', '', '');
INSERT INTO `area_dep` VALUES ('88', '1', '74', 'ʯ�����ж�', '00004128', '', '');
INSERT INTO `area_dep` VALUES ('89', '1', '74', 'ʯ���¹��ж�', '00005128', '', '');
INSERT INTO `area_dep` VALUES ('90', '1', '74', 'ʯ�ն��취�ư�', '00006128', '', '');
INSERT INTO `area_dep` VALUES ('92', '1', '80', '�������ж�', '0001254', '', '');
INSERT INTO `area_dep` VALUES ('93', '1', '80', '�������ж�', '0001254', '', '');

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
  `remark` varchar(200) DEFAULT NULL,
  `photo_path` varchar(128) DEFAULT NULL COMMENT '��Ա��Ƭ����λ��(URL)',
  `password` varchar(32) NOT NULL COMMENT '��½����',
  `roleid` int(11) NOT NULL DEFAULT '1',
  `bindingip` int(11) NOT NULL DEFAULT '0' COMMENT '0:δ��,1:��',
  `clientip` varchar(16) DEFAULT NULL,
  `userarea` text COMMENT '����Ա�Ƿǿ�.�û���Ȩ�޵�����ID���ϣ����ŷָ�',
  PRIMARY KEY (`empid`),
  UNIQUE KEY `idx_code` (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES ('11', '88', '����', '000113', '��', '12345678901', '', '��', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('10', '88', '��һ', '000112', '��', '12345678902', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('9', '88', '������', '000111', '��', '12345678903', '', '', 'upload/593f98571c45a.jpg', '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('16', '88', '����', '000117', '��', '12345678907', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('13', '88', '����', '000114', '��', '12345678904', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('14', '88', '����', '000115', '��', '12345678905', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('15', '88', '����', '000116', '��', '12345678906', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('17', '88', '����', '000118', '��', '12345678908', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('18', '88', '��ǿ', '000119', '��', '12345678909', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('19', '88', '����', '000120', '��', '12345678910', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('20', '88', '��һ', '000121', '��', '12345678911', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('21', '88', '���', '000122', '��', '12345678912', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('22', '88', '����', '000123', '��', '12345678913', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('23', '88', '����', '000124', '��', '12345678914', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('24', '88', '����', '000125', '��', '12345678915', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('25', '88', '����', '000126', '��', '12345678916', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('26', '88', '����', '000127', '��', '12345678917', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('27', '88', '�ĸ�', '000128', '��', '12345678918', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('28', '88', '����', '000129', '��', '12345678919', '', '', null, '', '1', '0', null, null);
INSERT INTO `employee` VALUES ('29', '74', '��Ա', '123456', '��', '123456789030', '', '', null, '', '1', '0', null, null);

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
INSERT INTO `menu` VALUES ('101', '100', '��ɫ����', 'Role/index', '1', 'icon-folder_user', '1');
INSERT INTO `menu` VALUES ('102', '100', '�û�����', 'User/index', '2', 'icon-status_online', '1');
INSERT INTO `menu` VALUES ('103', '100', '���Ź���', 'Area/index', '3', 'icon-world', '1');
INSERT INTO `menu` VALUES ('200', '0', '�豸����', '', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('201', '200', 'ִ��������', 'Dev/pe_base_show', '1', 'icon-tux', '1');
INSERT INTO `menu` VALUES ('303', '300', '����վ��־', 'Log/log_show?logType=wslog', '2', null, '1');
INSERT INTO `menu` VALUES ('302', '300', 'ִ������־', 'Log/log_show?logType=pelog', '1', null, '1');
INSERT INTO `menu` VALUES ('301', '300', 'ϵͳ��־', 'Log/log_show?logType=syslog', '0', null, '1');
INSERT INTO `menu` VALUES ('300', '0', '��־��ѯ', null, '2', null, '1');
INSERT INTO `menu` VALUES ('400', '0', 'ͳ�Ʒ���', '', '3', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('401', '400', 'ִ����ͳ��', 'Dev/peShowStatus', '1', 'icon-group_link', '1');
INSERT INTO `menu` VALUES ('402', '400', '������ͳ��', 'Media/show_sat?satType=work_sat', '2', 'icon-user_comment', '1');
INSERT INTO `menu` VALUES ('404', '400', '����ͳ��', 'Media/show_sat?satType=assessmeny_sat', '3', 'icon-film_link', '1');
INSERT INTO `menu` VALUES ('500', '0', '���ݹ���', '', '4', 'icon-script', '1');
INSERT INTO `menu` VALUES ('502', '500', 'ִ����ѯ', 'Media/law_query', '1', null, '1');
INSERT INTO `menu` VALUES ('501', '500', '���Ͱ���', 'Media/typical_case', '0', null, '1');
INSERT INTO `menu` VALUES ('405', '400', '�쳣����ͳ��', null, '5', null, '1');
INSERT INTO `menu` VALUES ('104', '100', '��Ա¼��', 'Employee/index', '4', 'icon-vcard', '1');
INSERT INTO `menu` VALUES ('105', '100', '��Ա�鿴', 'Employee/showEmpPhoto', '5', 'icon-picture_go', '1');
INSERT INTO `menu` VALUES ('203', '200', '����վ����', 'WorkStation/ws_base_show', '3', null, '1');

-- ----------------------------
-- Table structure for `pe_base`
-- ----------------------------
DROP TABLE IF EXISTS `pe_base`;
CREATE TABLE `pe_base` (
  `cpxh` varchar(7) NOT NULL COMMENT '��Ʒ(ִ����)��� ',
  `standard` varchar(30) DEFAULT NULL COMMENT '�豸���',
  `product` varchar(100) DEFAULT NULL COMMENT '��������',
  `jybh` varchar(6) NOT NULL COMMENT '��Ա���',
  `jyxm` varchar(32) DEFAULT NULL COMMENT '��Ա����',
  PRIMARY KEY (`cpxh`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pe_base
-- ----------------------------
INSERT INTO `pe_base` VALUES ('1111111', null, null, '123456', null);
INSERT INTO `pe_base` VALUES ('1236778', '', '�ܻ�2', '', '');
INSERT INTO `pe_base` VALUES ('132546', null, null, '000113', null);
INSERT INTO `pe_base` VALUES ('365254', null, null, '000119', null);
INSERT INTO `pe_base` VALUES ('36987', '', '�ܻ�', '000113', '����');

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
  `wjbh` varchar(100) NOT NULL DEFAULT '0' COMMENT '�ļ���� <�������>_<����>_<������ʱ����>.<����>',
  `start_time` datetime NOT NULL COMMENT '����ʱ��',
  `end_time` datetime DEFAULT NULL COMMENT '��Ƶ����ʱ��',
  `wjcd` int(11) DEFAULT '0' COMMENT '�ļ�����',
  `wjlx` int(2) DEFAULT NULL COMMENT '0:δ֪,1:��Ƶ,2:��Ƶ,3:ͼƬ',
  `jyxm` varchar(60) DEFAULT NULL COMMENT '��Ա����',
  `jybh` varchar(6) NOT NULL DEFAULT '000000' COMMENT '��Ա���',
  `areaid` int(11) NOT NULL DEFAULT '1' COMMENT '��λ���',
  `areaname` varchar(128) DEFAULT NULL COMMENT '��λ����',
  `cpxh` varchar(7) NOT NULL DEFAULT '0000000' COMMENT '��Ʒ(ִ����)��� 7λ',
  `ccfwq_ip` varchar(64) DEFAULT NULL COMMENT '�洢������',
  `ccwz` varchar(200) DEFAULT NULL COMMENT '�洢λ��',
  `bfwz` varchar(200) NOT NULL DEFAULT 'http://' COMMENT '����λ��',
  `wlwz` varchar(200) DEFAULT NULL COMMENT '����λ��',
  `scsj` datetime NOT NULL DEFAULT '2099-01-01 00:00:00' COMMENT '�ϴ�ʱ��',
  `bzlx` int(2) DEFAULT '0' COMMENT '��ע����,0:δ��ע,1:��ע(���Ͱ���)',
  `gzz_ip` varchar(64) NOT NULL COMMENT '����վIP',
  `mark` varchar(512) DEFAULT NULL COMMENT '��ע',
  `upload` int(2) NOT NULL DEFAULT '0' COMMENT '0:���ϴ���1���ϴ������ķ�����(��Ҫ��Ƶ)',
  `video_type` int(2) DEFAULT '9' COMMENT '��Ƶ����(1:�Ƽݡ�2:�¹ʡ�3:���ݡ�4:Υ����9:����)',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '��֤��Կ',
  PRIMARY KEY (`wjbh`,`jybh`),
  KEY `idx_jybh` (`jybh`) USING BTREE,
  KEY `idx_areaid` (`areaid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pe_video_list
-- ----------------------------
INSERT INTO `pe_video_list` VALUES ('1111111@2017060611210550057', '2017-06-06 11:21:05', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496748065/1111111@2017060611210550057', 'http://localhost/pe_video/data/1496748065/1111111@2017060611210550057', null, '2017-06-07 03:50:25', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060611482038650', '2017-06-06 11:48:20', '2017-06-06 11:52:29', '249', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496749700/1111111@2017060611482038650', 'http://localhost/pe_video/data/1496749700/1111111@2017060611482038650', null, '2017-06-07 05:31:10', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060612244120136', '2017-06-06 12:24:41', '2017-06-06 12:28:17', '216', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496751881/1111111@2017060612244120136', 'http://localhost/pe_video/data/1496751881/1111111@2017060612244120136', null, '2017-06-07 04:41:14', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060615102924575', '2017-06-06 15:10:29', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496761829/1111111@2017060615102924575', 'http://localhost/pe_video/data/1496761829/1111111@2017060615102924575', null, '2017-06-07 07:12:28', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060616583619333', '2017-06-06 16:58:36', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496768316/1111111@2017060616583619333', 'http://localhost/pe_video/data/1496768316/1111111@2017060616583619333', null, '2017-06-07 10:19:51', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060702282328067', '2017-06-07 02:28:23', '2017-06-07 02:33:09', '286', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496802503/1111111@2017060702282328067', 'http://localhost/pe_video/data/1496802503/1111111@2017060702282328067', null, '2017-06-07 18:37:13', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060705565624870', '2017-06-07 05:56:56', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496815016/1111111@2017060705565624870', 'http://localhost/pe_video/data/1496815016/1111111@2017060705565624870', null, '2017-06-07 22:01:00', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@201706070649215787', '2017-06-07 06:49:21', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496818161/1111111@201706070649215787', 'http://localhost/pe_video/data/1496818161/1111111@201706070649215787', null, '2017-06-08 00:21:47', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060707380646382', '2017-06-07 07:38:06', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496821086/1111111@2017060707380646382', 'http://localhost/pe_video/data/1496821086/1111111@2017060707380646382', null, '2017-06-07 23:49:17', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060710285323937', '2017-06-07 10:28:53', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496831333/1111111@2017060710285323937', 'http://localhost/pe_video/data/1496831333/1111111@2017060710285323937', null, '2017-06-08 04:17:15', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060710483934723', '2017-06-07 10:48:39', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496832519/1111111@2017060710483934723', 'http://localhost/pe_video/data/1496832519/1111111@2017060710483934723', null, '2017-06-08 03:40:55', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060711035125317', '2017-06-07 11:03:51', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496833431/1111111@2017060711035125317', 'http://localhost/pe_video/data/1496833431/1111111@2017060711035125317', null, '2017-06-08 03:24:53', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060713174335946', '2017-06-07 13:17:43', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496841463/1111111@2017060713174335946', 'http://localhost/pe_video/data/1496841463/1111111@2017060713174335946', null, '2017-06-08 07:00:33', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060714174738983', '2017-06-07 14:17:47', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496845067/1111111@2017060714174738983', 'http://localhost/pe_video/data/1496845067/1111111@2017060714174738983', null, '2017-06-08 07:11:01', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060715092341698', '2017-06-07 15:09:23', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496848163/1111111@2017060715092341698', 'http://localhost/pe_video/data/1496848163/1111111@2017060715092341698', null, '2017-06-08 08:33:12', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060717053333117', '2017-06-07 17:05:33', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496855133/1111111@2017060717053333117', 'http://localhost/pe_video/data/1496855133/1111111@2017060717053333117', null, '2017-06-08 09:47:12', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060720553931299', '2017-06-07 20:55:39', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496868939/1111111@2017060720553931299', 'http://localhost/pe_video/data/1496868939/1111111@2017060720553931299', null, '2017-06-08 14:30:24', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060805303864085', '2017-06-08 05:30:38', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496899838/1111111@2017060805303864085', 'http://localhost/pe_video/data/1496899838/1111111@2017060805303864085', null, '2017-06-08 23:05:44', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060806032150361', '2017-06-08 06:03:21', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496901801/1111111@2017060806032150361', 'http://localhost/pe_video/data/1496901801/1111111@2017060806032150361', null, '2017-06-09 00:02:52', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060810252744034', '2017-06-08 10:25:27', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496917527/1111111@2017060810252744034', 'http://localhost/pe_video/data/1496917527/1111111@2017060810252744034', null, '2017-06-09 02:31:34', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060813182840667', '2017-06-08 13:18:28', '2017-06-08 13:20:31', '123', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496927908/1111111@2017060813182840667', 'http://localhost/pe_video/data/1496927908/1111111@2017060813182840667', null, '2017-06-09 05:46:53', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@201706081425204820', '2017-06-08 14:25:20', '2017-06-08 14:28:08', '168', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496931920/1111111@201706081425204820', 'http://localhost/pe_video/data/1496931920/1111111@201706081425204820', null, '2017-06-09 07:31:19', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060816221126466', '2017-06-08 16:22:11', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496938931/1111111@2017060816221126466', 'http://localhost/pe_video/data/1496938931/1111111@2017060816221126466', null, '2017-06-09 10:05:52', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060817313739979', '2017-06-08 17:31:37', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496943097/1111111@2017060817313739979', 'http://localhost/pe_video/data/1496943097/1111111@2017060817313739979', null, '2017-06-09 11:09:48', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060818113434060', '2017-06-08 18:11:34', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496945494/1111111@2017060818113434060', 'http://localhost/pe_video/data/1496945494/1111111@2017060818113434060', null, '2017-06-09 11:08:25', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@201706081936414603', '2017-06-08 19:36:41', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496950601/1111111@201706081936414603', 'http://localhost/pe_video/data/1496950601/1111111@201706081936414603', null, '2017-06-09 12:57:18', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060820125551876', '2017-06-08 20:12:55', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496952775/1111111@2017060820125551876', 'http://localhost/pe_video/data/1496952775/1111111@2017060820125551876', null, '2017-06-09 14:00:10', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060820461117520', '2017-06-08 20:46:11', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496954771/1111111@2017060820461117520', 'http://localhost/pe_video/data/1496954771/1111111@2017060820461117520', null, '2017-06-09 13:29:43', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060821071659025', '2017-06-08 21:07:16', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496956036/1111111@2017060821071659025', 'http://localhost/pe_video/data/1496956036/1111111@2017060821071659025', null, '2017-06-09 14:39:40', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060822225959299', '2017-06-08 22:22:59', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496960579/1111111@2017060822225959299', 'http://localhost/pe_video/data/1496960579/1111111@2017060822225959299', null, '2017-06-09 15:03:39', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060823522844498', '2017-06-08 23:52:28', '2017-06-08 23:56:27', '239', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496965948/1111111@2017060823522844498', 'http://localhost/pe_video/data/1496965948/1111111@2017060823522844498', null, '2017-06-09 16:14:17', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060823525158418', '2017-06-08 23:52:51', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496965971/1111111@2017060823525158418', 'http://localhost/pe_video/data/1496965971/1111111@2017060823525158418', null, '2017-06-09 17:13:34', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060908000240869', '2017-06-09 08:00:02', '2017-06-09 08:02:05', '123', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1496995202/1111111@2017060908000240869', 'http://localhost/pe_video/data/1496995202/1111111@2017060908000240869', null, '2017-06-10 01:59:03', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060913345758707', '2017-06-09 13:34:57', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497015297/1111111@2017060913345758707', 'http://localhost/pe_video/data/1497015297/1111111@2017060913345758707', null, '2017-06-10 07:10:30', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060918531037787', '2017-06-09 18:53:10', '2017-06-09 18:57:09', '239', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497034390/1111111@2017060918531037787', 'http://localhost/pe_video/data/1497034390/1111111@2017060918531037787', null, '2017-06-10 11:56:58', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060919485060777', '2017-06-09 19:48:50', '2017-06-09 19:51:18', '148', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497037730/1111111@2017060919485060777', 'http://localhost/pe_video/data/1497037730/1111111@2017060919485060777', null, '2017-06-10 12:23:30', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060919564113515', '2017-06-09 19:56:41', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497038201/1111111@2017060919564113515', 'http://localhost/pe_video/data/1497038201/1111111@2017060919564113515', null, '2017-06-10 13:56:15', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060921171919163', '2017-06-09 21:17:19', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497043039/1111111@2017060921171919163', 'http://localhost/pe_video/data/1497043039/1111111@2017060921171919163', null, '2017-06-10 13:54:52', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017060923203034256', '2017-06-09 23:20:30', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497050430/1111111@2017060923203034256', 'http://localhost/pe_video/data/1497050430/1111111@2017060923203034256', null, '2017-06-10 16:07:56', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061004551417175', '2017-06-10 04:55:14', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497070514/1111111@2017061004551417175', 'http://localhost/pe_video/data/1497070514/1111111@2017061004551417175', null, '2017-06-10 21:54:19', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061007234836143', '2017-06-10 07:23:48', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497079428/1111111@2017061007234836143', 'http://localhost/pe_video/data/1497079428/1111111@2017061007234836143', null, '2017-06-10 23:29:58', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061014394220696', '2017-06-10 14:39:42', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497105582/1111111@2017061014394220696', 'http://localhost/pe_video/data/1497105582/1111111@2017061014394220696', null, '2017-06-11 07:13:08', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061014401528343', '2017-06-10 14:40:15', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497105615/1111111@2017061014401528343', 'http://localhost/pe_video/data/1497105615/1111111@2017061014401528343', null, '2017-06-11 06:45:20', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061015290824901', '2017-06-10 15:29:08', '2017-06-10 15:31:14', '126', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497108548/1111111@2017061015290824901', 'http://localhost/pe_video/data/1497108548/1111111@2017061015290824901', null, '2017-06-11 07:53:00', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@201706101711304158', '2017-06-10 17:11:30', '2017-06-10 17:15:47', '257', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497114690/1111111@201706101711304158', 'http://localhost/pe_video/data/1497114690/1111111@201706101711304158', null, '2017-06-11 09:42:20', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061018051032245', '2017-06-10 18:05:10', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497117910/1111111@2017061018051032245', 'http://localhost/pe_video/data/1497117910/1111111@2017061018051032245', null, '2017-06-11 11:18:33', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061019325613684', '2017-06-10 19:32:56', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497123176/1111111@2017061019325613684', 'http://localhost/pe_video/data/1497123176/1111111@2017061019325613684', null, '2017-06-11 11:39:01', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061023161223201', '2017-06-10 23:16:12', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497136572/1111111@2017061023161223201', 'http://localhost/pe_video/data/1497136572/1111111@2017061023161223201', null, '2017-06-11 16:41:03', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061100004554212', '2017-06-11 00:00:45', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497139245/1111111@2017061100004554212', 'http://localhost/pe_video/data/1497139245/1111111@2017061100004554212', null, '2017-06-11 17:33:08', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061101080453996', '2017-06-11 01:08:04', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497143284/1111111@2017061101080453996', 'http://localhost/pe_video/data/1497143284/1111111@2017061101080453996', null, '2017-06-11 17:42:17', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061102442362178', '2017-06-11 02:44:23', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497149063/1111111@2017061102442362178', 'http://localhost/pe_video/data/1497149063/1111111@2017061102442362178', null, '2017-06-11 19:19:25', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061107144148547', '2017-06-11 07:14:41', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497165281/1111111@2017061107144148547', 'http://localhost/pe_video/data/1497165281/1111111@2017061107144148547', null, '2017-06-12 00:26:03', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@201706110733386363', '2017-06-11 07:33:38', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497166418/1111111@201706110733386363', 'http://localhost/pe_video/data/1497166418/1111111@201706110733386363', null, '2017-06-12 01:03:58', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061114160135755', '2017-06-11 14:16:01', null, '0', '0', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497190561/1111111@2017061114160135755', 'http://localhost/pe_video/data/1497190561/1111111@2017061114160135755', null, '2017-06-12 06:50:12', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061120590740911', '2017-06-11 20:59:07', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497214747/1111111@2017061120590740911', 'http://localhost/pe_video/data/1497214747/1111111@2017061120590740911', null, '2017-06-12 14:44:12', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@201706112215535332', '2017-06-11 22:15:53', '2017-06-11 22:19:11', '198', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497219353/1111111@201706112215535332', 'http://localhost/pe_video/data/1497219353/1111111@201706112215535332', null, '2017-06-12 16:05:13', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061201233842439', '2017-06-12 01:23:38', '2017-06-12 01:25:42', '124', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497230618/1111111@2017061201233842439', 'http://localhost/pe_video/data/1497230618/1111111@2017061201233842439', null, '2017-06-12 17:34:19', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061202552329393', '2017-06-12 02:55:23', '2017-06-12 02:58:13', '170', '1', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497236123/1111111@2017061202552329393', 'http://localhost/pe_video/data/1497236123/1111111@2017061202552329393', null, '2017-06-12 20:44:05', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061203475038966', '2017-06-12 03:47:50', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497239270/1111111@2017061203475038966', 'http://localhost/pe_video/data/1497239270/1111111@2017061203475038966', null, '2017-06-12 19:56:15', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061204333454125', '2017-06-12 04:33:34', null, '0', '3', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497242014/1111111@2017061204333454125', 'http://localhost/pe_video/data/1497242014/1111111@2017061204333454125', null, '2017-06-12 21:07:45', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('1111111@2017061206283953996', '2017-06-12 06:28:39', null, '0', '2', '��Ա', '123456', '74', 'ʯ�մ��', '1111111', null, 'pe_video/data/1497248919/1111111@2017061206283953996', 'http://localhost/pe_video/data/1497248919/1111111@2017061206283953996', null, '2017-06-12 22:56:04', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('132546@201706081526194804', '2017-06-08 15:26:19', null, '0', '0', '����', '000113', '88', 'ʯ�����ж�', '132546', null, 'pe_video/data/1496935579/132546@201706081526194804', 'http://localhost/pe_video/data/1496935579/132546@201706081526194804', null, '2017-06-09 09:03:12', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('132546@2017060904370121263', '2017-06-09 04:37:01', null, '0', '0', '����', '000113', '88', 'ʯ�����ж�', '132546', null, 'pe_video/data/1496983021/132546@2017060904370121263', 'http://localhost/pe_video/data/1496983021/132546@2017060904370121263', null, '2017-06-09 21:09:16', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('132546@2017061023312832857', '2017-06-10 23:31:28', null, '0', '2', '����', '000113', '88', 'ʯ�����ж�', '132546', null, 'pe_video/data/1497137488/132546@2017061023312832857', 'http://localhost/pe_video/data/1497137488/132546@2017061023312832857', null, '2017-06-11 17:16:11', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('132546@2017061116025246630', '2017-06-11 16:02:52', null, '0', '3', '����', '000113', '88', 'ʯ�����ж�', '132546', null, 'pe_video/data/1497196972/132546@2017061116025246630', 'http://localhost/pe_video/data/1497196972/132546@2017061116025246630', null, '2017-06-12 09:16:07', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060610240821024', '2017-06-06 10:24:08', null, '0', '3', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496744648/365254@2017060610240821024', 'http://localhost/pe_video/data/1496744648/365254@2017060610240821024', null, '2017-06-07 03:22:31', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060611595149414', '2017-06-06 11:59:51', null, '0', '2', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496750391/365254@2017060611595149414', 'http://localhost/pe_video/data/1496750391/365254@2017060611595149414', null, '2017-06-07 05:44:47', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060618161353974', '2017-06-06 18:16:13', null, '0', '0', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496772973/365254@2017060618161353974', 'http://localhost/pe_video/data/1496772973/365254@2017060618161353974', null, '2017-06-07 12:01:38', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060618454935710', '2017-06-06 18:45:49', '2017-06-06 18:50:29', '280', '1', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496774749/365254@2017060618454935710', 'http://localhost/pe_video/data/1496774749/365254@2017060618454935710', null, '2017-06-07 11:34:45', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060709151813381', '2017-06-07 09:15:18', '2017-06-07 09:20:15', '297', '1', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496826918/365254@2017060709151813381', 'http://localhost/pe_video/data/1496826918/365254@2017060709151813381', null, '2017-06-08 01:44:23', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060800265022133', '2017-06-08 00:26:50', null, '0', '0', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496881610/365254@2017060800265022133', 'http://localhost/pe_video/data/1496881610/365254@2017060800265022133', null, '2017-06-08 16:50:13', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060814261458430', '2017-06-08 14:26:14', null, '0', '2', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496931974/365254@2017060814261458430', 'http://localhost/pe_video/data/1496931974/365254@2017060814261458430', null, '2017-06-09 08:04:35', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060901351712061', '2017-06-09 01:35:17', null, '0', '3', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1496972117/365254@2017060901351712061', 'http://localhost/pe_video/data/1496972117/365254@2017060901351712061', null, '2017-06-09 19:17:53', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@201706091352078538', '2017-06-09 13:52:07', null, '0', '3', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497016327/365254@201706091352078538', 'http://localhost/pe_video/data/1497016327/365254@201706091352078538', null, '2017-06-10 07:39:54', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060917110524752', '2017-06-09 17:11:05', null, '0', '2', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497028265/365254@2017060917110524752', 'http://localhost/pe_video/data/1497028265/365254@2017060917110524752', null, '2017-06-10 10:49:51', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017060921251662533', '2017-06-09 21:25:16', null, '0', '0', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497043516/365254@2017060921251662533', 'http://localhost/pe_video/data/1497043516/365254@2017060921251662533', null, '2017-06-10 15:15:04', '0', '192.168.0.222', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@201706100034058707', '2017-06-10 00:34:05', '2017-06-10 00:37:15', '190', '1', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497054845/365254@201706100034058707', 'http://localhost/pe_video/data/1497054845/365254@201706100034058707', null, '2017-06-10 16:54:00', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017061001423858741', '2017-06-10 01:42:38', null, '0', '2', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497058958/365254@2017061001423858741', 'http://localhost/pe_video/data/1497058958/365254@2017061001423858741', null, '2017-06-10 19:28:58', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@201706100739197310', '2017-06-10 07:39:19', null, '0', '2', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497080359/365254@201706100739197310', 'http://localhost/pe_video/data/1497080359/365254@201706100739197310', null, '2017-06-11 00:07:20', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017061015503640293', '2017-06-10 15:50:36', null, '0', '3', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497109836/365254@2017061015503640293', 'http://localhost/pe_video/data/1497109836/365254@2017061015503640293', null, '2017-06-11 09:48:27', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@201706110422405463', '2017-06-11 04:22:40', null, '0', '0', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497154960/365254@201706110422405463', 'http://localhost/pe_video/data/1497154960/365254@201706110422405463', null, '2017-06-11 21:16:19', '0', '8789786cb76', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017061115411249232', '2017-06-11 15:41:12', null, '0', '0', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497195672/365254@2017061115411249232', 'http://localhost/pe_video/data/1497195672/365254@2017061115411249232', null, '2017-06-12 08:04:40', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('365254@2017061202431016425', '2017-06-12 02:43:10', null, '0', '0', '��ǿ', '000119', '88', 'ʯ�����ж�', '365254', null, 'pe_video/data/1497235390/365254@2017061202431016425', 'http://localhost/pe_video/data/1497235390/365254@2017061202431016425', null, '2017-06-12 19:33:47', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('36987@2017060723002210971', '2017-06-07 23:00:22', null, '0', '0', '����', '000113', '88', 'ʯ�����ж�', '36987', null, 'pe_video/data/1496876422/36987@2017060723002210971', 'http://localhost/pe_video/data/1496876422/36987@2017060723002210971', null, '2017-06-08 16:40:25', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('36987@2017060812362714488', '2017-06-08 12:36:27', null, '0', '3', '����', '000113', '88', 'ʯ�����ж�', '36987', null, 'pe_video/data/1496925387/36987@2017060812362714488', 'http://localhost/pe_video/data/1496925387/36987@2017060812362714488', null, '2017-06-09 04:39:40', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('36987@2017060818251612433', '2017-06-08 18:25:16', '2017-06-08 18:29:17', '241', '1', '����', '000113', '88', 'ʯ�����ж�', '36987', null, 'pe_video/data/1496946316/36987@2017060818251612433', 'http://localhost/pe_video/data/1496946316/36987@2017060818251612433', null, '2017-06-09 12:07:47', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('36987@2017060911210631861', '2017-06-09 11:21:06', null, '0', '3', '����', '000113', '88', 'ʯ�����ж�', '36987', null, 'pe_video/data/1497007266/36987@2017060911210631861', 'http://localhost/pe_video/data/1497007266/36987@2017060911210631861', null, '2017-06-10 03:42:29', '0', '192.168.0.222', null, '1', '9', null);
INSERT INTO `pe_video_list` VALUES ('36987@2017061001452760278', '2017-06-10 01:45:27', null, '0', '0', '����', '000113', '88', 'ʯ�����ж�', '36987', null, 'pe_video/data/1497059127/36987@2017061001452760278', 'http://localhost/pe_video/data/1497059127/36987@2017061001452760278', null, '2017-06-10 19:40:17', '0', '8789786cb76', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160919053623.WAV', '2016-09-19 05:36:23', '2016-09-19 05:36:32', '9', '2', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160919/T11366_000111_20160919053623.WAV', null, '2017-06-13 10:57:10', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160919053816.JPG', '2016-09-19 05:38:16', '2016-09-19 05:38:16', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160919/T11366_000111_20160919053816.JPG', null, '2017-06-13 10:57:41', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160919053820.JPG', '2016-09-19 05:38:20', '2016-09-19 05:38:20', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160919/T11366_000111_20160919053820.JPG', null, '2017-06-13 10:58:12', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160919053834.MP4', '2016-09-19 05:38:34', '2016-09-19 05:39:30', '56', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160919/T11366_000111_20160919053834.MP4', null, '2017-06-13 11:06:42', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160919053942.JPG', '2016-09-19 05:39:42', '2016-09-19 05:39:42', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160919/T11366_000111_20160919053942.JPG', null, '2017-06-13 10:58:43', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160921081552.JPG', '2016-09-21 08:15:52', '2016-09-21 08:15:52', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160921/T11366_000111_20160921081552.JPG', null, '2017-06-13 10:59:13', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160921082745.MP4', '2016-09-21 08:27:45', '2016-09-21 08:32:44', '299', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160921/T11366_000111_20160921082745.MP4', null, '2017-06-12 16:19:04', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160921083245.MP4', '2016-09-21 08:32:45', '2016-09-21 08:34:36', '111', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160921/T11366_000111_20160921083245.MP4', null, '2017-06-13 11:01:54', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160921083436.JPG', '2016-09-21 08:34:36', '2016-09-21 08:34:36', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160921/T11366_000111_20160921083436.JPG', null, '2017-06-13 11:02:24', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160927082930.JPG', '2016-09-27 08:29:30', '2016-09-27 08:29:30', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160927/T11366_000111_20160927082930.JPG', null, '2017-06-13 11:03:05', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160927083000.MP4', '2016-09-27 08:30:00', '2016-09-27 08:33:58', '238', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160927/T11366_000111_20160927083000.MP4', null, '2017-06-13 11:04:35', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160927093235.MP4', '2016-09-27 09:32:35', '2016-09-27 09:34:02', '87', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160927/T11366_000111_20160927093235.MP4', null, '2017-06-13 11:05:27', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20160927093944.WAV', '2016-09-27 09:39:44', '2016-09-27 09:39:46', '2', '2', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20160927/T11366_000111_20160927093944.WAV', null, '2017-06-13 11:05:57', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601144452.MP4', '2017-06-01 14:44:52', '2017-06-01 14:49:52', '300', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601144452.MP4', null, '2017-06-13 11:07:33', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601144950.MP4', '2017-06-01 14:49:50', '2017-06-01 14:54:50', '300', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601144950.MP4', null, '2017-06-13 11:08:15', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601145450.MP4', '2017-06-01 14:54:50', '2017-06-01 14:59:50', '300', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601145450.MP4', null, '2017-06-13 11:08:57', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601145952.MP4', '2017-06-01 14:59:52', '2017-06-01 15:04:52', '300', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601145952.MP4', null, '2017-06-13 11:09:38', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601150450.MP4', '2017-06-01 15:04:50', '2017-06-01 15:05:02', '12', '1', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601150450.MP4', null, '2017-06-13 11:10:09', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601150508.JPG', '2017-06-01 15:05:08', '2017-06-01 15:05:08', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601150508.JPG', null, '2017-06-13 11:10:40', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601150512.JPG', '2017-06-01 15:05:12', '2017-06-01 15:05:12', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601150512.JPG', null, '2017-06-13 11:11:10', '0', '192.168.0.26', null, '0', '9', null);
INSERT INTO `pe_video_list` VALUES ('T11366_000111_20170601150520.JPG', '2017-06-01 15:05:20', '2017-06-01 15:05:20', '0', '3', '������', '000111', '88', 'ʯ�����ж�', 'T11366', '192.168.0.249', null, 'http://192.168.0.249/pe_file/pedata/T11366/20170601/T11366_000111_20170601150520.JPG', null, '2017-06-13 11:11:40', '0', '192.168.0.26', null, '0', '9', null);

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
INSERT INTO `role` VALUES ('1', 'ϵͳ����Ա', 'ӵ�����в���Ȩ��', '100,101,102,103,104,105,200,201,202,203,300,301,302,303,304,400,401,402,403,404,405,406,407,408,500,501,502,503,504,505', '0');
INSERT INTO `role` VALUES ('2', '��ͨ�û�', 'ӵ�л����Ĳ���Ȩ��', '500,503,502,501,400,404,402,401,403,300,304,303,302,301,200,201,202,100,103,102,101', '1');
INSERT INTO `role` VALUES ('4', '�豸�û�', 'ӵ���û����豸�����Ȩ��', '500,503,502,501,303,301,202,100,103,102,101', '2');

-- ----------------------------
-- Table structure for `sys_log`
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '0',
  `cmt` varchar(128) NOT NULL DEFAULT '',
  `dte` datetime NOT NULL,
  `module` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES ('1', 'admin', '��¼(0.0.0.0)', '2017-06-12 13:43:05', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('2', 'admin', '��Ӻ������ж�(0.0.0.0)', '2017-06-12 13:44:33', 'ϵͳ����/���Ź���');
INSERT INTO `sys_log` VALUES ('3', 'admin', '��Ӻ������ж�(0.0.0.0)', '2017-06-12 13:45:52', 'ϵͳ����/���Ź���');
INSERT INTO `sys_log` VALUES ('4', 'admin', 'ɾ������(0.0.0.0)', '2017-06-12 13:46:44', 'ϵͳ����/���Ź���');
INSERT INTO `sys_log` VALUES ('5', 'admin', '�ǳ�(0.0.0.0)', '2017-06-12 14:03:12', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('6', 'admin', '��¼(0.0.0.0)', '2017-06-12 14:03:19', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('7', 'admin', '�ǳ�(0.0.0.0)', '2017-06-12 14:08:24', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('8', 'admin', '��¼(0.0.0.0)', '2017-06-12 14:08:32', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('9', 'admin', '�ǳ�(0.0.0.0)', '2017-06-12 14:38:52', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('10', 'admin', '��¼(0.0.0.0)', '2017-06-12 14:38:59', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('11', 'admin', '���1236778:����(0.0.0.0)', '2017-06-12 15:22:14', '�豸����/ִ���ǹ���');
INSERT INTO `sys_log` VALUES ('12', 'admin', 'ɾ��ִ����¼��(0.0.0.0)', '2017-06-12 15:22:34', '�豸����/ִ���ǹ���');
INSERT INTO `sys_log` VALUES ('13', 'admin', '���36987:����(0.0.0.0)', '2017-06-12 15:23:16', '�豸����/ִ���ǹ���');
INSERT INTO `sys_log` VALUES ('14', 'admin', '�ǳ�(0.0.0.0)', '2017-06-12 15:40:49', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('15', 'admin', '��¼(0.0.0.0)', '2017-06-12 15:40:56', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('16', 'admin', '��¼(0.0.0.0)', '2017-06-13 09:21:12', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('17', 'admin', '��¼(0.0.0.0)', '2017-06-13 10:03:29', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('18', 'admin', '��¼(0.0.0.0)', '2017-06-13 12:05:43', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('19', 'admin', '���:1(0.0.0.0)', '2017-06-13 14:12:47', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('20', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:12:51', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('21', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:18:23', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('22', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:22:35', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('23', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:25:40', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('24', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:26:36', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('25', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:28:44', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('26', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:34:01', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('27', 'admin', 'ɾ������վ(0.0.0.0)', '2017-06-13 14:34:33', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('28', 'admin', '���:3e(0.0.0.0)', '2017-06-13 14:34:47', '�豸����/����վ����');
INSERT INTO `sys_log` VALUES ('29', 'admin', '�ǳ�(0.0.0.0)', '2017-06-13 15:22:24', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('30', 'admin', '��¼(0.0.0.0)', '2017-06-13 15:22:37', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('31', 'admin', '��¼(0.0.0.0)', '2017-06-13 16:41:58', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('32', 'admin', '��¼(0.0.0.0)', '2017-06-13 16:42:33', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('33', 'admin', '��¼(0.0.0.0)', '2017-06-13 16:46:35', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('34', 'admin', '��¼(0.0.0.0)', '2017-06-13 16:53:04', 'ƽ̨ϵͳ');
INSERT INTO `sys_log` VALUES ('35', 'admin', '��¼(0.0.0.0)', '2017-06-13 17:25:54', 'ƽ̨ϵͳ');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL COMMENT '��½�˺�,��employee.code��ͬ',
  `password` varchar(32) NOT NULL DEFAULT '123456',
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
INSERT INTO `user` VALUES ('1', 'admin', '123456', '1', '0', '', '����', '��', '', '', '', '0', '2017-06-13 17:25:54', '53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,78,79,80,81,82,83,84,86,87,88,89,90,92,93');
INSERT INTO `user` VALUES ('2', 'face', 'face', '2', '0', '', '', '��', '', '', '', '1', '2016-11-30 16:45:27', '90,89,88,87,86');
INSERT INTO `user` VALUES ('3', 'test', 'test', '4', '0', '', '', '��', '', '', '', '2', '2016-11-23 17:27:08', '');

-- ----------------------------
-- Table structure for `ws_base`
-- ----------------------------
DROP TABLE IF EXISTS `ws_base`;
CREATE TABLE `ws_base` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gzz_ip` varchar(64) NOT NULL COMMENT '����վIP',
  `dz` varchar(128) DEFAULT NULL COMMENT '��ַ',
  `hzr` varchar(64) DEFAULT NULL COMMENT '������',
  `dh` varchar(32) DEFAULT NULL COMMENT '�����˵绰',
  `zxzt` int(2) NOT NULL DEFAULT '1' COMMENT '����״̬,0:�����ߣ�1������',
  `ztsj` datetime NOT NULL COMMENT '״̬ʱ��',
  `qyzt` int(2) NOT NULL DEFAULT '1' COMMENT '����״̬ 0:δ���ã�1������',
  `auth_key` varchar(32) DEFAULT NULL COMMENT '��֤��Կ MD5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ws_base
-- ----------------------------
INSERT INTO `ws_base` VALUES ('1', '192.168.0.222', '�ɳ���', null, null, '1', '2017-05-24 17:52:12', '1', null);
INSERT INTO `ws_base` VALUES ('3', '8789786cb76', '3e', 'rr', 'ff', '1', '0000-00-00 00:00:00', '1', null);

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

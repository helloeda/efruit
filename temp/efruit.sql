-- phpMyAdmin SQL Dump
-- version 4.3.8
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2015-12-23 09:06:45
-- 服务器版本： 5.6.22
-- PHP Version: 5.5.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `efruit`
--

-- --------------------------------------------------------

--
-- 表的结构 `admin`
--

CREATE TABLE IF NOT EXISTS `admin` (
  `admin_id` char(10) NOT NULL COMMENT '管理员ID',
  `admin_password` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '管理员密码'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_password`) VALUES
('10000', '111');

-- --------------------------------------------------------

--
-- 表的结构 `admin_posts`
--

CREATE TABLE IF NOT EXISTS `admin_posts` (
  `admin_post_id` int(11) NOT NULL COMMENT '管理员帖子ID',
  `admin_id` char(20) NOT NULL COMMENT '管理员ID',
  `admin_post_time` datetime NOT NULL COMMENT '管理员发帖时间',
  `admin_post_title` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '管理员帖子标题',
  `admin_post_content` varchar(1500) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '管理员帖子内容'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `cart`
--

CREATE TABLE IF NOT EXISTS `cart` (
  `fruit_id` int(11) NOT NULL COMMENT '水果ID',
  `cart_quantity` int(11) NOT NULL COMMENT '水果数量',
  `user_id` int(11) NOT NULL COMMENT '用户ID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `fruit`
--

CREATE TABLE IF NOT EXISTS `fruit` (
  `fruit_id` int(11) NOT NULL COMMENT '水果ID',
  `fruit_name` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '水果名称',
  `fruit_image` char(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '水果图片',
  `fruit_intro` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '水果简介',
  `fruit_price` float NOT NULL COMMENT '水果单价',
  `fruit_sales_volume` int(11) NOT NULL COMMENT '水果销量',
  `fruit_is_buyable` tinyint(1) NOT NULL COMMENT '水果是否可买'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `fruit`
--

INSERT INTO `fruit` (`fruit_id`, `fruit_name`, `fruit_image`, `fruit_intro`, `fruit_price`, `fruit_sales_volume`, `fruit_is_buyable`) VALUES
(2, '南丰贡橘', 'orange', '好吃', 5.9, 32, 1);

-- --------------------------------------------------------

--
-- 表的结构 `shop`
--

CREATE TABLE IF NOT EXISTS `shop` (
  `shop_id` int(11) NOT NULL COMMENT '提货点ID',
  `shop_address` char(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '提货点地址',
  `shop_name` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '提货点名称'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `shop`
--

INSERT INTO `shop` (`shop_id`, `shop_address`, `shop_name`) VALUES
(1, '留和路288号后山', '工大屏峰提货点');

-- --------------------------------------------------------

--
-- 表的结构 `staff`
--

CREATE TABLE IF NOT EXISTS `staff` (
  `staff_id` int(11) NOT NULL COMMENT '员工ID',
  `staff_name` char(10) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '员工姓名',
  `staff_sex` char(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '员工性别',
  `staff_birthdate` date NOT NULL COMMENT '员工生日',
  `staff_password` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '员工密码',
  `staff_tel` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '员工电话',
  `shop_id` int(11) NOT NULL COMMENT '提货点ID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `staff`
--

INSERT INTO `staff` (`staff_id`, `staff_name`, `staff_sex`, `staff_birthdate`, `staff_password`, `staff_tel`, `shop_id`) VALUES
(1, '黄晓明', '男', '1979-11-11', '123456', '188888888', 1);

-- --------------------------------------------------------

--
-- 表的结构 `storage`
--

CREATE TABLE IF NOT EXISTS `storage` (
  `storage_id` int(11) NOT NULL COMMENT '仓库ID',
  `fruit_id` int(11) NOT NULL COMMENT '水果ID',
  `storage_quantity` int(11) NOT NULL COMMENT '仓库储量'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `storage_supply`
--

CREATE TABLE IF NOT EXISTS `storage_supply` (
  `shop_id` int(11) NOT NULL COMMENT '提货点ID',
  `storage_id` int(11) NOT NULL COMMENT '仓库ID',
  `supply_time` date NOT NULL COMMENT '供货时间',
  `fruit_id` int(11) NOT NULL COMMENT '水果ID',
  `supply_quantity` int(11) NOT NULL COMMENT '供货量'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `sub_order`
--

CREATE TABLE IF NOT EXISTS `sub_order` (
  `sub_order_id` int(11) NOT NULL COMMENT '子订单ID',
  `sub_oder_price` float NOT NULL COMMENT '子订单单价',
  `fruit_id` int(11) NOT NULL COMMENT '水果ID',
  `sub_oder_quantity` int(11) NOT NULL COMMENT '子订单中水果数量',
  `order_id` int(11) NOT NULL COMMENT '总订单ID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `total_order`
--

CREATE TABLE IF NOT EXISTS `total_order` (
  `order_id` int(11) NOT NULL COMMENT '总订单ID',
  `shop_id` int(11) NOT NULL COMMENT '供货点ID',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `bought_time` datetime NOT NULL COMMENT '订单生成时间',
  `order_remarks` char(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '订单备注',
  `delivery_method` tinyint(1) NOT NULL COMMENT '配送方式',
  `order_tel` int(11) NOT NULL COMMENT '订单预留电话',
  `order_address` char(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '订单预留地址',
  `order_state` char(10) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '订单状态'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `user_name` char(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户姓名',
  `user_sex` char(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户性别',
  `user_birthdate` date DEFAULT NULL,
  `user_password` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户密码',
  `user_tel` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户电话',
  `shop_id` int(11) DEFAULT NULL COMMENT '提货点ID',
  `user_icon_address` char(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户头像'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`user_id`, `user_name`, `user_sex`, `user_birthdate`, `user_password`, `user_tel`, `shop_id`, `user_icon_address`) VALUES
(1, NULL, NULL, NULL, '1', '1', NULL, NULL),
(5, NULL, NULL, NULL, '123456', '18888940620', NULL, NULL),
(12, NULL, NULL, NULL, '123456', '18969940580', NULL, NULL),
(13, NULL, NULL, NULL, '12', '13735013319', NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `user_posts`
--

CREATE TABLE IF NOT EXISTS `user_posts` (
  `user_post_id` int(11) NOT NULL COMMENT '用户帖子ID',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `user_post_time` datetime NOT NULL COMMENT '用户发帖时间',
  `user_post_title` char(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户帖子标题',
  `user_post_content` varchar(1500) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户帖子内容'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`), ADD UNIQUE KEY `admin_id` (`admin_id`);

--
-- Indexes for table `admin_posts`
--
ALTER TABLE `admin_posts`
  ADD PRIMARY KEY (`admin_post_id`), ADD UNIQUE KEY `post_id` (`admin_post_id`), ADD KEY `fk_ap_a` (`admin_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`fruit_id`,`user_id`), ADD KEY `fk_cart_user` (`user_id`);

--
-- Indexes for table `fruit`
--
ALTER TABLE `fruit`
  ADD PRIMARY KEY (`fruit_id`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`shop_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`), ADD KEY `fk_staff_shop` (`shop_id`);

--
-- Indexes for table `storage`
--
ALTER TABLE `storage`
  ADD PRIMARY KEY (`storage_id`), ADD KEY `fk_sto_fruit` (`fruit_id`);

--
-- Indexes for table `storage_supply`
--
ALTER TABLE `storage_supply`
  ADD PRIMARY KEY (`shop_id`,`storage_id`,`supply_time`,`fruit_id`), ADD KEY `fk_ss_s` (`storage_id`);

--
-- Indexes for table `sub_order`
--
ALTER TABLE `sub_order`
  ADD PRIMARY KEY (`sub_order_id`), ADD KEY `fk_so_fruit` (`fruit_id`), ADD KEY `fk_so_o` (`order_id`);

--
-- Indexes for table `total_order`
--
ALTER TABLE `total_order`
  ADD PRIMARY KEY (`order_id`), ADD KEY `fk_order_shop` (`shop_id`), ADD KEY `fk_order_user` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`), ADD UNIQUE KEY `user_tel` (`user_tel`), ADD UNIQUE KEY `user_name` (`user_name`), ADD KEY `fk_user_shop` (`shop_id`);

--
-- 限制导出的表
--

--
-- 限制表 `admin_posts`
--
ALTER TABLE `admin_posts`
ADD CONSTRAINT `fk_ap_a` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

--
-- 限制表 `cart`
--
ALTER TABLE `cart`
ADD CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- 限制表 `staff`
--
ALTER TABLE `staff`
ADD CONSTRAINT `fk_staff_shop` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`);

--
-- 限制表 `storage`
--
ALTER TABLE `storage`
ADD CONSTRAINT `fk_sto_fruit` FOREIGN KEY (`fruit_id`) REFERENCES `fruit` (`fruit_id`);

--
-- 限制表 `storage_supply`
--
ALTER TABLE `storage_supply`
ADD CONSTRAINT `fk_ss_s` FOREIGN KEY (`storage_id`) REFERENCES `storage` (`storage_id`),
ADD CONSTRAINT `fk_ss_shop` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`);

--
-- 限制表 `sub_order`
--
ALTER TABLE `sub_order`
ADD CONSTRAINT `fk_so_fruit` FOREIGN KEY (`fruit_id`) REFERENCES `fruit` (`fruit_id`),
ADD CONSTRAINT `fk_so_o` FOREIGN KEY (`order_id`) REFERENCES `total_order` (`order_id`);

--
-- 限制表 `total_order`
--
ALTER TABLE `total_order`
ADD CONSTRAINT `fk_order_shop` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`),
ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- 限制表 `user`
--
ALTER TABLE `user`
ADD CONSTRAINT `fk_user_shop` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

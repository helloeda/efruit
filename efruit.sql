-- phpMyAdmin SQL Dump
-- version 4.3.8
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2015-12-30 08:24:18
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
(1, '陕西山楂', 'http://127.0.0.1/image/fruit/fruit_1.jpg', '山楂为蔷薇科植物山楂、山里红或野山楂的果实，味酸、甘，性微温。开胃消食、化滞消积、活血散瘀、化痰行气。用于肉食滞积、症瘕积聚、腹胀痞满、瘀阻腹痛、痰饮、泄泻、肠风下血等。小枝幼时无毛，二年生枝深褐色。', 12.8, 12, 1),
(2, '南丰贡橘', 'http://127.0.0.1/image/fruit/fruit_2.jpg', '南丰贡桔（别称贡桔、南丰蜜桔、蜜桔、南丰桔）是我国柑桔中的优良品种，同时也是江西省的名贵特产。历史上就以果色金黄、皮薄肉嫩、食不存渣、风味浓甜、芳香扑鼻而闻名中外。据《禹贡》记载，早在两千多年以前，南丰蜜桔已被列为贡品。唐宋八大家之一的曾巩，曾写诗赞美家乡的柑桔：“鲜明百数见秋实，错缀众叶倾霜柯。翠羽流苏出天仗，黄金戏球相荡摩。入苞岂数桔柚贱，宅鼎始足盐梅和。江湖苦遭俗眼慢，禁御尚觉凡木多。谁能出口献天子，一致大树凌沧波。”当时蜜桔已能献给天子，故南丰蜜桔又有“贡桔”的美誉，曾被斯大林同志誉为“桔中之王”。', 5.9, 32, 1),
(3, '甘肃蛇果', 'http://127.0.0.1/image/fruit/fruit_3.jpg', '果实大，呈圆锥形，果肉富有光泽，十分鲜艳夺目', 4.5, 20, 1),
(4, '源东蜜桔', 'http://127.0.0.1/image/fruit/fruit_4.jpg', '香味浓厚入口即化', 7.8, 25, 1),
(5, '珍珠芭乐', 'http://127.0.0.1/image/fruit/fruit_5.jpg', '是台湾芭乐为桃金娘科番石榴属果树，肉质非常柔软，肉汁丰富，味道甜美，几乎无籽，风味接近于梨和台湾大青枣之间。它的果实椭圆形，颜色乳青至乳白，极其漂亮，含有大量的钾、铁、胡萝卜素等，营养极其丰富。芭乐是台湾的土生水果之一，还是一等一的减肥水果。', 6.7, 30, 1),
(6, '牛奶草莓', 'http://127.0.0.1/image/fruit/fruit_6.jpg', '草莓（学名：Fragaria × ananassa Duch，英文：Strawberry）。蔷薇科、草莓属多年生草本，一种红色的花果，又名红莓、洋莓、地莓等，外观呈心形，鲜美红嫩，果肉多汁，含有特殊的浓郁水果芳香。', 7.5, 35, 1),
(7, '脆皮金橘', 'http://127.0.0.1/image/fruit/fruit_7.jpg', '橘子有好几种品种，它的果实外皮肥厚，由汁泡和种子构成。橘子属热带作物，主要种植于中国南方，橘子不仅色彩鲜艳而且酸甜可口，是常见的美味。橘子富含丰富的维生素c，对人体有着很大的好处。', 8.5, 40, 1),
(8, '人参果', 'http://127.0.0.1/image/fruit/fruit_8.jpg', '人参果（Ginseng fruit）又名长寿果、凤果、艳果，原产美洲，属茄科类多年生双子叶草本植物。亦可称仙果、香艳梨、艳果。果实成熟时果皮呈金黄色，外形似人的心脏。其果肉味道独特、脆爽多汁、不酸不涩，和酸角一样，是一种受欢迎的水果。', 6.8, 26, 1),
(9, '陕西山楂', 'http://127.0.0.1/image/fruit/fruit_9.jpg', '核果类水果，核质硬，果肉薄，味微酸涩。果可生吃或作果脯果糕，干制后可入药，是中国特有的药果兼用树种，具有降血脂、血压、强心、抗心律不齐等作用，同时也是健脾开胃、消食化滞、活血化痰的良药，对胸膈脾满、疝气、血淤、闭经等症有很好的疗效。山楂内的黄酮类化合物牡荆素，是一种抗癌作用较强的药物，其提取物对抑制体内癌细胞生长、增殖和浸润转移均有一定的作用。', 7.6, 50, 1),
(10, '越南火龙果', 'http://127.0.0.1/image/fruit/fruit_10.jpg', '火龙果营养丰富、功能独特，它含有一般植物少有的植物性白蛋白以及花青素，丰富的维生素和水溶性膳食纤维。火龙果属于凉性水果，在自然状态下，果实于夏秋成熟，味甜，多汁。', 5.9, 37, 1),
(11, '水晶石榴', 'http://127.0.0.1/image/fruit/fruit_1.jpg', '石榴中含有丰富的石榴酸等多种有机酸。能促进消化和吸收，增加食欲等功效。石榴皮含有石榴皮碱。具有涩肠止泻、生津止渴等功效！而且能麻醉人体内的寄生虫。起到驱虫杀虫止痢的作用，', 6.8, 50, 1),
(12, '泰国甜角', 'http://127.0.0.1/image/fruit/fruit_12.jpg', '果实褐色、味甜，类似干桂圆的味道，猫哆哩的原料。甜角果肉富含钙、磷、铁等多种元素，其中含钙量在所有水果中居首位。', 15, 10, 1),
(13, '圣女果', 'http://127.0.0.1/image/fruit/fruit_13.jpg', '具有生津止渴、健胃消食、清热解毒、凉血平肝，补血养血和增进食欲的功效。可治口渴，食欲不振。', 5.5, 55, 1),
(14, '有机白柚', 'http://127.0.0.1/image/fruit/fruit_14.jpg', '柚子含有丰富的蛋白质、有机酸、维生素C以及钙、磷、镁、钠等微量元素。经常食用，对败血病、糖尿病、脑血管等疾病有良好的辅助治疗作用。', 12, 45, 1),
(15, '猕猴金果', 'http://127.0.0.1/image/fruit/fruit_15.jpg', '质地柔软，口感酸甜。味道被描述为草莓、香蕉、菠萝三者的混合。猕猴桃除含有猕猴桃碱、蛋白水解酶、单宁果胶和糖类等有机物，以及钙、钾、硒、锌、锗等微量元素和人体所需17种氨基酸外，还含有丰富的维生素C、葡萄酸、果糖、柠檬酸、苹果酸、脂肪。', 12.8, 60, 1);

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
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `fruit_id` int(11) NOT NULL COMMENT '水果ID',
  `sub_order_price` float NOT NULL COMMENT '子订单单价',
  `sub_order_quantity` int(11) NOT NULL COMMENT '子订单中水果数量'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `sub_order`
--

INSERT INTO `sub_order` (`sub_order_id`, `user_id`, `fruit_id`, `sub_order_price`, `sub_order_quantity`) VALUES
(1, 11, 1, 12.8, 2),
(2, 11, 3, 4.5, 2),
(3, 11, 6, 7.5, 2),
(4, 11, 6, 7.5, 2),
(5, 11, 7, 8.5, 2),
(6, 11, 3, 4.5, 1),
(7, 11, 4, 7.8, 2),
(8, 11, 3, 4.5, 2),
(9, 11, 4, 7.8, 3),
(10, 11, 3, 4.5, 2),
(11, 11, 4, 7.8, 2),
(12, 11, 8, 6.8, 2),
(13, 11, 1, 12.8, 2),
(14, 11, 4, 7.8, 2),
(15, 11, 9, 7.6, 2);

-- --------------------------------------------------------

--
-- 表的结构 `total_order`
--

CREATE TABLE IF NOT EXISTS `total_order` (
  `order_id` int(11) NOT NULL COMMENT '总订单ID',
  `shop_id` int(11) NOT NULL COMMENT '供货点ID',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `bought_time` datetime DEFAULT NULL COMMENT '订单生成时间',
  `order_remarks` char(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '订单备注',
  `delivery_method` tinyint(1) NOT NULL DEFAULT '0' COMMENT '配送方式',
  `order_address` char(50) CHARACTER SET utf8 NOT NULL COMMENT '订单预留地址',
  `order_state` char(10) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '订单状态',
  `sub_order_id` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '子订单ID串'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `total_order`
--

INSERT INTO `total_order` (`order_id`, `shop_id`, `user_id`, `bought_time`, `order_remarks`, `delivery_method`, `order_address`, `order_state`, `sub_order_id`) VALUES
(1, 1, 11, '2015-12-30 13:35:39', '无', 0, '浙工大提货点', '0', '[6,7]'),
(2, 1, 11, '2015-12-30 13:37:36', '无', 0, '浙工大提货点', '0', '[8,9]'),
(3, 1, 11, '2015-12-30 16:19:58', '无', 0, '浙工大提货点', '0', '[10,11,12]'),
(4, 1, 11, '2015-12-30 16:21:18', '无', 0, '浙工大提货点', '0', '[13,14,15]');

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
(1, '王益挺', '男', '1994-06-20', '940620', '18888940620', 1, 'http://127.0.0.1/image/icon/user_1.png'),
(11, '王一打', '男', '1994-06-20', '1', '1', 1, 'http://127.0.0.1/image/icon/user_1.png'),
(12, NULL, NULL, NULL, '123456', '18969940580', NULL, NULL),
(13, NULL, NULL, NULL, '12', '13735013319', NULL, NULL),
(14, NULL, NULL, NULL, '2', '2', NULL, NULL);

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

-- --------------------------------------------------------

--
-- 替换视图以便查看 `view_order`
--
CREATE TABLE IF NOT EXISTS `view_order` (
`fruit_name` char(20)
,`fruit_image` char(50)
,`sub_order_id` int(11)
,`fruit_id` int(11)
,`sub_order_price` float
,`sub_order_quantity` int(11)
);

-- --------------------------------------------------------

--
-- 视图结构 `view_order`
--
DROP TABLE IF EXISTS `view_order`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_order` AS select `fruit`.`fruit_name` AS `fruit_name`,`fruit`.`fruit_image` AS `fruit_image`,`sub_order`.`sub_order_id` AS `sub_order_id`,`sub_order`.`fruit_id` AS `fruit_id`,`sub_order`.`sub_order_price` AS `sub_order_price`,`sub_order`.`sub_order_quantity` AS `sub_order_quantity` from (`fruit` join `sub_order`) where (`sub_order`.`fruit_id` = `fruit`.`fruit_id`);

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
  ADD PRIMARY KEY (`sub_order_id`), ADD KEY `fk_so_fruit` (`fruit_id`), ADD KEY `fk_so_user` (`user_id`);

--
-- Indexes for table `total_order`
--
ALTER TABLE `total_order`
  ADD PRIMARY KEY (`order_id`), ADD KEY `fk_order_shop` (`shop_id`), ADD KEY `fk_order_user` (`user_id`), ADD KEY `fk_order_so` (`sub_order_id`);

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
ADD CONSTRAINT `fk_so_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

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

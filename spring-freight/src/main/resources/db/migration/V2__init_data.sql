INSERT INTO `freight`.`sy_user`(`id`, `username`, `password`, `mobile`, `email`, `nickname`, `real_name`, `avatar`, `work_no`, `gender`, `birth_day`, `enable`, `locked`, `login_at`, `login_ip`, `expire_at`, `create_at`, `national`, `identity_card`, `identity_card_no`) VALUES (1265829314040346666, 'admin', '$2a$10$kNUhHY7c.IBnYxGvEaBqeuMDAdhUvzX5OZZliqPTtpJX3RYpt/tYy', '18713888898', 'zexliu@icloud.com', 'zex', '刘泽', 'http://192.168.31.79:8080/files/2020-07-08/02cd4f2b-b141-4595-a8bd-5cee6a099ef9.jpeg', '1', 1, '1990-04-07', 1, 0, NULL, NULL, NULL, '2020-05-28 10:02:52', '汉', 'http://192.168.31.79:8080/files/2020-07-08/0a1c871c-179a-4f89-ab25-4b9d8cb7121f.jpeg', '130221199004073411');


INSERT INTO `sy_role` VALUES (1265829314040348888,'管理员','ADMIN','系统管理员',0,'2020-05-28 10:02:52');
INSERT INTO `sy_role`(`id`, `role_name`, `role_code`, `description`, `seq`, `create_at`) VALUES (1278600509777190913, '货主', 'SHIPPER', '', 0, '2020-07-02 16:04:51');
INSERT INTO `sy_role`(`id`, `role_name`, `role_code`, `description`, `seq`, `create_at`) VALUES (1278600509777190914, '司机', 'DRIVER', '', 0, '2020-07-02 16:04:51');

INSERT INTO `freight`.`sy_user_role_rel`(`id`, `user_id`, `role_id`) VALUES (1265829314040349999, 1265829314040346666, 1265829314040348888);
# INSERT INTO `freight`.`sy_user_role_rel`(`id`, `user_id`, `role_id`) VALUES (1280823381895589889, 1265829314040346666, 1278600509777190913);
# INSERT INTO `freight`.`sy_user_role_rel`(`id`, `user_id`, `role_id`) VALUES (1280823381895589890, 1265829314040346666, 1278600509777190914);
#
#
# INSERT INTO `freight`.`fo_driver_extension`(`id`, `user_id`, `car_long`, `car_model`, `create_at`, `nature`) VALUES (1, 1265829314040346666, '1.8', '半挂', '2020-08-13 14:09:22', '私人');
#
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267613035315785729, '仪表盘', 'dashboard', 'bxAnaalyse', '/dashboard', NULL, '', '/dashboard/workspace', 'RouteView', 9999, '2020-06-02 08:24:33', 1);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267615579739959298, '工作台', 'WorkSpace', '', '/dashboard/workspace', 1267613035315785729, '', '', 'workSpace', 9999, '2020-06-02 08:34:40', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267615997123538945, '系统管理', 'System', 'setting', '/system', NULL, '', '', 'PageView', 8888, '2020-06-02 08:36:19', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267616400892407810, '用户管理', 'UserManage', '', '/system/user', 1267615997123538945, '', '', 'systemUser', 9999, '2020-06-02 08:37:55', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267616680786702337, '角色管理', 'RoleManage', '', '/system/role', 1267615997123538945, '', '', 'systemRole', 7777, '2020-06-02 08:39:02', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267616921988542465, '部门管理', 'DeptManage', '', '/system/dept', 1267615997123538945, '', '', 'systemDept', 8888, '2020-06-02 08:40:00', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267617169876103170, '权限管理', 'PermissionManage', '', '/system/permission', 1267615997123538945, '', '', 'systemPermission', 6666, '2020-06-02 08:40:59', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267617373954158593, '菜单管理', 'MenuManage', '', '/system/menu', 1267615997123538945, '', '', 'systemMenu', 5555, '2020-06-02 08:41:47', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267751023211372546, '异常页', 'Exception', 'warning', '/exception', NULL, '', '/exception/403', 'RouteView', 0, '2020-06-02 17:32:52', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267751338962771969, '403', '403', '', '/exception/403', 1267751023211372546, '', '', 'exception403', 3, '2020-06-02 17:34:07', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267751475692888066, '404', '404', '', '/exception/404', 1267751023211372546, '', '', 'exception404', 2, '2020-06-02 17:34:40', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267751581037027329, '500', '500', '', '/exception/500', 1267751023211372546, '', '', 'exception500', 1, '2020-06-02 17:35:05', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1267752705852891138, '字典管理', 'Dict', '', '/system/dict', 1267615997123538945, '', '', 'systemDict', 4444, '2020-06-02 17:39:33', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1279224237789315074, '配置管理', 'Config', 'control', '/config', NULL, '', '/config/category', 'PageView', 1111, '2020-07-04 09:23:19', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1279224479553191938, '分类管理', 'Categroy', '', '/config/category', 1279224237789315074, '', '', 'category', 9999, '2020-07-04 09:24:17', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1296752251534516225, '公告管理', 'Announcement', '', '/config/announcement', 1279224237789315074, '', '', 'announcement', 8888, '2020-08-21 18:13:23', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1308357693100425218, '审核管理', 'Audit', 'audit', '/audit', NULL, '', '/audit/index', 'PageView', 7777, '2020-09-22 18:49:16', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1308358089399238657, '货主认证', 'MasterAuthentication', '', '/audit/master', 1308357693100425218, '', '', 'masterAuthentication', 0, '2020-09-22 18:50:51', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1308358547777945601, '司机认证 ', 'DriverAuthentication', '', '/audit/driver', 1308357693100425218, '', '', 'driverAuthentication', 0, '2020-09-22 18:52:40', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1318735959464235010, '订单管理', 'Order', 'unordered-list', '/order', NULL, '', '', 'PageView', 6666, '2020-10-21 10:08:48', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1318736799633657858, '支付对账单', 'PayOrder', '', '/order/pay', 1318735959464235010, '', '', 'payOrder', 8888, '2020-10-21 10:12:08', 0);
INSERT INTO `freight`.`sy_menu`(`id`, `menu_name`, `menu_code`, `menu_icon`, `menu_path`, `parent_id`, `description`, `redirect`, `component`, `seq`, `create_at`, `hidden`) VALUES (1318737030790139906, '订单列表', 'DeliveryOrder', '', '/order/delivery', 1318735959464235010, '', '', 'deliveryOrder', 9999, '2020-10-21 10:13:03', 0);



INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317642784769, 1265829314040348888, 1267613035315785729);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317651173378, 1265829314040348888, 1267615579739959298);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317651173379, 1265829314040348888, 1267615997123538945);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317651173380, 1265829314040348888, 1267616400892407810);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317655367683, 1265829314040348888, 1267616680786702337);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317655367682, 1265829314040348888, 1267616921988542465);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317659561985, 1265829314040348888, 1267617169876103170);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317659561986, 1265829314040348888, 1267617373954158593);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317659561988, 1265829314040348888, 1267751023211372546);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317659561989, 1265829314040348888, 1267751338962771969);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317663756289, 1265829314040348888, 1267751475692888066);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317663756290, 1265829314040348888, 1267751581037027329);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317659561987, 1265829314040348888, 1267752705852891138);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317663756291, 1265829314040348888, 1279224237789315074);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317663756292, 1265829314040348888, 1279224479553191938);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317663756293, 1265829314040348888, 1296752251534516225);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317667950594, 1265829314040348888, 1308357693100425218);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317667950596, 1265829314040348888, 1308358089399238657);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317667950595, 1265829314040348888, 1308358547777945601);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317672144898, 1265829314040348888, 1318735959464235010);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317672144900, 1265829314040348888, 1318736799633657858);
INSERT INTO `freight`.`sy_role_menu_rel`(`id`, `role_id`, `menu_id`) VALUES (1318737317672144899, 1265829314040348888, 1318737030790139906);
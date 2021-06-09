CREATE TABLE `am_audit_history`  (
  `id` bigint(11) NOT NULL,
  `target_id` bigint(11) NULL,
  `target_type` tinyint(4) NULL,
  `snapshot` text NULL,
  `status` tinyint(4) NULL,
  `message` varchar(200) NULL,
  `operator_id` bigint(11) NULL,
  `operator_ip` varchar(100) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `app_version`  (
  `id` bigint(11) NOT NULL,
  `device_type` tinyint(4) NULL,
  `type` tinyint(4) NULL,
  `version_code` int(11) NULL,
  `version_name` varchar(10) NULL,
  `content` varchar(200) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `is_force` tinyint(1) NULL,
  `download_url` varchar(200) NULL,
  `sha256checksum` varchar(128) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_announcement`  (
  `id` bigint(11) NOT NULL,
  `title` varchar(30) NULL COMMENT '标题',
  `cover_image` varchar(200) NULL,
  `content` text NULL COMMENT '内容',
  `valid_start_at` datetime NULL COMMENT '有效开始时间',
  `valid_end_at` datetime NULL COMMENT '有效结束时间',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `params` varchar(200) NULL COMMENT '参数',
  `announcement_type` tinyint(4) NULL,
  `valid_status` tinyint(1) NULL DEFAULT 1 COMMENT '有效状态',
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_call`  (
  `id` bigint(11) NOT NULL,
  `from_user_id` bigint(11) NULL,
  `to_user_id` bigint(11) NULL,
  `goods_id` bigint(11) NULL,
  `type` tinyint(1) NULL,
  `status` tinyint(1) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_category`  (
  `id` bigint(11) NOT NULL,
  `category_name` varchar(32) NULL,
  `category_code` varchar(32) NULL COMMENT '分类编码',
  `parent_id` bigint(11) NULL COMMENT '父级ID',
  `description` varchar(200) NULL COMMENT '描述',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `seq` int(11) NULL COMMENT '排序',
  `is_hot` tinyint(1) NULL DEFAULT 0 COMMENT '是否热门',
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_deliver_goods`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `load_province_code` varchar(30) NULL,
  `load_city_code` varchar(30) NULL,
  `load_district_code` varchar(30) NULL,
  `load_address` varchar(200) NULL,
  `load_way_province_code` varchar(30) NULL,
  `load_way_city_code` varchar(30) NULL,
  `load_way_district_code` varchar(30) NULL,
  `load_way_address` varchar(200) NULL,
  `unload_province_code` varchar(30) NULL,
  `unload_city_code` varchar(30) NULL,
  `unload_district_code` varchar(30) NULL,
  `unload_address` varchar(200) NULL,
  `unload_way_province_code` varchar(30) NULL,
  `unload_way_city_code` varchar(30) NULL,
  `unload_way_district_code` varchar(30) NULL,
  `unload_way_address` varchar(200) NULL,
  `category_name` varchar(30) NULL,
  `weight` varchar(30) NULL,
  `volume` varchar(30) NULL,
  `car_type` varchar(30) NULL,
  `car_longs` varchar(128) NULL,
  `car_place_long` double(10, 2) NULL,
  `car_models` varchar(128) NULL,
  `load_unload` varchar(30) NULL,
  `load_start_at` datetime NULL,
  `load_end_at` datetime NULL,
  `remark` varchar(200) NULL,
  `require_List` varchar(200) NULL,
  `expect_money` decimal(10, 2) NULL,
  `expect_unit` varchar(30) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) NULL DEFAULT 1,
  `delete_status` tinyint(1) NULL DEFAULT 0,
  `mark_status` tinyint(1) NULL DEFAULT 0,
  `load_lat` double(10, 7) NULL,
  `load_lon` double(10, 7) NULL,
  `load_way_lat` double(10, 7) NULL,
  `load_way_lon` double(10, 7) NULL,
  `unload_lat` double(10, 7) NULL,
  `unload_lon` double(10, 7) NULL,
  `unload_way_lat` double(10, 7) NULL,
  `unload_way_lon` double(10, 7) NULL,
  `package_mode` varchar(32) NULL,
  PRIMARY KEY (`id`)
) COMMENT = '发货信息';

CREATE TABLE `fo_delivery_extension`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `nature` varchar(32) NULL COMMENT '发货性质',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `business_license` varchar(200) NULL,
  `audit_status` tinyint(4) NULL,
  `identity_card` varchar(200) NULL,
  `identity_card_backend` varchar(200) NULL,
  `identity_card_take` varchar(200) NULL,
  `avatar` varchar(200) NULL,
  `real_name` varchar(30) NULL,
  `shop_group_photo` varchar(200) NULL,
  `company_name` varchar(128) NULL,
  PRIMARY KEY (`id`)
) COMMENT = '用户发货 拓展信息';

CREATE TABLE `fo_dict_relation`  (
  `id` bigint(11) NOT NULL,
  `relation_id` bigint(11) NULL,
  `dict_entry_value` varchar(32) NULL,
  `dict_code` varchar(32) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_driver_extension`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `car_long` varchar(32) NULL,
  `car_model` varchar(30) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `nature` varchar(32) NULL,
  `car_no` varchar(200) NULL COMMENT '车牌号',
  `vehicle_license` varchar(200) NULL COMMENT '行驶证',
  `vehicle_license_backend` varchar(200) NULL COMMENT '行驶证反面',
  `audit_status` tinyint(4) NULL,
  `identity_card` varchar(200) NULL,
  `identity_card_backend` varchar(200) NULL,
  `identity_card_take` varchar(200) NULL,
  `avatar` varchar(200) NULL,
  `real_name` varchar(30) NULL,
  `driver_license` varchar(200) NULL,
  `driver_license_backend` varchar(200) NULL,
  `car_group_photo` varchar(200) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_evaluation`  (
  `id` bigint(11) NOT NULL,
  `order_id` bigint(11) NULL,
  `tags` varchar(200) NULL,
  `description` varchar(200) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `anonymous` tinyint(1) NULL,
  `user_id` bigint(11) NULL,
  `target_id` bigint(11) NULL,
  `type` tinyint(4) NULL,
  `level` tinyint(4) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_feedback`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `content` varchar(200) NULL,
  `images` text NULL,
  `type` varchar(200) NULL,
  `status` tinyint(4) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_look`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `goods_id` bigint(11) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_often_line`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `load_areas` varchar(30) NULL,
  `unload_areas` varchar(30) NULL,
  `car_longs` varchar(128) NULL,
  `car_models` varchar(128) NULL,
  `status` tinyint(1) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_order`  (
  `id` bigint(11) NOT NULL,
  `delivery_id` bigint(11) NULL,
  `user_id` bigint(11) NULL,
  `driver_id` bigint(11) NULL,
  `amount` decimal(10, 2) NULL COMMENT '订金',
  `freight_amount` decimal(10, 2) NULL COMMENT '运费',
  `confirm_status` tinyint(1) NULL DEFAULT 0,
  `transport_status` tinyint(4) NULL DEFAULT 0,
  `pay_status` tinyint(1) NULL DEFAULT 0,
  `evaluate_status` tinyint(1) NULL DEFAULT 0,
  `driver_evaluate_status` tinyint(1) NULL DEFAULT 0,
  `driver_pay_status` tinyint(1) NULL DEFAULT 0,
  `cancel_status` tinyint(1) NULL DEFAULT 0,
  `refund_status` tinyint(1) NULL DEFAULT 0,
  `protocol_status` tinyint(4) NULL DEFAULT 0 COMMENT '协议状态',
  `description` varchar(200) NULL,
  `master_pay_amount` double(10, 2) NULL DEFAULT 0 COMMENT '货主支付的金额',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_order_process`  (
  `id` bigint(11) NOT NULL,
  `type` tinyint(4) NULL,
  `create_at` datetime NULL,
  `snapshot` text NULL,
  `order_id` bigint(11) NULL,
  `user_id` bigint(11) NULL,
  `user_type` tinyint(4) NULL,
  `description` varchar(200) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_protocol`  (
  `id` bigint(11) NOT NULL,
  `order_id` bigint(11) NULL,
  `amount` double(10, 2) NULL,
  `freight_amount` double(10, 2) NULL,
  `pay_days` int(11) NULL,
  `load_start_at` datetime NULL,
  `load_end_at` datetime NULL,
  `unload_start_at` datetime NULL,
  `unload_end_at` datetime NULL,
  `load_province_code` varchar(30) NULL,
  `load_city_code` varchar(30) NULL,
  `load_district_code` varchar(30) NULL,
  `unload_province_code` varchar(30) NULL,
  `unload_city_code` varchar(30) NULL,
  `unload_district_code` varchar(30) NULL,
  `load_address` varchar(200) NULL,
  `unload_address` varchar(200) NULL,
  `category_name` varchar(30) NULL,
  `car_type` varchar(30) NULL,
  `car_longs` varchar(128) NULL,
  `car_models` varchar(128) NULL,
  `weight` varchar(30) NULL,
  `volume` varchar(30) NULL,
  `plate_number` varchar(30) NULL,
  `driver_agree` tinyint(1) NULL DEFAULT 0,
  `user_agree` tinyint(1) NULL DEFAULT 0,
  `create_at` datetime NULL,
  `supplement` varchar(200) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fo_transaction`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NULL,
  `target_id` bigint(11) NULL,
  `type` tinyint(4) NULL,
  `amount` double(10, 2) NULL,
  `incr_status` tinyint(1) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `pay_order`  (
  `id` bigint(11) NOT NULL,
  `order_type` tinyint(4) NULL,
  `pay_at` datetime NULL,
  `user_id` bigint(11) NULL,
  `amount` decimal(10, 2) NULL,
  `channel_type` varchar(30) NULL,
  `status` tinyint(4) NULL DEFAULT 0,
  `subject` varchar(30) NULL,
  `body` varchar(200) NULL,
  `ip_address` varchar(30) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `expire_at` datetime NULL,
  `third_party_id` varchar(128) NULL,
  `fo_order_id` bigint(11) NULL,
  `fo_delivery_id` bigint(11) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `refund_order`  (
  `id` bigint(11) NOT NULL,
  `order_id` bigint(11) NULL,
  `status` tinyint(1) NULL,
  `user_id` bigint(11) NULL,
  `amount` decimal(10, 2) NULL,
  `description` varchar(200) NULL,
  `third_party_id` varchar(128) NULL,
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `channel_type` varchar(30) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `sy_dept`  (
  `id` bigint(11) NOT NULL,
  `dept_name` varchar(32) NULL COMMENT '部门名称',
  `dept_code` varchar(32) NULL COMMENT '部门编码',
  `parent_id` bigint(11) NULL COMMENT '所属部门',
  `address` varchar(200) NULL COMMENT '部门地址',
  `fax` varchar(32) NULL COMMENT '传真',
  `phone` varchar(32) NULL COMMENT '电话',
  `description` varchar(200) NULL COMMENT '描述',
  `seq` int(11) NULL COMMENT '排序',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) COMMENT = '部门表';

CREATE TABLE `sy_dept_role_rel`  (
  `id` bigint(11) NOT NULL,
  `dept_id` bigint(11) NOT NULL COMMENT '部门ID',
  `role_id` bigint(11) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_dept_id_role_id`(`dept_id`, `role_id`) USING HASH
) COMMENT = '部门角色关系表';

CREATE TABLE `sy_dict`  (
  `id` bigint(11) NOT NULL,
  `dict_name` varchar(32) NULL COMMENT '字典名称',
  `dict_code` varchar(32) NULL COMMENT '字典编码',
  `description` varchar(200) NULL COMMENT '描述',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_dict_name`(`dict_name`) USING BTREE,
  UNIQUE INDEX `uk_dict_code`(`dict_code`) USING BTREE
) COMMENT = '数据字典';

CREATE TABLE `sy_dict_entry`  (
  `id` bigint(11) NOT NULL,
  `dict_code` varchar(32) NULL COMMENT '字典编码',
  `dict_entry_name` varchar(32) NULL COMMENT '字典项名称',
  `dict_entry_value` varchar(32) NULL COMMENT '字典项值',
  `description` varchar(200) NULL COMMENT '描述',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '可用状态',
  `seq` int(11) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`)
) COMMENT = '字典项';

CREATE TABLE `sy_menu`  (
  `id` bigint(11) NOT NULL,
  `menu_name` varchar(32) NULL COMMENT '菜单名称',
  `menu_code` varchar(32) NULL COMMENT '菜单编码',
  `menu_icon` varchar(128) NULL COMMENT '菜单图标',
  `menu_path` varchar(200) NULL COMMENT '页面路径',
  `parent_id` bigint(11) NULL COMMENT '所属菜单',
  `description` varchar(200) NULL COMMENT '描述',
  `redirect` varchar(200) NULL COMMENT '重定向',
  `component` varchar(200) NULL COMMENT '组件',
  `seq` int(11) NULL DEFAULT 0 COMMENT '排序',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否隐藏',
  PRIMARY KEY (`id`)
) COMMENT = '菜单表';

CREATE TABLE `sy_permission`  (
  `id` bigint(11) NOT NULL,
  `permission_name` varchar(32) NULL COMMENT '权限名称',
  `permission_code` varchar(32) NULL COMMENT '权限编码',
  `permission_path` varchar(200) NULL COMMENT '权限路径',
  `seq` int(11) NULL DEFAULT 0 COMMENT '排序',
  `description` varchar(200) NULL COMMENT '描述',
  `parent_id` bigint(11) NULL COMMENT '所属权限',
  `method_type` tinyint(4) NULL COMMENT '方法类型',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_permission_code`(`permission_code`) USING BTREE
) COMMENT = '权限表';

CREATE TABLE `sy_role`  (
  `id` bigint(11) NOT NULL,
  `role_name` varchar(32) NULL COMMENT '角色名称',
  `role_code` varchar(32) NULL COMMENT '角色编码',
  `description` varchar(200) NULL COMMENT '描述',
  `seq` int(11) NULL DEFAULT 0 COMMENT '排序',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_role_name`(`role_name`) USING BTREE,
  UNIQUE INDEX `uk_role_code`(`role_code`) USING BTREE
) COMMENT = '角色表';

CREATE TABLE `sy_role_menu_rel`  (
  `id` bigint(11) NOT NULL,
  `role_id` bigint(11) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(11) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_role_id_menu_id`(`role_id`, `menu_id`) USING HASH
) COMMENT = '角色菜单关联关系';

CREATE TABLE `sy_role_permission_rel`  (
  `id` bigint(11) NOT NULL,
  `role_id` bigint(11) NOT NULL COMMENT '角色ID',
  `permission_id` bigint(11) NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_role_id_permission_id`(`role_id`, `permission_id`) USING HASH
) COMMENT = '角色权限关联关系';

CREATE TABLE `sy_user`  (
  `id` bigint(11) NOT NULL,
  `username` varchar(32) NULL COMMENT '用户名',
  `password` varchar(128) NULL COMMENT '密码',
  `mobile` varchar(32) NULL COMMENT '手机号',
  `email` varchar(128) NULL COMMENT '邮箱',
  `nickname` varchar(32) NULL COMMENT '昵称',
  `real_name` varchar(16) NULL COMMENT '真实姓名',
  `avatar` varchar(255) NULL COMMENT '头像',
  `work_no` varchar(32) NULL COMMENT '工号',
  `gender` tinyint(4) NULL DEFAULT 0 COMMENT '性别',
  `birth_day` date NULL COMMENT '生日',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '可用状态',
  `locked` tinyint(1) NULL DEFAULT 0 COMMENT '删除状态',
  `login_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后登录时间',
  `login_ip` varchar(32) NULL COMMENT '最后登录IP',
  `expire_at` datetime NULL COMMENT '过期时间',
  `create_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `national` varchar(32) NULL COMMENT '民族',
  `identity_card` varchar(200) NULL COMMENT '身份证图片',
  `identity_card_no` varchar(32) NULL COMMENT '身份证号',
  `driver_push_id` varchar(32) NULL,
  `driver_client_id` varchar(32) NULL,
  `master_push_id` varchar(32) NULL,
  `master_client_id` varchar(32) NULL,
  `authentication_avatar` varchar(200) NULL,
  `identity_card_backend` varchar(200) NULL COMMENT '身份证反面',
  `identity_card_take` varchar(200) NULL COMMENT '手持身份证照片',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_username`(`username`) USING BTREE,
  UNIQUE INDEX `uk_mobile`(`mobile`) USING BTREE,
  UNIQUE INDEX `uk_email`(`email`) USING BTREE,
  UNIQUE INDEX `uk_identity_card_no`(`identity_card_no`) USING HASH
) COMMENT = '用户表';

CREATE TABLE `sy_user_dept_rel`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NOT NULL COMMENT '用户ID',
  `dept_id` bigint(11) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_user_id_dept_id`(`user_id`, `dept_id`) USING HASH
) COMMENT = '用户部门关系表';

CREATE TABLE `sy_user_role_rel`  (
  `id` bigint(11) NOT NULL,
  `user_id` bigint(11) NOT NULL COMMENT '用户ID',
  `role_id` bigint(11) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_user_id_role_id`(`user_id`, `role_id`) USING HASH
) COMMENT = '用户角色关系表';

ALTER TABLE `fo_call` ADD CONSTRAINT `fk_fo_call_fo_deliver_goods_1` FOREIGN KEY (`goods_id`) REFERENCES `fo_deliver_goods` (`id`);
ALTER TABLE `fo_delivery_extension` ADD CONSTRAINT `fk_fo_delivery_extension_sy_user_1` FOREIGN KEY (`user_id`) REFERENCES `sy_user` (`id`);
ALTER TABLE `fo_driver_extension` ADD CONSTRAINT `fk_fo_driver_extension_sy_user_1` FOREIGN KEY (`user_id`) REFERENCES `sy_user` (`id`);
ALTER TABLE `fo_look` ADD CONSTRAINT `fk_fo_look_fo_deliver_goods_1` FOREIGN KEY (`goods_id`) REFERENCES `fo_deliver_goods` (`id`);
ALTER TABLE `fo_order_process` ADD CONSTRAINT `fk_fo_order_process_fo_order_1` FOREIGN KEY (`order_id`) REFERENCES `fo_order` (`id`);
ALTER TABLE `fo_protocol` ADD CONSTRAINT `fk_fo_protocol_fo_order_1` FOREIGN KEY (`order_id`) REFERENCES `fo_order` (`id`);
ALTER TABLE `fo_transaction` ADD CONSTRAINT `fk_fo_transaction_sy_user_1` FOREIGN KEY (`user_id`) REFERENCES `sy_user` (`id`);
ALTER TABLE `pay_order` ADD CONSTRAINT `fk_pay_order_fo_order_1` FOREIGN KEY (`fo_order_id`) REFERENCES `fo_order` (`id`);
ALTER TABLE `pay_order` ADD CONSTRAINT `fk_pay_order_fo_deliver_goods_1` FOREIGN KEY (`fo_delivery_id`) REFERENCES `fo_deliver_goods` (`id`);
ALTER TABLE `refund_order` ADD CONSTRAINT `fk_refund_order_pay_order_1` FOREIGN KEY (`order_id`) REFERENCES `pay_order` (`id`);
ALTER TABLE `sy_dept` ADD CONSTRAINT `fk_sy_dept_sy_dept_1` FOREIGN KEY (`parent_id`) REFERENCES `sy_dept` (`id`);
ALTER TABLE `sy_dept_role_rel` ADD CONSTRAINT `fk_sy_dept_role_rel_sy_dept_1` FOREIGN KEY (`dept_id`) REFERENCES `sy_dept` (`id`);
ALTER TABLE `sy_dept_role_rel` ADD CONSTRAINT `fk_sy_dept_role_rel_sy_role_1` FOREIGN KEY (`role_id`) REFERENCES `sy_role` (`id`);
ALTER TABLE `sy_dict_entry` ADD CONSTRAINT `fk_sy_dict_entry_sy_dict_1` FOREIGN KEY (`dict_code`) REFERENCES `sy_dict` (`dict_code`);
ALTER TABLE `sy_menu` ADD CONSTRAINT `fk_sy_menu_sy_menu_1` FOREIGN KEY (`parent_id`) REFERENCES `sy_menu` (`id`);
ALTER TABLE `sy_permission` ADD CONSTRAINT `fk_sy_permission_sy_permission_1` FOREIGN KEY (`parent_id`) REFERENCES `sy_permission` (`id`);
ALTER TABLE `sy_role_menu_rel` ADD CONSTRAINT `fk_sy_role_menu_rel_sy_role_1` FOREIGN KEY (`role_id`) REFERENCES `sy_role` (`id`);
ALTER TABLE `sy_role_menu_rel` ADD CONSTRAINT `fk_sy_role_menu_rel_sy_menu_1` FOREIGN KEY (`menu_id`) REFERENCES `sy_menu` (`id`);
ALTER TABLE `sy_role_permission_rel` ADD CONSTRAINT `fk_sy_role_permission_rel_sy_permission_1` FOREIGN KEY (`permission_id`) REFERENCES `sy_permission` (`id`);
ALTER TABLE `sy_role_permission_rel` ADD CONSTRAINT `fk_sy_role_permission_rel_sy_role_1` FOREIGN KEY (`role_id`) REFERENCES `sy_role` (`id`);
ALTER TABLE `sy_user_dept_rel` ADD CONSTRAINT `fk_sy_user_dept_rel_sy_user_1` FOREIGN KEY (`user_id`) REFERENCES `sy_user` (`id`);
ALTER TABLE `sy_user_dept_rel` ADD CONSTRAINT `fk_sy_user_dept_rel_sy_dept_1` FOREIGN KEY (`dept_id`) REFERENCES `sy_dept` (`id`);
ALTER TABLE `sy_user_role_rel` ADD CONSTRAINT `fk_sy_user_role_rel_sy_user_1` FOREIGN KEY (`user_id`) REFERENCES `sy_user` (`id`);
ALTER TABLE `sy_user_role_rel` ADD CONSTRAINT `fk_sy_user_role_rel_sy_role_1` FOREIGN KEY (`role_id`) REFERENCES `sy_role` (`id`);


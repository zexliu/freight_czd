import 'package:flutterdriver/model/user_entity.dart';

userEntityFromJson(UserEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['email'] != null) {
		data.email = json['email']?.toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname']?.toString();
	}
	if (json['realName'] != null) {
		data.realName = json['realName']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['workNo'] != null) {
		data.workNo = json['workNo']?.toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender']?.toString();
	}
	if (json['birthDay'] != null) {
		data.birthDay = json['birthDay']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['enable'] != null) {
		data.enable = json['enable'];
	}
	if (json['locked'] != null) {
		data.locked = json['locked'];
	}
	if (json['national'] != null) {
		data.national = json['national']?.toString();
	}
	if (json['identityCard'] != null) {
		data.identityCard = json['identityCard']?.toString();
	}
	if (json['identityCardNo'] != null) {
		data.identityCardNo = json['identityCardNo']?.toString();
	}
	if (json['authenticationAvatar'] != null) {
		data.authenticationAvatar = json['authenticationAvatar']?.toString();
	}
	if (json['roles'] != null) {
		data.roles = new List<UserRole>();
		(json['roles'] as List).forEach((v) {
			data.roles.add(new UserRole().fromJson(v));
		});
	}
	if (json['enabled'] != null) {
		data.enabled = json['enabled'];
	}
	if (json['accountNonExpired'] != null) {
		data.accountNonExpired = json['accountNonExpired'];
	}
	if (json['accountNonLocked'] != null) {
		data.accountNonLocked = json['accountNonLocked'];
	}
	if (json['credentialsNonExpired'] != null) {
		data.credentialsNonExpired = json['credentialsNonExpired'];
	}
	return data;
}

Map<String, dynamic> userEntityToJson(UserEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['username'] = entity.username;
	data['mobile'] = entity.mobile;
	data['email'] = entity.email;
	data['nickname'] = entity.nickname;
	data['realName'] = entity.realName;
	data['avatar'] = entity.avatar;
	data['workNo'] = entity.workNo;
	data['gender'] = entity.gender;
	data['birthDay'] = entity.birthDay;
	data['createAt'] = entity.createAt;
	data['enable'] = entity.enable;
	data['locked'] = entity.locked;
	data['national'] = entity.national;
	data['identityCard'] = entity.identityCard;
	data['identityCardNo'] = entity.identityCardNo;
	data['authenticationAvatar'] = entity.authenticationAvatar;
	if (entity.roles != null) {
		data['roles'] =  entity.roles.map((v) => v.toJson()).toList();
	}
	data['enabled'] = entity.enabled;
	data['accountNonExpired'] = entity.accountNonExpired;
	data['accountNonLocked'] = entity.accountNonLocked;
	data['credentialsNonExpired'] = entity.credentialsNonExpired;
	return data;
}

userRoleFromJson(UserRole data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['roleName'] != null) {
		data.roleName = json['roleName']?.toString();
	}
	if (json['roleCode'] != null) {
		data.roleCode = json['roleCode']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['description'] != null) {
		data.description = json['description']?.toString();
	}
	if (json['seq'] != null) {
		data.seq = json['seq']?.toInt();
	}
	if (json['permissions'] != null) {
		data.permissions = new List<dynamic>();
		data.permissions.addAll(json['permissions']);
	}
	return data;
}

Map<String, dynamic> userRoleToJson(UserRole entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['roleName'] = entity.roleName;
	data['roleCode'] = entity.roleCode;
	data['createAt'] = entity.createAt;
	data['description'] = entity.description;
	data['seq'] = entity.seq;
	if (entity.permissions != null) {
		data['permissions'] =  [];
	}
	return data;
}
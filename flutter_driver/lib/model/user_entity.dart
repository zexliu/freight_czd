import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class UserEntity with JsonConvert<UserEntity> {
	String id;
	String username;
	String mobile;
	String email;
	String nickname;
	String realName;
	String avatar;
	String workNo;
	String gender;
	String birthDay;
	int createAt;
	bool enable;
	bool locked;
	String national;
	String identityCard;
	String identityCardNo;
	String authenticationAvatar;
	List<UserRole> roles;
	bool enabled;
	bool accountNonExpired;
	bool accountNonLocked;
	bool credentialsNonExpired;
}

class UserRole with JsonConvert<UserRole> {
	String id;
	String roleName;
	String roleCode;
	int createAt;
	String description;
	int seq;
	List<dynamic> permissions;
}

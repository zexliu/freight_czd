import 'dart:async';

import 'package:flutter/services.dart';

class BaiduFacePlugin {
  static const MethodChannel _channel =
      const MethodChannel('wiki.zex.baidu_face_plugin');

  //identityCard

  Future<IdentityResult> identity({language = 'zh'}) async {
    var arguments = Map();
    arguments['language'] = language;
    final Map<dynamic, dynamic> map =
        await _channel.invokeMethod('identityCard', arguments);
    return map != null ? new IdentityResult.fromMap(map) : null;
  }

  Future<IdentityResult> localIdentity({language = 'zh'}) async {
    var arguments = Map();
    arguments['language'] = language;
    final Map<dynamic, dynamic> map =
        await _channel.invokeMethod('localIdentityCard', arguments);
    return map != null ? new IdentityResult.fromMap(map) : null;
  }

  Future<LivenessResult> liveness({language = 'zh'}) async {
    var arguments = Map();
    arguments['language'] = language;
    final Map<dynamic, dynamic> map =
        await _channel.invokeMethod('liveness', arguments);
    return map != null ? new LivenessResult.fromMap(map) : null;
  }

  Future<DetectResult> detect({language = 'zh'}) async {
    var arguments = Map();
    arguments['language'] = language;
    final Map<dynamic, dynamic> map =
        await _channel.invokeMethod('detect', arguments);
    return map != null ? new DetectResult.fromMap(map) : null;
  }
}

class IdentityResult {
  IdentityResult(
      {this.success,
      this.image,
      this.name,
      this.birthDay,
      this.identityCardNo,
      this.gender,
      this.address,
      this.national});

  factory IdentityResult.fromMap(Map<dynamic, dynamic> map) =>
      new IdentityResult(
        success: map['success'],
        image: map['image'],
        name: map['name'],
        birthDay: map['birthDay'],
        identityCardNo: map['identityCardNo'],
        gender: map['gender'],
        address: map['address'],
        national: map['national'],
      );

  final String success;
  final String birthDay;
  final String identityCardNo;
  final String gender;
  final String address;
  final String national;

  // success=true
  final String image;

  final String name;

  @override
  String toString() =>
      'IdentityResult: $success \n 姓名 = $name \n 身份证 = $identityCardNo \n 性别 = $gender \n 地址 = $address, \n 民族 = $national';
}

class LivenessResult {
  LivenessResult({this.success, this.image});

  factory LivenessResult.fromMap(Map<dynamic, dynamic> map) =>
      new LivenessResult(
        success: map['success'],
        image: map['image'],
      );

  final String success;

  // success=true
  final String image;

  @override
  String toString() => 'LivenessResult: $success,$image';
}

class DetectResult {
  DetectResult({this.success, this.image});

  factory DetectResult.fromMap(Map<dynamic, dynamic> map) => new DetectResult(
        success: map['success'],
        image: map['image'],
      );
  final String success;

  // success=true
  final String image;

  @override
  String toString() => 'DetectResult: $success,$image';
}

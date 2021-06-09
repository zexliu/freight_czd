import 'package:package_info/package_info.dart';

class PackageInfoUtils {
  static String appName = "";

  static PackageInfo _packageInfo;

  static getAppName() async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
    }
    return _packageInfo.appName;
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freightowner/pages/announcement_details_page.dart';
import 'package:freightowner/utils/phone_utils.dart';
import 'package:freightowner/utils/shared_preferences.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global.dart';
import 'login.dart';
import 'mobile_captcha_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _currentVersion = "";
  String _cacheSize = "0.0K";

  @override
  void initState() {
    super.initState();
    _getVersion();
    _loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "设置",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                ListTile(
                  title: Text("修改手机号"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return MobileCaptchaPage();
                    }));
                  },
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  title: Text("关于我们"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return AnnouncementDetailsPage("7");
                    }));
                  },
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  title: Text("客服电话"),
                  trailing: Icon(Icons.phone),
                  onTap: () {
                    launch("tel://4008061995");
                  },
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  title: Text("清除缓存"),
                  trailing: Text(_cacheSize),
                  onTap: (){
                    showCupertinoDialog(context: context, builder: (c){
                      return new CupertinoAlertDialog(
                        content: new Text("确定清理缓存吗?"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              _clearCache();
                              setState(() {
                                _cacheSize = "0.00B";
                              });
                              Navigator.of(context).pop();
                            },
                            child: new Text("确认",style: TextStyle(color: Theme.of(context).primaryColor),),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: new Text("取消"),
                          ),
                        ],
                      );
                    });
                  },
                ),

                Divider(
                  height: 1,
                ),
                ListTile(
                  title: Text("当前版本"),
                  trailing: Text("V$_currentVersion"),
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: MaterialButton(
                height: 44,
                onPressed: () async {
                  DefaultSharedPreferences.getInstance().remove("ACCESS_TOKEN");
                  DefaultSharedPreferences.getInstance()
                      .remove("REFRESH_TOKEN");
                  Global.userEntity = null;
                  await MobpushPlugin.deleteAlias();
                  await MobpushPlugin.bindPhoneNum("");
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return LoginPage();
                  }),((route)=> false));
                },
                child: Text("退出登录"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _currentVersion = packageInfo.version;
    });
  }

  Future<void> _loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    print('临时目录大小: ' + value.toString());
    setState(() {
      _cacheSize = _renderSize(value);  // _cacheSizeStr用来存储大小的值
    });


  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }


  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    print("删除缓存");
    await delDir(tempDir);
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }

    await file.delete();
    print("删除文件成功 ${file.path}");
  }



}

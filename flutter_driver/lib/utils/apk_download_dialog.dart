import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterdriver/model/app_version_entity.dart';
import 'package:ota_update/ota_update.dart';

class AppDownloadDialog extends StatefulWidget {
  final AppVersionEntity appVersion;

  AppDownloadDialog(this.appVersion);

  @override
  _AppDownloadDialogState createState() => _AppDownloadDialogState();
}

class _AppDownloadDialogState extends State<AppDownloadDialog> {
  int _value = 0;
  String _status = "请稍等...";

  @override
  void initState() {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        widget.appVersion.downloadUrl,
        // OPTIONAL
        destinationFilename: 'driver.apk',
        //OPTIONAL, ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        sha256checksum: widget.appVersion.sha256checksum,
      )
          .listen(
            (OtaEvent event) {
          setState(() {
            this._value = int.parse(event.value);
            switch (event.status){
              case OtaStatus.DOWNLOADING:
                _status = "下载中...";
                break;
              case OtaStatus.INSTALLING:
                _status = "正在安装";
                break;
              case OtaStatus.ALREADY_RUNNING_ERROR:
                _status = "运行失败";
                break;
              case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                _status = "没有权限";
                break;
              case OtaStatus.INTERNAL_ERROR:
                _status = "内部错误";
                break;
              case OtaStatus.DOWNLOAD_ERROR:
                _status = "下载失败";
                break;
              case OtaStatus.CHECKSUM_ERROR:
                _status = "文件效验失败";
                break;
            }

          });
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(
                  value: _value.toDouble()  / 100,
                  backgroundColor: Colors.grey.shade400,
                ),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: new Text(
                    _status,
                    style: new TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: EdgeInsets.all(16),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       LinearProgressIndicator(
    //         value:  _value.toDouble() / 100,
    //       ),
    //       SizedBox(height: 8,),
    //       Text("$_value%"),
    //     ],
    //   ),
    // );
  }
}

import 'package:flutter/material.dart';
import 'package:freightowner/plugin/baidu_face_plugin.dart';

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Text("打开liveness"),
                  onPressed: () {
                    _liveness();
                  }),
              RaisedButton(
                  child: Text("打开detect"),
                  onPressed: () {
                    _detect();
                  }),

              RaisedButton(
                  child: Text("打开Identity"),
                  onPressed: () {
                    _identity();
                  }),
              RaisedButton(
                  child: Text("打开Identity"),
                  onPressed: () {
                    _localIdentity();
                  }),
            ],
          )),
    );
  }

  _liveness() async {
    LivenessResult result = await new BaiduFacePlugin().liveness();

    print('LivenessResult: $result');

    // setState
  }

  _detect() async {
    DetectResult result = await new BaiduFacePlugin().detect();

    print('DetectResult: $result');

    // setState
  }
  _identity() async {
    IdentityResult result = await new BaiduFacePlugin().identity();

    print('IdentityResult: $result');

    // setState
  }
  _localIdentity() async {
    IdentityResult result = await new BaiduFacePlugin().localIdentity();

    print('IdentityResult: $result');

    // setState
  }
}

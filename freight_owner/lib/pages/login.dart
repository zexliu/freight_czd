import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/generated/json/base/json_convert_content.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/token_entity.dart';
import 'package:freightowner/pages/announcement_details_page.dart';
import 'package:freightowner/pages/home.dart';
import 'package:freightowner/utils/shared_preferences.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/announcement_dialog.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

import '../global.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  FocusNode _usernameNode = FocusNode();
  FocusNode _captchaNode = FocusNode();
  bool _buttonDisabled = false;
  int _countDown = 60;
  Timer _timer;
  bool _loginButtonDisable = false;
  String _appName = "车真多货主";

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _usernameNode),
      KeyboardActionsItem(focusNode: _captchaNode),
    ]);
  }

  @override
  void initState() {
    Timer(Duration(seconds: 1), () => _checkDialog());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardActions(
            config: _buildConfig(context),
            child: Stack(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: 64.0),
                        Image.asset('images/logo.png'),
                        SizedBox(height: 16.0),
                        Text(
                          _appName,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(height: 64.0),
                        TextField(
                          focusNode: _usernameNode,
                          maxLines: 1,
                          maxLength: 11,
                          controller: _usernameController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          //设置键盘为可录入小数的数字
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey),
                            labelStyle:
                                TextStyle(color: Colors.black54, fontSize: 14),
                            contentPadding: EdgeInsets.all(6.0),
                            labelText: '请输入手机号',
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Stack(
                          children: <Widget>[
                            TextField(
                              focusNode: _captchaNode,
                              controller: _captchaController,
                              maxLines: 1,
                              maxLength: 6,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false),
                              //设置键盘为可录入小数的数字
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.all(6.0),
                                labelStyle: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                                labelText: '请输入验证码',
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: MaterialButton(
                                child: Text(
                                    _buttonDisabled
                                        ? "$_countDown秒后重新获取"
                                        : "获取验证码",
                                    style: TextStyle(
                                        color: _buttonDisabled
                                            ? Colors.black38
                                            : Colors.black54,
                                        fontSize: 14)),
                                onPressed:
                                    _buttonDisabled ? null : _onCaptchaPress,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 32.0),
                        //确认按钮
                        MaterialButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "同意协议并注册/登录",
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () => {
                            this._loginButtonDisable ? null : _onLoginPress()
                          },
                          minWidth: double.infinity,
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                              text: "首次登录自动注册",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black38),
                              children: [
                                TextSpan(
                                  text: _appName.substring(
                                      0, _appName.length - 3),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                TextSpan(
                                    text: "账号",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black38)),
                                TextSpan(
                                    text: "且已阅读并同意",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black38)),
                                TextSpan(
                                  text: "《用户服务协议》",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (c) {
                                        return AnnouncementDetailsPage("1");
                                      }));
                                    },
                                ),
                                TextSpan(
                                  text: "《隐私政策》",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (c) {
                                        return AnnouncementDetailsPage("2");
                                      }));
                                    },
                                ),
                                TextSpan(
                                  text: "《用户授权协议》",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (c) {
                                        return AnnouncementDetailsPage("3");
                                      }));
                                    },
                                ),
                              ]),
                        )
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
//                      GestureDetector(
//                        child: Text(
//                          "联系客服",
//                          style: TextStyle(fontSize: 12),
//                        ),
//                        onTap: () => {print("点击了联系客服")},
//                      ),
//                      Container(
//                        height: 20,
//                        child: VerticalDivider(color: Colors.grey),
//                        padding: EdgeInsets.all(0),
//                      ),
                      GestureDetector(
                        child: Text(
                          "使用帮助",
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (c) {
                            return AnnouncementDetailsPage("4");
                          }))
                        },
                      ),
//                      Container(
//                          height: 20,
//                          child: VerticalDivider(color: Colors.grey)),
//                      GestureDetector(
//                        child: Text(
//                          "修改手机号",
//                          style: TextStyle(
//                              fontSize: 12,
//                              color: Theme.of(context).primaryColor),
//                        ),
//                        onTap: () => {print("点击了修改手机号")},
//                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  _onCaptchaPress() async {
    if (_usernameController.text.length != 11) {
      Toast.show("请输入正确的手机号码");
      return;
    }
    this._buttonDisabled = true;
    showLoadingDialog();
    HttpManager.getInstance().post("/api/v1/captcha/code/LOGIN",
        params: {"mobile": _usernameController.text}).then((value) {
      Toast.show("获取验证码成功");
      _captchaNode.requestFocus();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_countDown == 0) {
            _buttonDisabled = false;
            _timer.cancel();
          } else {
            _countDown--;
          }
        });
      });
      setState(() {
        _countDown = 60;
      });
    }).catchError((error) {
      hideLoadingDialog();
      this._buttonDisabled = false;
      Toast.show(error.message);
    }).whenComplete(() => hideLoadingDialog());
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  _onLoginPress() async {
    setState(() {
      this._loginButtonDisable = true;
    });
    showLoadingDialog();
    HttpManager.getInstance()
        .post("/oauth/token", params: {
          "mobile": this._usernameController.text,
          "captcha": this._captchaController.text,
          "grant_type": "captcha"
        })
        .then((value) async {
          TokenEntity tokenEntity = JsonConvert.fromJsonAsT(value);
          DefaultSharedPreferences.getInstance()
              .put("ACCESS_TOKEN", tokenEntity.accessToken);
          DefaultSharedPreferences.getInstance()
              .put("REFRESH_TOKEN", tokenEntity.refreshToken);
          var userInfo =
              await HttpManager.getInstance().get("/api/v1/users/self");
          Global.userEntity = JsonConvert.fromJsonAsT(userInfo);
          MobpushPlugin.setAlias(Global.userEntity.id);
          MobpushPlugin.bindPhoneNum(Global.userEntity.mobile);
          hideLoadingDialog();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomePage();
                  },
                  settings: RouteSettings(name: HomePage.routeKey)),
              ((route) => false));
        })
        .catchError((err) => {Toast.show(err.message), hideLoadingDialog()})
        .whenComplete(() {
          this._loginButtonDisable = false;
        });
  }

  _checkDialog() {
    bool _isRead = DefaultSharedPreferences.getInstance().get("IS_READ");
    if (_isRead == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Column(
              children: [
                Expanded(child: AnnouncementDialog("2")),
                MaterialButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    DefaultSharedPreferences.getInstance()
                        .put("IS_READ", "true")
                  },
                  minWidth: double.infinity,
                  height: 48,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "已阅读",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () => {exit(0)},
                  minWidth: double.infinity,
                  height: 48,
                  color: Colors.blueGrey,
                  child: Text(
                    "拒绝",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }
  }
}

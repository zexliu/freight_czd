import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freightowner/global.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/utils/shared_preferences.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

import 'login.dart';

class MobileCaptchaPage extends StatefulWidget {
  @override
  _MobileCaptchaPageState createState() => _MobileCaptchaPageState();
}

class _MobileCaptchaPageState extends State<MobileCaptchaPage> {
  final TextEditingController _captchaController = TextEditingController();
  final TextEditingController _captchaControllerNew = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  FocusNode _captchaNode = FocusNode();
  FocusNode _captchaNodeNew = FocusNode();
  FocusNode _mobileNode = FocusNode();
  bool _buttonDisabled = false;
  bool _buttonDisabledNew = false;
  int _countDown = 60;
  int _countDownNew = 60;
  Timer _timer;
  Timer _timerNew;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _captchaNode),
      KeyboardActionsItem(focusNode: _mobileNode),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "修改手机号",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SafeArea(
          child: KeyboardActions(
        config: _buildConfig(context),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("原手机号"),
                      SizedBox(
                        width: 8,
                      ),
                      Text("${Global.userEntity.mobile}"),
                    ],
                  ),

                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("原验证码"),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _captchaNode,
                      controller: _captchaController,
                      maxLines: 1,
                      maxLength: 6,
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
                        contentPadding: EdgeInsets.all(6.0),
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 14),
                        hintText: '请输入原验证码',
                      ),
                    ),
                  ),
                  MaterialButton(
                    child: Text(_buttonDisabled ? "$_countDown秒后重新获取" : "获取验证码",
                        style: TextStyle(
                            color: _buttonDisabled
                                ? Colors.black38
                                : Colors.black54,
                            fontSize: 14)),
                    onPressed: _buttonDisabled ? null : _onCaptchaPress,
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("新手机号"),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _mobileNode,
                      controller: _mobileController,
                      maxLines: 1,
                      maxLength: 11,
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
                        contentPadding: EdgeInsets.all(6.0),
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 14),
                        hintText: '请输入新手机号',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("新验证码"),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _captchaNodeNew,
                      controller: _captchaControllerNew,
                      maxLines: 1,
                      maxLength: 6,
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
                        contentPadding: EdgeInsets.all(6.0),
                        labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 14),
                        hintText: '请输入新验证码',
                      ),
                    ),
                  ),
                  MaterialButton(
                    child: Text(_buttonDisabledNew ? "$_countDownNew秒后重新获取" : "获取验证码",
                        style: TextStyle(
                            color: _buttonDisabledNew
                                ? Colors.black38
                                : Colors.black54,
                            fontSize: 14)),
                    onPressed: _buttonDisabledNew ? null : _onCaptchaPressNew,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: MaterialButton(
                height: 44,
                child: Text("确定"),
                onPressed: _onConfirm,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                minWidth: double.infinity,
              ),
            )
          ],
        ),
      )),
    );
  }

  _onCaptchaPress() async {
    this._buttonDisabled = true;
    showLoadingDialog();
    HttpManager.getInstance().post("/api/v1/captcha/code/CHANGE_MOBILE",
        params: {"mobile": Global.userEntity.mobile}).then((value) {
      hideLoadingDialog();
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
      Toast.show(error.message);
      this._buttonDisabled = false;
    });
  }


  _onCaptchaPressNew() async {
    if(_mobileController.text.length != 11){
      Toast.show("请输入有效的新手机号");
      return;
    }
    this._buttonDisabledNew = true;
    showLoadingDialog();
    HttpManager.getInstance().post("/api/v1/captcha/code/CHANGE_MOBILE",
        params: {"mobile": _mobileController.text}).then((value) {
      hideLoadingDialog();
      Toast.show("获取验证码成功");
      _captchaNodeNew.requestFocus();
      _timerNew = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_countDownNew == 0) {
            _buttonDisabledNew = false;
            _timerNew.cancel();
          } else {
            _countDownNew--;
          }
        });
      });
      setState(() {
        _countDownNew = 60;
      });
    }).catchError((error) {
      hideLoadingDialog();
      Toast.show(error.message);
      this._buttonDisabledNew = false;
    });
  }


  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    if (_timerNew != null) {
      _timerNew.cancel();
    }
    super.dispose();
  }

  _onConfirm() {
    if (_captchaController.text.length != 6) {
      Toast.show("请输入有效的原验证码");
      return;
    }
    if (_mobileController.text.length != 11) {
      Toast.show("请输入有效的新手机号");
      return;
    }
    if (_captchaControllerNew.text.length != 6) {
      Toast.show("请输入有效的新验证码");
      return;
    }
    showLoadingDialog();
    HttpManager.getInstance().post("/api/v1/users/mobile",params: {"mobile":_mobileController.text,"captcha":_captchaController.text,"newCaptcha":_captchaControllerNew.text}).then((value) async {
      hideLoadingDialog();
      Toast.show("修改成功");
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
    }).catchError((e) {
      Toast.show(e.toString());
      hideLoadingDialog();
    });
  }
}

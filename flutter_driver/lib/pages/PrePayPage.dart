import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/delivery_details_entity.dart';
import 'package:flutterdriver/model/pay_entity.dart';
import 'package:flutterdriver/pages/pay_result_page.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/date_utils.dart';
import 'package:flutterdriver/utils/text_input_formatter.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:fluwx/fluwx.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PrePayPage extends StatefulWidget {
  final DeliveryDetailsEntity entity;

  final String freightAmount;

  final String amount;

  final int type;
  PrePayPage(this.entity,this.freightAmount,this.amount,this.type);

  @override
  _PrePayPageState createState() => _PrePayPageState();
}

class _PrePayPageState extends State<PrePayPage> {
  bool isWeChat = true;
  TextEditingController _amountController1 = TextEditingController();
  TextEditingController _amountController2 = TextEditingController();
  FocusNode _amountNode1 = FocusNode();
  FocusNode _amountNode2 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _amountNode1),
      KeyboardActionsItem(focusNode: _amountNode2),
    ], nextFocus: true);
  }

  @override
  void initState() {
    super.initState();
    if(widget.type == 1){
      _amountController1.text = widget.amount;
      _amountController2.text = widget.freightAmount;
    }

    weChatResponseEventHandler.listen((res) {
      if (res is WeChatPaymentResponse) {
        print("pay result = ${res.errCode}");

        if(res.errCode == 0){
          print("支付成功");
          Navigator.of(context).pop("success");
          Navigator.of(context).push(MaterialPageRoute(builder: (c){
            return PayResultPage(true);
          }));
        }else if (res.errCode == -2){
          Toast.show("已取消支付");
        }else{
          Navigator.of(context).push(MaterialPageRoute(builder: (c){
            return PayResultPage(false);
          }));
        }
        // do something here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("支付定金"),
      ),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            AreaUtils.getCityAndDistrictName(
                                widget.entity.loadProvinceCode,
                                widget.entity.loadCityCode,
                                widget.entity.loadDistrictCode),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Image.asset(
                            "images/arrow_right_alt.png",
                            width: 40,
                            height: 28,
                          ),
                          Text(
                            AreaUtils.getCityAndDistrictName(
                                widget.entity.unloadProvinceCode,
                                widget.entity.unloadCityCode,
                                widget.entity.unloadDistrictCode),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${DateUtils.getTimeString(widget.entity.loadStartAt, widget.entity.loadEndAt)}可装",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.volume_up,
                            color: Theme.of(context).primaryColor,
                            size: 12,
                          ),
                          Text(
                            "请如实填写谈好的运费定金, 有纠纷平台据此处理",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                      Divider(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("定金            "),
                          Expanded(
                            child: TextField(
                              enabled: widget.type == 0,
                              controller: _amountController1,
                              onChanged: (v){setState(() {
                              });},
                              focusNode: _amountNode1,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter(
                                    RegExp("[0-9.]")),
                                //只输入数字
                                UsNumberTextInputFormatter(1000),
                                //只输入数字
                              ],
                              textAlign: TextAlign.end,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                prefixText: "¥",
                                suffixText: "元",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 16),
                                hintText: "必填, 10-1000",
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("应收运费     "),
                          Expanded(
                            child: TextField(
                              enabled: widget.type == 0,
                              controller: _amountController2,
                              focusNode: _amountNode2,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter(
                                    RegExp("[0-9.]")),
                                //只输入数字
                                UsNumberTextInputFormatter(50000),
                                //只输入数字
                              ],
                              textAlign: TextAlign.end,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                prefixText: "¥",
                                suffixText: "元",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 16),
                                hintText: "必填, 10-50000",
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    new CheckboxListTile(
                      secondary: Image.asset("images/wechat.png"),
                      title: const Text('微信'),
                      value: this.isWeChat,
                      onChanged: (bool value) {
                        setState(() {
                          this.isWeChat = true;
                        });
                      },
                    ),
//                    Divider(
//                      height: 1,
//                    ),
//                    new CheckboxListTile(
//                      secondary: Image.asset("images/zhifubao.png"),
//                      title: const Text('支付宝'),
//                      value: !this.isWeChat,
//                      onChanged: (bool value) {
//                        setState(() {
//                          this.isWeChat = false;
//                        });
//                      },
//                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  minWidth: double.infinity,
                  onPressed: (){

                    if (_amountController1.text.isEmpty || double.parse(_amountController1.text) < 50) {
                      Toast.show("请输入有效订金");
                      return;
                    }
                    if (_amountController2.text.isEmpty || double.parse(_amountController2.text) < 10) {
                      Toast.show("请输入有效应收运费");
                      return;
                    }
                    showLoadingDialog();

                    HttpManager.getInstance().post(widget.type == 1? "/api/v1/orders/${widget.entity.id}/driver/pay": "/api/v1/deliver/goods/${widget.entity.id}/driver/pay",params: {"channelType":"WXPAY_APP","amount":_amountController1.text,"freightAmount":_amountController2.text}).then((value) async {
                      hideLoadingDialog();
                      var result = PayEntity().fromJson(value);
                      payWithWeChat(
                        appId: result.appId,
                        partnerId: "1602189471",
                        prepayId: result.prepayId,
                        packageValue: result.package,
                        nonceStr: result.nonceStr,
                        timeStamp: int.parse(result.timeStamp),
                        sign: result.paySign,
                      );

                    }).catchError((e){
                      print("error = $e");
                      hideLoadingDialog();
                      Toast.show(e);
                    });

                  },
                  child:Text("确认支付${_amountController1.text.isEmpty? "0":_amountController1.text}元"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

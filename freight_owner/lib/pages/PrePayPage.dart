import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluwx/fluwx.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/delivery_details_entity.dart';
import 'package:freightowner/model/pay_entity.dart';
import 'package:freightowner/pages/pay_result_page.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/date_utils.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PrePayPage extends StatefulWidget {
  final DeliveryDetailsEntity entity;

  PrePayPage(this.entity);

  @override
  _PrePayPageState createState() => _PrePayPageState();
}

class _PrePayPageState extends State<PrePayPage> {
  bool isWeChat = true;
  TextEditingController _amountController1 = TextEditingController();
  FocusNode _amountNode1 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _amountNode1),
    ], nextFocus: false);
  }

  @override
  void initState() {
    super.initState();

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
        title: Text("支付运费"),
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
                  child: Row(
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
                    if (_amountController1.text.isEmpty ) {
                      Toast.show("请输入有效运费");
                      return;
                    }
                    // if (_amountController1.text.isEmpty || double.parse(_amountController1.text) < 10) {
                    //   Toast.show("请输入有效运保费");
                    //   return;
                    // }

                    showLoadingDialog();

                    HttpManager.getInstance().post( "/api/v1/orders/${widget.entity.id}/master/pay",params: {"channelType":"WXPAY_APP","amount":_amountController1.text}).then((value) async {
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

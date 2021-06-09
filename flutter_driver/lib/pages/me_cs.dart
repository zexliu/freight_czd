import 'package:flutter/material.dart';
import 'package:flutterdriver/http/common.dart';
import 'package:flutterdriver/model/dict_entry_entity.dart';
import 'package:flutterdriver/utils/Toast.dart';

import 'package:flutter/services.dart';

class MeServicePage extends StatefulWidget {
  @override
  _MeServicePageState createState() => _MeServicePageState();
}

class _MeServicePageState extends State<MeServicePage> {
  String wechat = "";
  String qq = "";

  @override
  void initState() {
    fetchDict("link_service").then((value) => {
      value.records.forEach((element) {
        if(element.dictEntryName == 'wechat'){
          wechat = element.dictEntryValue;
        }
        if(element.dictEntryName == 'qq'){
          qq = element.dictEntryValue;
        }
        this.setState(() {

        });
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("联系客服"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 216,
              child: Card(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 38,
                    ),
                    Text(
                      "在线客服",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text("微信号: ${wechat}"),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "复制",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            onTap: () => {
                              Clipboard.setData(ClipboardData(text: wechat)),
                              Toast.show("复制成功")
                            },
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text("  QQ号: ${qq}"),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "复制",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            onTap: () => {
                              Clipboard.setData(ClipboardData(text: qq)),
                              Toast.show("复制成功")
                            },
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
            top: 88,
          ),
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(
                          color: Colors.grey.shade200,
                          width: 4,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Image.asset(
                        "images/me_service.png",
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            ),
            top: 64,
          ),
        ],
      ),
    );
  }
}

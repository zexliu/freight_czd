
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/pages/deliver_list_history.dart';
import 'package:freightowner/pages/deliver_list_mark.dart';

import 'deliver_list_ing.dart';

class HomeDeliverPage extends StatefulWidget {
  @override
  _HomeDeliverPageState createState() => _HomeDeliverPageState();
}

class _HomeDeliverPageState extends State<HomeDeliverPage>
    with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
//        leading: MaterialButton(
//            child: Text(
//              "消息",
//              style:
//                  TextStyle(color: Colors.white, fontSize: 12),
//            ),
//            onPressed: () {}),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => {
                this.setState(() {
                  this._tabController.index = 0;
                })
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    color: this._tabController.index == 0
                        ? Colors.white
                        : Colors.transparent),
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Text(
                  " 发货中 ",
                  style: TextStyle(
                      fontSize: 12,
                      color: this._tabController.index == 0
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
              ),
            ),
            GestureDetector(
                onTap: () => {
                      this.setState(() {
                        this._tabController.index = 1;
                      })
                    },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white, width: 1),
                        bottom: BorderSide(color: Colors.white, width: 1),
                      ),
                      color: this._tabController.index == 1
                          ? Colors.white
                          : Colors.transparent),
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(
                    "发货历史",
                    style: TextStyle(
                        fontSize: 12,
                        color: this._tabController.index == 1
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  ),
                )),
            GestureDetector(
              onTap: () => {
                this.setState(() {
                  this._tabController.index = 2;
                })
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    color: this._tabController.index == 2
                        ? Colors.white
                        : Colors.transparent),
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Text(
                  "常发货源",
                  style: TextStyle(
                      fontSize: 12,
                      color: this._tabController.index == 2
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          DeliverListIng(),
          DeliverListHistory(),
          DeliverListMark(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


  @override
  void dispose() {
    super.dispose();
  }
}

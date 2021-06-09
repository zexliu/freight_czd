import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/global.dart';
import 'package:freightowner/pages/home_order_list.dart';

class HomeOrderPage extends StatefulWidget {
  @override
  _HomeOrderPageState createState() => _HomeOrderPageState();
}

class _HomeOrderPageState extends State<HomeOrderPage>
    with SingleTickerProviderStateMixin {
//
  List<String> _titles = ["全部", "待确认", "运输中", "待支付" , "待评价", "取消/退款"];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 0,
            ),
            Text(
              "订单",
              style: TextStyle(color: Colors.white),
            ),
//            Positioned(
//              left: 0,
//              child: GestureDetector(
//                onTap: () => {print("点击了开票")},
//                child: Row(
//                  children: <Widget>[
//                    Icon(
//                      Icons.assignment,
//                      color: Colors.white,
//                      size: 14,
//                    ),
//                    Text(
//                      "开票",
//                      style: TextStyle(color: Colors.white, fontSize: 14),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            Positioned(
//              right: 0,
//              child: IconButton(
//                icon: Icon(
//                  Icons.search,
//                  color: Colors.white,
//                ),
//                onPressed: () => {print("search")},
//              ),
//            )
          ],
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Material(
            color: Colors.white,
            child: TabBar(
              labelColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              unselectedLabelColor: Colors.black54,
              controller: _tabController,
              isScrollable: true,
              tabs: _buildTabs(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _buildTabViews(),
      ),
    );
  }

  List<Tab> _buildTabs() {
    List<Tab> tabs = [];
    _titles.forEach((element) {
      tabs.add((Tab(text: element)));
    });
    return tabs;
  }

  List<Widget> _buildTabViews() {
    List<Widget> widgets = [];
    widgets.add(HomeOrderList({"userId": Global.userEntity.id}));
    widgets.add(HomeOrderList(
        {"userId": Global.userEntity.id, "protocolStatus": false,"cancelStatus": false,"confirmStatus":false}));
    widgets.add(HomeOrderList(
        {"userId": Global.userEntity.id, "confirmStatus": false,"cancelStatus": false}));
    widgets.add(
        HomeOrderList({"userId": Global.userEntity.id, "protocolStatus": true,"payStatus": false,"confirmStatus":false ,"cancelStatus": false}));
    widgets.add(HomeOrderList(
        {"userId": Global.userEntity.id,"confirmStatus": true,"evaluateStatus": false}));
    widgets.add(HomeOrderList(
        {"userId": Global.userEntity.id, "cancelStatus": true}));
    return widgets;
  }
}

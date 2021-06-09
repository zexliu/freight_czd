import 'package:flutter/material.dart';

import 'announcement_list.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _titles = ["规则中心", "公告通知"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("法律条款和规则"),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Material(
              color: Colors.white,
              child: TabBar(
                labelPadding: EdgeInsets.fromLTRB(32,0,32,0),
                labelColor: Theme.of(context).primaryColor,
                labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                unselectedLabelColor: Colors.black54,
                controller: _tabController,
                isScrollable: true,
                tabs: _titles
                    .map((e) => Tab(
                          text: e,
                        ))
                    .toList(),
              ),
            )),
      ),
      body:  TabBarView(
        controller: _tabController,
        children: [
          AnnouncementListPage(type: 1),
          AnnouncementListPage(type: 2),
        ],
      ),
    );
  }
}

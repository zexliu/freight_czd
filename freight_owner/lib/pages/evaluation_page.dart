import 'package:flutter/material.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/evaluation_statistical_entity.dart';
import 'package:freightowner/pages/evaluation_list_page.dart';

class EvaluationPage extends StatefulWidget {
  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage>
    with SingleTickerProviderStateMixin {
  var tabs = <Tab>[
    Tab(
      text: "全部",
    ),
    Tab(
      text: "好评",
    ),
    Tab(
      text: "中评",
    ),
    Tab(
      text: "差评",
    ),
  ];
  TabController controller;
  int _total = 0;
  int _level1 = 0;
  int _level2 = 0;
  int _level3 = 0;

  @override
  void initState() {
    controller =
        TabController(length: tabs.length, vsync: this);
    HttpManager.getInstance()
        .get("/api/v1/evaluations/statistical")
        .then((value) {
      EvaluationStatisticalEntity entity =
          EvaluationStatisticalEntity().fromJson(value);
      setState(() {
        _total = entity.level1Count + entity.level2Count + entity.level3Count;
        _level1 = entity.level1Count;
        _level2 = entity.level2Count;
        _level3 = entity.level3Count;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("评价管理"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            "${_total == 0 ? "0%" : (_level1.toDouble() / _total.toDouble()).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "好评率",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "$_total条评价",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "好评",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor),
                                  value: _total == 0
                                      ? 0
                                      : _level1.toDouble() / _total.toDouble(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                _level1.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "中评",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor),
                                  value:  _total == 0
                                      ? 0
                                      : _level2.toDouble() / _total.toDouble(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                _level2.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "差评",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor),
                                  value:  _total == 0
                                      ? 0
                                      : _level3.toDouble() / _total.toDouble(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                _level2.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: TabBar(
                      controller: controller,
                      //可以和TabBarView使用同一个TabController
                      tabs: tabs,
                      isScrollable: true,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.only(bottom: 0),
                      labelColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  body: TabBarView(
                      controller: controller,
                      children: [EvaluationListPage({}),EvaluationListPage({"level":1}),EvaluationListPage({"level":2}),EvaluationListPage({"level":3}),]
                          .toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

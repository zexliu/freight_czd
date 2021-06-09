import 'package:flutter/material.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/announcement_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'announcement_details_page.dart';
import 'empty_page.dart';

class AnnouncementListPage extends StatefulWidget {
  final int type;

  const AnnouncementListPage({Key key, this.type}) : super(key: key);
  @override
  _AnnouncementListPageState createState() => _AnnouncementListPageState();
}

class _AnnouncementListPageState extends State<AnnouncementListPage>  with AutomaticKeepAliveClientMixin{

  bool _enablePullUp = false;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int _current = 1;

  int _size = 10;

  List<AnnouncementRecords> _items = [];


  @override
  void initState() {
    _onRefresh();
    super.initState();
  }
  void _onRefresh() async {
    // monitor network fetch
    _refreshController.resetNoData();
    _current = 1;
    var params = {
      "current":_current,
      "size":_size,
      "announcementType":widget.type
    };
    HttpManager.getInstance()
        .get("/api/v1/announcements", params: params)
        .then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = AnnouncementEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    // monitor network fetch
    _current++;
    var params = {
      "current":_current,
      "size":_size,
      "announcementType":widget.type
    };
    HttpManager.getInstance()
        .get("/api/v1/announcements", params: params)
        .then((value) {
      var values = AnnouncementEntity().fromJson(value).records;
      _items.addAll(values);
      if (values.length < 10) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.loadFailed()});
  }
  @override
  Widget build(BuildContext context) {   super.build(context);

  return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _enablePullUp,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _items.length == 0 ? _buildEmpty(context) : _buildList(context));
  }

  @override
  bool get wantKeepAlive => true;

  _buildEmpty(BuildContext context) {
    return EmptyPage(
      image: "images/empty_order.png",
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text("暂无数据"),
      ],
    );
  }

  _buildList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: ListTile.divideTiles(context: context,tiles: _items.map((e) =>
          ListTile(title: Text(e.title),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (c){
                return AnnouncementDetailsPage(e.id);
              }
            ));
          },))).toList(),
    );
  }
}

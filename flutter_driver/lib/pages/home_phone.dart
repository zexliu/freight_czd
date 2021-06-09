import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/event/events.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/call_entity.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/phone_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'empty_page.dart';

class HomePhonePage extends StatefulWidget {
  @override
  _HomePhonePageState createState() => _HomePhonePageState();
}

class _HomePhonePageState extends State<HomePhonePage>  with WidgetsBindingObserver{
  List<CallRecord> _items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  StreamSubscription<HomePageChangedEvent> _listen;

  var _current = 1;
  var _size = 10;
  var _enablePullUp = false;

  @override
  void initState() {
    _onRefresh();
    super.initState();
    _listen = eventBus.on<HomePageChangedEvent>().listen((event) {
      if (event.index == 3) {
        _onRefresh();
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onRefresh();
    }
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _listen.cancel();
    super.dispose();
  }


  void _onRefresh() async {
    _refreshController.resetNoData();
    _current = 1;
    HttpManager.getInstance().get("/api/v1/calls",params: {"current":_current,"size":_size}).then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = CallEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    _current++;
    HttpManager.getInstance().get("/api/v1/calls",params: {"current":_current,"size":_size}).then((value) {
      var values = CallEntity().fromJson(value).records;
      _items.addAll(values);
      if (values.length < _size) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.loadFailed()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "通话记录",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child:
              _items.length == 0 ? _buildEmpty(context) : _buildList(context),
        ));
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyPage(
      image: "images/empty_phone.png",
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text("暂无数据"),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i){
        var  item =  _items[i];
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.type == true ? item.toAvatar : item.fromAvatar,
                            placeholder: (context, url) =>
                                Image.asset("images/default_avatar.png",fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,),
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    item.type == true ? item.toNickname : item.fromNickname,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    item.type == true ? item.toMobile : item.fromMobile,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AreaUtils.getCityAndDistrictName(
                                        item.loadProvinceCode,
                                        item.loadCityCode,
                                        item.loadDistrictCode),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Image.asset(
                                    "images/arrow_right_alt.png",
                                    width: 40,
                                    height: 28,
                                  ),
                                  Text(
                                    AreaUtils.getCityAndDistrictName(
                                        item.unloadProvinceCode,
                                        item.unloadCityCode,
                                        item.unloadDistrictCode),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(56, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item.goodsStatus == 1 ? "发货中" : "已下架",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12),
                            ),
                            Row(
                              children: <Widget>[
//                                GestureDetector(
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        border: Border.all(
//                                            color: Colors.white, width: 1),
//                                        color: true
//                                            ? Colors.grey.shade300
//                                            : Colors.transparent),
//                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
//                                    child: Text(
//                                      "指定承运",
//                                      style: TextStyle(
//                                          fontSize: 12,
//                                          color: true
//                                              ? Colors.white
//                                              : Theme.of(context).primaryColor),
//                                    ),
//                                  ),
//                                ),
//                                SizedBox(
//                                  width: 8,
//                                ),
//                                GestureDetector(
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        border: Border.all(
//                                            color: Theme.of(context)
//                                                .primaryColor,
//                                            width: 1),
//                                        color: true
//                                            ? Colors.transparent
//                                            : Colors.grey.shade300),
//                                    padding:
//                                    EdgeInsets.fromLTRB(8, 4, 8, 4),
//                                    child: Text(
//                                      "  聊天  ",
//                                      style: TextStyle(
//                                          fontSize: 12,
//                                          color: true
//                                              ? Theme.of(context)
//                                              .primaryColor
//                                              : Theme.of(context)
//                                              .primaryColor),
//                                    ),
//                                  ),
//                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: (){
                                    PhoneUtils.call(context,item.type == true ? item.toMobile : item.fromMobile, item.type == true ? item.toUserId:item.fromUserId, item.goodsId);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                            width: 1),
                                        color:  Theme.of(context).primaryColor),
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Text(
                                      " 打电话 ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ))),
        );
      },
      itemCount: _items.length,
    );
  }
}

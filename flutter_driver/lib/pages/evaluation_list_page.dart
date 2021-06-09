import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/evaluation_list_entity.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'empty_page.dart';
import 'evaluation_details_page.dart';
import 'package:flutterdriver/utils/date_extension.dart';

class EvaluationListPage extends StatefulWidget {
  final Map<String, dynamic> params;

  EvaluationListPage(this.params);

  @override
  _EvaluationListPageState createState() => _EvaluationListPageState();
}

class _EvaluationListPageState extends State<EvaluationListPage>
    with AutomaticKeepAliveClientMixin {
  List<EvaluationListRecord> _items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _enablePullUp = false;

  int _current = 1;

  int _size = 10;

  @override
  void initState() {
    super.initState();
    this._onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    _refreshController.resetNoData();
    _current = 1;
    widget.params["current"] = _current;
    widget.params["size"] = _size;
    HttpManager.getInstance()
        .get("/api/v1/evaluations/order", params: widget.params)
        .then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = EvaluationListEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    // monitor network fetch
    _current++;
    widget.params["current"] = _current;
    widget.params["size"] = _size;
    HttpManager.getInstance()
        .get("/api/v1/evaluations/order", params: widget.params)
        .then((value) {
      var values = EvaluationListEntity().fromJson(value).records;
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
  Widget build(BuildContext context) {
    super.build(context);
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: _enablePullUp,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _items.length == 0 ? _buildEmpty(context) : _buildList(context));
  }

  _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        var item = _items[i];
        return Card(
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (c){
                  return EvaluationDetailsPage(item);
                }
              ));
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.driverAvatar,
                        placeholder: (context, url) =>
                            Image.asset("images/default_avatar.png", fit: BoxFit.cover,
                              width: 40,
                              height: 40,),
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${AreaUtils.findCity(item.loadProvinceCode, item.loadCityCode).label} ${AreaUtils.findDistrict(item.loadProvinceCode, item.loadCityCode, item.loadDistrictCode).label} → ${AreaUtils.findCity(item.unloadProvinceCode, item.unloadCityCode).label} ${AreaUtils.findDistrict(item.unloadProvinceCode, item.unloadCityCode, item.unloadDistrictCode).label}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${item.driverName} | ${item.categoryName}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "我收到的评价:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Visibility(
                        visible: item.driverEvaluationId == null,
                        child: Text(
                          "对方未评价",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    child: SizedBox(
                      height: 4,
                    ),
                    visible: item.driverEvaluationId != null,
                  ),
                  Visibility(
                    child: Row(
                      children: [
                        Image.asset(
                          item.driverLevel == 1
                              ? "images/smile_selected.png"
                              : item.driverLevel == 2
                              ? "images/meh_selected.png"
                              : "images/frown_selected.png",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          item.driverLevel == 1
                              ? "好评"
                              : item.driverLevel == 2 ? "中评" : "差评",
                          style: TextStyle(
                              fontSize: 14,
                              color: item.driverLevel == 1
                                  ? Colors.deepOrangeAccent
                                  : item.driverLevel == 2
                                  ? Colors.amber
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    visible: item.driverEvaluationId != null,
                  ),
                  Visibility(
                    child: SizedBox(
                      height: 4,
                    ),
                    visible: item.driverEvaluationId != null,
                  ),
                  Visibility(
                    visible: item.driverEvaluationId != null,
                    child: Text(
                      item.driverTags == null
                          ? ""
                          : item.driverTags.split(",").join("  "),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Visibility(
                    child: SizedBox(
                      height: 4,
                    ),
                    visible: item.driverEvaluationId != null,
                  ),
                  Visibility(
                    visible: item.driverEvaluationId != null,
                    child: Text(
                      "评价时间:  ${item.driverCreateAt == null ? "" : DateTime.fromMillisecondsSinceEpoch(item.driverCreateAt).toZhString()}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "我发表的评价:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Visibility(
                        visible: item.userEvaluationId == null,
                        child: Text(
                          "未评价对方",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    child: SizedBox(
                      height: 4,
                    ),
                    visible: item.userEvaluationId != null,
                  ),
                  Visibility(
                    child: Row(
                      children: [
                        Image.asset(
                          item.userLevel == 1
                              ? "images/smile_selected.png"
                              : item.userLevel == 2
                              ? "images/meh_selected.png"
                              : "images/frown_selected.png",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          item.userLevel == 1
                              ? "好评"
                              : item.userLevel == 2 ? "中评" : "差评",
                          style: TextStyle(
                              fontSize: 14,
                              color: item.userLevel == 1
                                  ? Colors.deepOrangeAccent
                                  : item.userLevel == 2
                                  ? Colors.amber
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    visible: item.userEvaluationId != null,
                  ),
                  Visibility(
                    child: SizedBox(
                      height: 4,
                    ),
                    visible: item.userEvaluationId != null,
                  ),
                  Visibility(
                    visible: item.userEvaluationId != null,
                    child: Text(
                      item.userTags == null
                          ? ""
                          : item.userTags.split(",").join("  "),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Visibility(
                    child: SizedBox(
                      height: 4,
                    ),
                    visible: item.userEvaluationId != null,
                  ),
                  Visibility(
                    visible: item.userEvaluationId != null,
                    child: Text(
                      "评价时间: ${item.userCreateAt == null ? "" : DateTime.fromMillisecondsSinceEpoch(item.userCreateAt).toZhString()}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: _items.length,
    );
  }

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

  @override
  bool get wantKeepAlive => true;
}

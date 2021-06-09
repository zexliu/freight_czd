import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/model/evaluation_list_entity.dart';
import 'package:flutterdriver/utils/area_utils.dart';

class EvaluationDetailsPage extends StatefulWidget {
  final EvaluationListRecord item;

  EvaluationDetailsPage(this.item);

  @override
  _EvaluationDetailsPageState createState() => _EvaluationDetailsPageState();
}

class _EvaluationDetailsPageState extends State<EvaluationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("评价详情"),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.item.driverAvatar,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${AreaUtils.findCity(widget.item.loadProvinceCode, widget.item.loadCityCode).label} ${AreaUtils.findDistrict(widget.item.loadProvinceCode, widget.item.loadCityCode, widget.item.loadDistrictCode).label} → ${AreaUtils.findCity(widget.item.unloadProvinceCode, widget.item.unloadCityCode).label} ${AreaUtils.findDistrict(widget.item.unloadProvinceCode, widget.item.unloadCityCode, widget.item.unloadDistrictCode).label}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.item.driverName} | ${widget.item.categoryName}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Padding(
              child: widget.item.driverEvaluationId != null
                  ? _buildContent(
                      "他对我的评价", widget.item.driverLevel, widget.item.driverTags,widget.item.driverDescription)
                  : _buildEmpty("对方未评价"),
              padding: EdgeInsets.all(16),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Padding(
              child: widget.item.userEvaluationId != null
                  ? _buildContent(
                      "我对他的评价", widget.item.userLevel, widget.item.userTags,widget.item
              .userDescription)
                  : _buildEmpty("未对他评价"),
              padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  _buildContent(String s, int level, String tags, String description) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              s,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: Image.asset(
              level == 1
                  ? "images/smile_selected.png"
                  : level == 2
                      ? "images/meh_selected.png"
                      : "images/frown_selected.png",
              width: 32,
              height: 32,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              level == 1 ? "好评" : level == 2 ? "中评" : "差评",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: level == 1
                      ? Colors.deepOrangeAccent
                      : level == 2 ? Colors.amber : Colors.grey.shade700),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            children: tags
                .split(",")
                .map((e) => Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 16,
          ),
          Text(description,style: TextStyle(fontSize: 12, color: Colors.grey),)
        ],
      ),
    );
  }

  _buildEmpty(String s) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Image.asset("images/empty_order.png"),
          SizedBox(
            height: 16,
          ),
          Text(
            s,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
    );
  }
}

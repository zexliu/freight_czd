import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class EvaluationSubmitPage extends StatefulWidget {
  final String avatar;
  final String address;
  final String nickname;
  final String categoryName;
  final String orderId;

  EvaluationSubmitPage(this.orderId,this.avatar, this.address, this.nickname, this.categoryName);

  @override
  _EvaluationSubmitPageState createState() => _EvaluationSubmitPageState();
}

class _EvaluationSubmitPageState extends State<EvaluationSubmitPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  bool _isAnonymous = false;
  int _level = 1;
  List<String> _tags = [];
  List<String> _tagLevel11 = ["车况好", "车厢整洁", "车牌相符"];
  List<String> _tagLevel12 = ["车况较差", "车牌不符"];
  List<String> _tagLevel13 = ["车辆信息不符", "车牌不符"];

  List<String> _tagLevel1;

  List<String> _tagLevel21 = ["安全送达", "送货快"];
  List<String> _tagLevel22 = ["坐地起价", "装货迟到","订好不装","有货损","送货慢"];
  List<String> _tagLevel23 = ["坐地起价", "装货迟到","订好不装","不给钱不卸货","送货慢","有货损"];

  List<String> _tagLevel2;



  List<String> _tagLevel31 = ["服务周到", "态度好","合作愉快","诚实守信"];
  List<String> _tagLevel32 = ["服务一般", "不守信用","斤斤计较"];
  List<String> _tagLevel33 = ["态度恶劣", "不配合装车","不守信用","言语辱骂","威胁恐吓"];

  List<String> _tagLevel3;


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _focusNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _tagLevel1 = _tagLevel11;
    _tagLevel2 = _tagLevel21;
    _tagLevel3 = _tagLevel31;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("评价司机"),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: KeyboardActions(
          autoScroll: true,
          config: _buildConfig(context),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.avatar,
                        placeholder: (context, url) =>
                            Image.asset("images/default_avatar.png",fit: BoxFit.cover,
                              width: 88,
                              height: 88,),
                        fit: BoxFit.cover,
                        width: 88,
                        height: 88,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.address,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.nickname} | ${widget.categoryName}",
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Column(
                                children: [
                                  Image.asset(
                                    _level == 1
                                        ? "images/smile_selected.png"
                                        : "images/smile.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "好评",
                                    style: TextStyle(
                                        color: _level == 1
                                            ? Colors.deepOrangeAccent
                                            : Colors.grey[350],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _tags.clear();
                                _tagLevel1 = _tagLevel11;
                                _tagLevel2 = _tagLevel21;
                                _tagLevel3 = _tagLevel31;
                                _level = 1;
                              });
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Column(
                                children: [
                                  Image.asset(
                                    _level == 2
                                        ? "images/meh_selected.png"
                                        : "images/meh.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "中评",
                                    style: TextStyle(
                                        color: _level == 2
                                            ? Colors.amber
                                            : Colors.grey[350],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _tags.clear();
                                _tagLevel1 = _tagLevel12;
                                _tagLevel2 = _tagLevel22;
                                _tagLevel3 = _tagLevel32;
                                _level = 2;
                              });
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Column(
                                children: [
                                  Image.asset(
                                    _level == 3
                                        ? "images/frown_selected.png"
                                        : "images/frown.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "差评",
                                    style: TextStyle(
                                        color: _level == 3
                                            ? Colors.grey.shade700
                                            : Colors.grey[350],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _tags.clear();
                                _tagLevel1 = _tagLevel13;
                                _tagLevel2 = _tagLevel23;
                                _tagLevel3 = _tagLevel33;
                                _level = 3;
                              });
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              _level == 1
                                  ? "比较满意或非常满意"
                                  : _level == 2
                                  ? "一般多方面需要改进"
                                  : "不满意各方面都很差劲",
                              style: TextStyle(
                                  color: _level == 1
                                      ? Colors.deepOrangeAccent
                                      : _level == 2
                                      ? Colors.amber
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "车辆信息",
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Wrap(spacing: 10, runSpacing: 10,alignment: WrapAlignment.start,
                              children: _tagLevel1.map((e){
                                var isSelected = _tags.contains(e);
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(isSelected){
                                        _tags.remove(e);
                                      }else {
                                        if(_tags.length >= 5){
                                          Toast.show("最多选择5项");
                                          return;
                                        }
                                        _tags.add(e);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey),
                                      color: isSelected
                                          ? Colors.orange.withAlpha(40)
                                          : Colors.white,
                                    ),
                                    child: Text(e,style: TextStyle(fontSize: 12,color: isSelected ? Theme.of(context).primaryColor:Colors.grey),),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "履约情况",
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Wrap(spacing: 10, runSpacing: 10,alignment: WrapAlignment.start,
                              children: _tagLevel2.map((e){
                                var isSelected = _tags.contains(e);
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(isSelected){
                                        _tags.remove(e);
                                      }else {
                                        if(_tags.length >= 5){
                                          Toast.show("最多选择5项");
                                          return;
                                        }
                                        _tags.add(e);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey),
                                      color: isSelected
                                          ? Colors.orange.withAlpha(40)
                                          : Colors.white,
                                    ),
                                    child: Text(e,style: TextStyle(fontSize: 12,color: isSelected ? Theme.of(context).primaryColor:Colors.grey),),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "服务态度",
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Wrap(spacing: 10, runSpacing: 10,alignment: WrapAlignment.start,
                              children: _tagLevel3.map((e){
                                var isSelected = _tags.contains(e);
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(isSelected){
                                        _tags.remove(e);
                                      }else {
                                        if(_tags.length >= 5){
                                          Toast.show("最多选择5项");
                                          return;
                                        }
                                        _tags.add(e);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey),
                                      color: isSelected
                                          ? Colors.orange.withAlpha(40)
                                          : Colors.white,
                                    ),
                                    child: Text(e,style: TextStyle(fontSize: 12,color: isSelected ? Theme.of(context).primaryColor:Colors.grey),),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16,),
                      TextField(
                        controller: _editingController,
                        focusNode: _focusNode,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: "有什么补充或其他意见(勾选输入意见匿名后,将不会对司机展示)",
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          isDense: true,
                          border: InputBorder.none,
                          counterText: ""
                        ),
                        style: TextStyle(fontSize: 14),
                        minLines: 3,
                        maxLines: 3,
                        maxLength: 200,
                      ),
//                      Row(
//                        children: [
//                          Checkbox(
//                            value: _isAnonymous,
//                            onChanged: (v){
//                              setState(() {
//                                this._isAnonymous = v;
//                              });
//                            },
//                          ),Text("输入匿名意见")
//                        ],
//                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: MaterialButton(
                  child: Text("提交评价"),
                  minWidth: double.infinity,
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if(_tags.isEmpty){
                      Toast.show("请至少选择一个标签");
                      return;
                    }
                    showLoadingDialog();
                    HttpManager.getInstance().post("/api/v1/orders/${widget.orderId}/evaluation",data: {"tags":_tags.join(","),"description":_editingController.text,"anonymous":_isAnonymous,"level":_level}).then((value){
                      hideLoadingDialog();
                      Navigator.of(context).pop("success");
                    }).catchError((e)=>{hideLoadingDialog()});
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/generated/json/base/json_convert_content.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/category_entity.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/utils/shared_preferences.dart';
import 'package:freightowner/utils/text_input_formatter.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/select_button.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class GoodsPicker extends StatefulWidget {
  final String packageMode;
  //发货改的傻逼需求

  final String weight;
  //发货改的傻逼需求

  final String volume;
  final String categoryName;
  final Function onChanged;

  GoodsPicker(
      {Key key,
      @required this.onChanged,
      this.packageMode,
      this.categoryName,
      this.weight,
      this.volume})
      : super(key: key);

  @override
  _GoodsPickerState createState() => _GoodsPickerState();
}

class _GoodsPickerState extends State<GoodsPicker> {
  var _buildType = 1;

  TextEditingController _searchController;
  TextEditingController _weightController;
  TextEditingController _volumeController;
  FocusNode _searchNode = FocusNode();
  FocusNode _weightNode = FocusNode();
  FocusNode _volumeNode = FocusNode();

  List<CategoryRecord> _hotKeys = [];

  List<CategoryRecord> _categories = [];
  List<CategoryRecord> _searchCategories = [];

  CategoryRecord _currentParent;
  CategoryRecord _currentCategory;

  List<DictEntryRecord> _packageModes = [];

  String _packageMode;

  bool isLoading = true;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _searchNode),
    ], nextFocus: false);
  }

  KeyboardActionsConfig _buildConfig2(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _weightNode),
      KeyboardActionsItem(focusNode: _volumeNode),
    ], nextFocus: true);
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _weightController = TextEditingController();
    _volumeController = TextEditingController();
    _weightController.text =
        widget.weight == null ? "" : widget.weight.toString();
    _volumeController.text =
        widget.volume == null ? "" : widget.volume.toString();
    _packageMode = widget.packageMode;
    if (widget.categoryName != null) {
      _onCategoryTap(widget.categoryName);
    }

    Future.wait([HttpManager.getInstance().get("/api/v1/categories", params: {
      "current": 1,
      "size": 9999,
      "isHot": true,
      "categoryCode": "delivery"
    }),HttpManager.getInstance().get("/api/v1/categories/tree",
        params: {"categoryCode": "delivery"}),fetchDict("package_mode")]).then((list){
      setState(() {
        _hotKeys = JsonConvert.fromJsonAsT<CategoryEntity>(list[0]).records;
        _categories = JsonConvert.fromJsonAsT(list[1]);
        _currentParent = _categories[0];
        _packageModes = list[2].records;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading ?  Center(
        child: CircularProgressIndicator(),
      ) :  _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_buildType == 1) {
      return _buildSearch();
    } else if (_buildType == 2) {
      return _buildCategory();
    } else {
      return _buildConfirm();
    }
  }

  Widget _buildSearch() {
    List<Widget> widgets = [];

    if (_searchCategories.length > 0) {
      widgets.add(ListView.builder(
          shrinkWrap: true,
          itemCount: _searchCategories.length,
          itemBuilder: (BuildContext context, int index) {
            CategoryRecord category = _searchCategories[index];
            if (category.id == null) {
              return ListTile(
                title: Text(category.categoryName),
                trailing: Text(
                  "添加到货物名称",
                ),
                onTap: () {
                  _onCategoryTap(category.categoryName);
                },
              );
            } else {
              return ListTile(
                title: Text(category.categoryName),
                onTap: () {
                  _onCategoryTap(category.categoryName);
                },
              );
            }
          }));
    } else {
      List<String> list = DefaultSharedPreferences.getInstance()
          .getList("DELIVERY_MODE_HISTORY");
      if (list != null && list.length > 0) {
        widgets.add(Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("历史搜索"),
              IconButton(
                onPressed: () {
                  setState(() {
                    DefaultSharedPreferences.getInstance()
                        .setList("DELIVERY_MODE_HISTORY", List<String>());
                  });
                },
                icon: Icon(Icons.delete_forever),
              ),
            ],
          ),
        ));
        List<Widget> historyWidgets = [];
        list.forEach((element) {
          historyWidgets.add(Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 12),
            child: InkWell(
              onTap: () {
                _onCategoryTap(element);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(element),
              ),
            ),
          ));
        });
        widgets.add(Container(
          padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
          child: Wrap(
            children: historyWidgets,
          ),
        ));
      }
      widgets.add(Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("热门搜索"),
            InkWell(
              onTap: () {
                setState(() {
                  _buildType = 2;
                });
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
                child: Row(
                  children: <Widget>[
                    Text("更多"),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
//
//      Container(
//        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//        child: Text("热门搜索"),
//      )
      widgets.add(SizedBox(
        height: 10,
      ));
      List<Widget> hotWidgets = [];
      _hotKeys.forEach((element) {
        hotWidgets.add(Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 12),
          child: InkWell(
            onTap: () {
              _onCategoryTap(element.categoryName);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(element.categoryName),
            ),
          ),
        ));
      });
      widgets.add(Container(
        padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
        child: Wrap(
          children: hotWidgets,
        ),
      ));
    }
    return KeyboardActions(
        config: _buildConfig(context),
        autoScroll: false,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text("关闭"),
                  minWidth: 48,
                ),
                Text(
                  "货物信息",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                AnimatedOpacity(
                  duration: Duration(seconds: 0),
                  opacity: 0,
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "确定",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    minWidth: 48,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Theme(
              data: ThemeData(primaryColor: Colors.grey),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextField(
                  onChanged: (value) => {_fetchCategory(value)},
                  focusNode: _searchNode,
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: InkWell(
                      onTap: () => {_searchController.clear()},
                      child: Icon(Icons.clear),
                    ),
                    hintText: "请如实规范填写货物名称",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(children: widgets),
            )
          ],
        ));
  }

  Widget _buildCategory() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  _buildType = 1;
                });
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            Text(
              "货物分类",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            AnimatedOpacity(
              duration: Duration(seconds: 0),
              opacity: 0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _buildType = 1;
                  });
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    var category = _categories[index];
                    return InkWell(
                      onTap: () {
                        _onParentTap(category);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: category.categoryName ==
                                  _currentParent.categoryName
                              ? Colors.white
                              : Colors.grey.shade200,
                        ),
                        child: Text(
                          category.categoryName,
                          maxLines: 1,
                          style: TextStyle(
                              color: category.categoryName ==
                                      _currentParent.categoryName
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _currentParent.children == null
                      ? 0
                      : _currentParent.children.length,
                  itemBuilder: (BuildContext context, int index) {
                    var child = _currentParent.children[index];
                    return InkWell(
                      onTap: () {
                        _onCategoryTap(child.categoryName);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          child.categoryName,
                          maxLines: 1,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        )
      ],
    );
  }

  void _onParentTap(CategoryRecord category) {
    if (category == _currentParent) {
      return;
    }
    setState(() {
      _currentParent = category;
      _currentCategory = null;
    });
  }

  Widget _buildConfirm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text("关闭"),
                minWidth: 48,
              ),
              Text(
                "货物信息",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_packageMode == null) {
                    Toast.show("请选择包装方式");
                    return;
                  }

                  if (_volumeController.text == "" &&
                      _weightController.text == "") {
                    Toast.show("请输入重量或体积");
                    return;
                  }

                  String weight;
                  if (_weightController.text != "") {
                    //傻逼需求修改
                    weight = _weightController.text;
                  }
                  String volume;

                  if (_volumeController.text != "") {
                    volume = _volumeController.text;
                  }
                  widget.onChanged(_packageMode, _currentCategory.categoryName,
                      weight, volume);
                  Navigator.pop(context);
                },
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.white),
                ),
                minWidth: 48,
              ),
            ],
          ),
          Expanded(
            child: KeyboardActions(
              config: _buildConfig2(context),
              autoScroll: true,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Color.fromARGB(255, 255, 239, 213),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              _packageMode = null;
                              _buildType = 1;
                            });
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  _currentCategory.categoryName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Colors.black87,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "包装方式必填,请选择",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 3,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _currentCategory.dictEntries.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SelectButton(
                                          onTap: () {
                                            setState(() {
                                              _packageMode = _currentCategory
                                                  .dictEntries[index]
                                                  .dictEntryName;
                                            });
                                          },
                                          text: _currentCategory
                                              .dictEntries[index].dictEntryName,
                                          isSelected: _packageMode ==
                                              _currentCategory
                                                  .dictEntries[index]
                                                  .dictEntryName,
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 255, 239, 213),
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "货重/体积,必填一项",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text("重量 (吨)"),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _weightController,
                                      focusNode: _weightNode,
                                      textAlign: TextAlign.right,
                                      maxLength: 10,
                                      maxLines: 1,
                                      // keyboardType:
                                      //     TextInputType.numberWithOptions(
                                      //         decimal: true),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "例: 30-50",
                                        fillColor: Colors.grey.shade200,
                                        filled: true,
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(8),
                                        border: InputBorder.none,
                                        counterText: ""

                                      ),
                                      style: TextStyle(fontSize: 12),
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.allow(
                                      //       RegExp("[0-9.]")), //只输入数字
                                      //   UsNumberTextInputFormatter(999), //只输入数字
                                      // ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text("体积 (方)"),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _volumeController,
                                      focusNode: _volumeNode,
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      maxLength: 10,
                                      // keyboardType:
                                      //     TextInputType.numberWithOptions(
                                      //         decimal: true),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "例: 70-100",
                                        fillColor: Colors.grey.shade200,
                                        filled: true,
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(8),
                                        border: InputBorder.none,
                                        counterText: ""
                                      ),
                                      style: TextStyle(fontSize: 12),
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.allow(
                                      //       RegExp("[0-9.]")), //只输入数字
                                      //   UsNumberTextInputFormatter(999), //只输入数字
                                      // ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _fetchCategory(String text) {
    if (text == "" || text.trim() == "") {
      setState(() {
        _searchCategories = [];
      });
      return;
    }
    String msg = text;
    Future.delayed(Duration(milliseconds: 500), () {
      if (msg == _searchController.text) {
        HttpManager.getInstance().get("/api/v1/categories", params: {
          "categoryCode": "delivery",
          "current": 1,
          "size": 9999,
          "categoryName": msg
        }).then((value) {
          setState(() {
            _searchCategories =
                JsonConvert.fromJsonAsT<CategoryEntity>(value).records;
            bool isHave = false;
            _searchCategories.forEach((element) {
              if (element.categoryName == msg) {
                isHave = true;
              }
            });
            if (!isHave) {
              var category = CategoryRecord();
              category.categoryName = msg;
              _searchCategories.add(category);
            }
          });
        });
      }
    });
  }

  void _onCategoryTap(String categoryName) {
    //保存到历史
    List<String> list =
        DefaultSharedPreferences.getInstance().getList("DELIVERY_MODE_HISTORY");
    if (list == null) {
      list = [];
    }
    list.removeWhere((element) {
      return element == categoryName;
    });

    if (list.length == 10) {
      list.removeLast();
    }
    list.insert(0, categoryName);
    DefaultSharedPreferences.getInstance()
        .setList("DELIVERY_MODE_HISTORY", list);
    HttpManager.getInstance().get("/api/v1/categories/name",
        params: {"categoryName": categoryName}).then((value) {
      if (value != "") {
        _currentCategory = JsonConvert.fromJsonAsT(value);
      } else {
        _currentCategory = CategoryRecord();
        _currentCategory.categoryName = categoryName;
        _currentCategory.dictEntries = _packageModes;
      }
      var other = DictEntryRecord();
      other.dictEntryName = "其他";
      _currentCategory.dictEntries.add(other);
      setState(() {
        _buildType = 3;
      });
    });
  }
}


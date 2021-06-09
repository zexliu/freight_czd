import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/widget/select_button.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class DeliverRemark extends StatefulWidget {
  final Function onChanged;

  final List<String>selectedList;
  DeliverRemark({this.onChanged, this.remark,this.selectedList});

  final String remark;

  @override
  _DeliverRemarkState createState() => _DeliverRemarkState();
}

class _DeliverRemarkState extends State<DeliverRemark> {
  FocusNode _remarkNode = FocusNode();

  TextEditingController _textController;

  List<DictEntryRecord> _requireList = [];
  List<String> _selectedList = [];

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _remarkNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.text = widget.remark;
    if(widget.selectedList != null){
      this._selectedList = widget.selectedList;
    }
    fetchDict("delivery_require").then((value) => {
      this.setState(() {
        _requireList = value.records;
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              "服务要求和备注",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                widget.onChanged(_selectedList,_textController.text);
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
            config: _buildConfig(context),
            autoScroll: true,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    focusNode: _remarkNode,
                    controller: _textController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    minLines: 3,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 16),
                    maxLength: 50,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintStyle: TextStyle(fontSize: 16),
                      contentPadding: EdgeInsets.all(10),
                      hintText: "请输入详细地址",
                      counterText: "${_textController.text.length} / 50",
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Text("特殊要求"),
                  SizedBox(
                    height: 8,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _requireList.length,
                    itemBuilder: (BuildContext context, int position) {
                      var item = _requireList[position];
                      String find = _selectedList.firstWhere((element) {
                        return element == item.dictEntryName;
                      }, orElse: () {
                        return null;
                      });
                      return SelectButton(
                        text: item.dictEntryName,
                        isSelected: find != null,
                        onTap: () {
                          setState(() {
                            if (find != null) {
                              _selectedList.remove(find);
                            } else {
                              _selectedList.add(item.dictEntryName);
                            }
                          });
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/select_button.dart';

class LoadUnloadPicker extends StatefulWidget {
  final String loadUnload;
  final Function onChanged;


  LoadUnloadPicker({Key key,this.loadUnload,@required this.onChanged}):super(key:key);

  @override
  _LoadUnloadPickerState createState() => _LoadUnloadPickerState();
}

class _LoadUnloadPickerState extends State<LoadUnloadPicker> {
  List<DictEntryRecord> _loadUnloads;

  String _currentLoadUnload;
  bool _isLoading = true;
  @override
  void initState() {
    if(widget.loadUnload != null){
      _currentLoadUnload = widget.loadUnload;
    }
    fetchDict("load_unload").then((value){
      setState(() {
        _loadUnloads = value.records;
        _isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading ?  Center(child: CircularProgressIndicator(),):_buildContent(),
    );
  }

  _buildContent() {
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
                "几装几卸",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_currentLoadUnload == null ) {
                    Toast.show("请选择几装几卸");
                    return;
                  }
                  widget.onChanged(_currentLoadUnload);
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
          SizedBox(height: 16,),
          Expanded(
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    physics:
                    NeverScrollableScrollPhysics(),
                    itemCount:  _loadUnloads.length,
                    itemBuilder: (BuildContext context,
                        int position) {
                      var item = _loadUnloads[position];
                      return SelectButton(
                        text: item.dictEntryName,
                        isSelected: item.dictEntryName == _currentLoadUnload,
                        onTap: () {
                          setState(() {
                            _currentLoadUnload = item.dictEntryName;
                          });
                        },
                      );
                    },
                  ),
                ],
            ),
          )
        ],
      ),
    );
  }
}

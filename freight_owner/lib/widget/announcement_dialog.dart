import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/announcement_entity.dart';

class AnnouncementDialog extends StatefulWidget {

  final String id;
  AnnouncementDialog(this.id);

  @override
  _AnnouncementDialogState createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<AnnouncementDialog> {

  Future<AnnouncementRecords> _future;
  @override
  void initState() {
    super.initState();
    _future =  _fetch();
  }

  String _title = "";

  Future<AnnouncementRecords> _fetch() async {
    var json = await HttpManager.getInstance().get("/api/v1/announcements/${widget.id}");
     var fromJson = AnnouncementRecords().fromJson(json);
    setState(() {
      _title = fromJson.title;
    });
     return fromJson;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(_title),
        automaticallyImplyLeading: false,
      ) ,

      body: FutureBuilder<AnnouncementRecords>(
        future: _future,
        builder: (c,s){
          if(s.connectionState == ConnectionState.done){
            if(s.hasError){
              return Text(s.error.toString());
            }else{
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Html(
                    data: s.data.content,
                  ),
                ),
              );
            }
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );



  }
}

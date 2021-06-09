

import 'package:flutterdriver/model/dict_entry_entity.dart';

import 'http.dart';

Future<DictEntryEntity> fetchDict(String dictCode) async{
   var json = await HttpManager.getInstance().get("/api/v1/dict/entries",params: {"dictCode": dictCode,"current":1,"size":9999});
   return DictEntryEntity().fromJson(json);
}

import 'package:shared_preferences/shared_preferences.dart';

class DefaultSharedPreferences {
  static DefaultSharedPreferences _instance =
      DefaultSharedPreferences._internal();

  SharedPreferences _sharedPreferences;

  static DefaultSharedPreferences getInstance() {
    return _instance;
  }

  factory DefaultSharedPreferences() => _instance;

  DefaultSharedPreferences._internal() {
    if (null == _sharedPreferences) {
      Future<SharedPreferences> _future = SharedPreferences.getInstance();
      _future.then((value) {
        print("获取到 _sharedPreferences");
        this._sharedPreferences = value;
      });
    }
  }

  put(key, value) {
    _sharedPreferences.setString(key, value);
  }

  get(key) {
    return _sharedPreferences.get(key);
  }

  List<String> getList(key){
    return _sharedPreferences.getStringList(key);
  }
  setList(key,value){
    return _sharedPreferences.setStringList(key,value);
  }
  remove(key) {
    _sharedPreferences.remove(key);
  }
}

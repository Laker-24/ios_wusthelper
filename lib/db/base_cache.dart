/*

    统一缓存管理
 
 */

import 'package:shared_preferences/shared_preferences.dart';

class BaseCache {
  SharedPreferences prefs;
  static BaseCache _instance;
  // 构造函数，_()的写法使BaseCache类不可在外部被实例化
  BaseCache._() {
    init();
  }

  BaseCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  /// 预初始化
  static Future<BaseCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = BaseCache._pre(prefs);
    }
    return _instance;
  }

  // 单例写法，当单例不存在时进行构造，否则返回已有的实例
  static BaseCache getInstance() {
    if (_instance == null) {
      _instance = BaseCache._();
    }
    return _instance;
  }

  init() async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  setString(String key, String value) {
    prefs.setString(key, value);
    return this;
  }

  setStringList(String key, List<String> value) {
    prefs.setStringList(key, value);
    return this;
  }

  setInt(String key, int value) {
    prefs.setInt(key, value);
    return this;
  }

  setDouble(String key, double value) {
    prefs.setDouble(key, value);
    return this;
  }

  setBool(String key, bool value) {
    prefs.setBool(key, value);
    return this;
  }

  T get<T>(String key) {
    return prefs?.get(key) ?? null;
  }

  List<String> getStringList(String key) {
    return prefs.getStringList(key) ?? [];
  }

  clear() {
    prefs?.clear();
  }
}

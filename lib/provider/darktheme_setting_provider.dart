import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class DarkThemeSettingProvider extends ChangeNotifier {
  int _darkMode; //黑夜模式 0为跟随系统1为浅色模式2为深色模式
  int get darkMode {
    _darkMode = BaseCache.getInstance().get(LhConst.darkMode) ?? 0;
    return _darkMode;
  }

  ThemeMode get themeMode {
    _darkMode = BaseCache.getInstance().get(LhConst.darkMode) ?? 0;
    if (_darkMode == 0)
      return ThemeMode.system;
    else if (_darkMode == 1)
      return ThemeMode.light;
    else
      return ThemeMode.dark;
  }

  setMode(int mode) {
    // _darkMode = mode;
    BaseCache.getInstance().setInt(LhConst.darkMode, mode);
    _darkMode = mode;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class ScheduleProvider extends ChangeNotifier {
  bool _isCartoonBg;
  bool getIsCartoonBg() {
    _isCartoonBg =
        BaseCache.getInstance().get<bool>(ScheduleConst.isCartoonBg) ?? false;
    return _isCartoonBg;
  }

  setIsCartoonBg(bool isCartoon) {
    BaseCache.getInstance().setBool(ScheduleConst.isCartoonBg, isCartoon);
    notifyListeners();
  }
}

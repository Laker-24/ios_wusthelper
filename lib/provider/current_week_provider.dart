import 'package:flutter/cupertino.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/time_util.dart';

class CurrentWeekProvider extends ChangeNotifier {
  //获取当前时间
  int _now;
  //获取当前周数
  int _currentWeek;
  //是青山还是黄家湖校区
  bool _isLakeArea = true;
  bool _currentMondayTime;
  //锚点
  int _anchorPoint;
  int _anchorPointWeek;

  int get now => _now ?? DateTime.now().millisecondsSinceEpoch;

  int get currentWeek {
    if (_currentWeek == null) {
      _currentWeek = caculateCurrentWeek(getAnchorPoint(), getAnchorPointWeek(),
          isMonday: currentWeekIsMonday());
    }
    return _currentWeek;
  }

  //是否设置当前周为周一(默认周一为一周的开始)
  bool currentWeekIsMonday() {
    _currentMondayTime =
        BaseCache.getInstance().get(ScheduleConst.currentMondayTime) ?? true;
    return _currentMondayTime;
  }

  setCurrentWeek(int newCurrent) {
    _currentWeek = newCurrent;
    notifyListeners();
  }

  setNow(int now) {
    _now = now;
    notifyListeners();
  }

  setCurrentWeekIsMonday(bool value) {
    BaseCache.getInstance().setBool(ScheduleConst.currentMondayTime, value);
    notifyListeners();
  }

  bool getIsLakeArea() {
    _isLakeArea = BaseCache.getInstance().get(ScheduleConst.isLakeArea) ?? true;
    return _isLakeArea;
  }

  setIsLakeArea(bool isLakeArea) {
    BaseCache.getInstance().setBool(ScheduleConst.isLakeArea, isLakeArea);
    notifyListeners();
  }

  int getAnchorPoint() {
    _anchorPoint = BaseCache.getInstance().get(ScheduleConst.anchorPoint);
    return _anchorPoint;
  }

  setAnchorPoint(int anchorPoint) {
    BaseCache.getInstance().setInt(ScheduleConst.anchorPoint, anchorPoint);
    notifyListeners();
  }

  int getAnchorPointWeek() {
    _anchorPointWeek =
        BaseCache.getInstance().get(ScheduleConst.anchorPointWeek);
    return _anchorPointWeek;
  }

  setAnchorPointWeek(int anchorPointWeek) {
    BaseCache.getInstance()
        .setInt(ScheduleConst.anchorPointWeek, anchorPointWeek);
    notifyListeners();
  }
}

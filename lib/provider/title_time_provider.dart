import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class TitleTimeProvider extends ChangeNotifier {
  List<String> _titleTime;
  //若处于假期，返回-1
  int _currentWeekday = -1;

  List<String> get titleTime {
    return _titleTime;
  }

  setTitleTime(int diff, DateTime mondayTime) {
    _titleTime = [];

    for (int i = 0; i < 7; i++) {
      _titleTime.add(
          mondayTime.add(Duration(days: i + 7 * diff)).month.toString() +
              "/" +
              (mondayTime.add(Duration(days: i + 7 * diff))).day.toString());
    }
    notifyListeners();
  }

  initTitleTime(DateTime mondayTime) {
    _titleTime = [];

    for (int i = 0; i < 7; i++) {
      _titleTime.add(mondayTime.add(Duration(days: i)).month.toString() +
          "/" +
          (mondayTime.add(Duration(days: i))).day.toString());
    }
  }

  int get currentWeekday {
    return _currentWeekday;
  }

  setCurrentWeekday(int current) {
    _currentWeekday = current;
    notifyListeners();
  }

  initCurrentWeekday(int current) {
    _currentWeekday = current;
  }
}

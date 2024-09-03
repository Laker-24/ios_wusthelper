import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class BackgroundSettingProvider extends ChangeNotifier {
  double _transparency; //透明度

  setTrans(double trans) {
    BaseCache.getInstance().setDouble(LhConst.transparency, trans);
    notifyListeners();
  }

  double getTrans() {
    _transparency = BaseCache.getInstance().get(LhConst.transparency);
    return _transparency ?? 0.0;
  }

  //查看背景图片是否为全屏
  setisFull(bool value) {
    BaseCache.getInstance().setBool(LhConst.isFullScreen, value);
    notifyListeners();
  }

  bool get isFullScreen =>
      BaseCache.getInstance().get(LhConst.isFullScreen) ?? false;
  //图片的文件路径
  setPath(path) {
    BaseCache.getInstance().setString(LhConst.imagePath, path);
    notifyListeners();
  }

  get imagePath => BaseCache.getInstance().get(LhConst.imagePath) ?? null;

  //查看是否存在背景图片
  setAddImage(bool value) {
    BaseCache.getInstance().setBool(LhConst.isAddImage, value);
    notifyListeners();
  }

  bool get isAddImage =>
      BaseCache.getInstance().get(LhConst.isAddImage) ?? false;
}

/*
 *
 *          封装分页的逻辑处理
 *          结合getx使用 
 *          抽象出来方便以后需要分页的模块使用
 */

import 'package:flutter/foundation.dart';
import 'package:wust_helper_ios/model/library_model/library_search_model.dart';

///T:实体类
///S:PagingState
///M:对应model
class PagingController extends ChangeNotifier {
  String keyword = "";
  LibrarySearchModel model;

  ///  封装保存分页状态数据及列表数据
  ///分页的页数
  int pageIndex = 1;

  ///是否还有更多数据
  bool hasMore = true;

  ///列表数据
  List<SearchBook> data = [];

  ///是否初始化了数据(输入了内容后点击确定)
  bool isInitData = false;
  //get方法
  String get getkeyword => keyword;
  bool get isInit => isInitData;
  bool get ishasMore => hasMore;
  int get pageNum => pageIndex;
  //初始状态，当前页数为1，可上拉加载，
  initState() {
    pageIndex = 1;
    hasMore = true;
    data.clear();
  }

  initKeyWord(String keyword) {
    this.keyword = keyword;

    notifyListeners();
  }

  addData(List<SearchBook> list) {
    this.data.addAll(list);
    notifyListeners();
  }

  loadData() {
    pageIndex += 1;
    notifyListeners();
  }

  setHasMore() {
    this.hasMore = false;
    notifyListeners();
  }

  setIsInitData(bool value) {
    isInitData = value;
    notifyListeners();
  }
}

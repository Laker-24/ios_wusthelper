/*
*       图书馆相关网络请求逻辑
*/

import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/http/request/library_request/library_add_collection_request.dart';
import 'package:wust_helper_ios/model/library_model/library_get_book_detail_model.dart';
import 'package:wust_helper_ios/model/library_model/library_get_current_rent_model.dart';
import 'package:wust_helper_ios/model/library_model/library_get_rent_history_model.dart';
import 'package:wust_helper_ios/model/library_model/library_list_anno_model.dart';
import 'package:wust_helper_ios/model/library_model/library_list_collection_model.dart';
import 'package:wust_helper_ios/model/library_model/library_search_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/request_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

String token = BaseCache.getInstance().get(JwcConst.token);
//图书馆登陆
Future<bool> libraryLogin(String password) async {
  var result;
  try {
    result = await JwcDao.libraryLogin(token, password);
    showToast(result['msg']);
    return isSuccessful(result);
  } catch (e) {
    showToast("登陆失败，请重新尝试～");
  }
  return false;
}

//获取图书馆公告列表
Future<List<Anno>> getLibraryListAnno(
    {int pageNum = 1, int pageSize = 0}) async {
  List<Anno> _list = [];
  try {
    var result;
    result = await JwcDao.getLibraryListAnno(token,
        pageNum: pageNum, pageSize: pageSize);

    LibraryListAnnoModel libraryListAnnoModel =
        LibraryListAnnoModel.fromJson(result);
    _list = libraryListAnnoModel.data;
  } catch (e) {
    // showToast("加载失败～");
  }
  return _list;
}

//获取图书馆公告详细通知
Future<String> getLibraryAnnoDetailsUrl(int announcementId) async {
  String url;
  try {
    var result;
    result = await JwcDao.getLibraryAnnoDetails(token, announcementId);
    url = result['data'];
  } catch (e) {
    print(e);
  }
  return url;
}

//获取图书馆收藏列表
Future<List<LibraryCollection>> getLibraryListCollection(
    {int pageNum, int pageSize}) async {
  List<LibraryCollection> _list = [];
  try {
    var result;
    result = await JwcDao.getLibraryListCollection(token);
    LibraryListCollectionModel libraryListCollectionModel =
        LibraryListCollectionModel.fromJson(result);
    if (libraryListCollectionModel.code == 40002 ||
        libraryListCollectionModel.code == 40001) {
      showToast(libraryListCollectionModel.msg);
      BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryLogin);
      return null;
    }
    _list = libraryListCollectionModel.data;
  } catch (e) {
    showToast("收藏加载失败～");
  }
  return _list;
}

///获取我的当前借阅信息
Future<List<CurrentRentBook>> getLibraryRentCurrent() async {
  List<CurrentRentBook> _list = [];
  try {
    var result;
    result = await JwcDao.getLibraryRentCurrent(token);

    LibraryGetCurrentRentModel libraryGetCurrentRentModel =
        LibraryGetCurrentRentModel.fromJson(result);
    if (libraryGetCurrentRentModel.code == 40002 ||
        libraryGetCurrentRentModel.code == 40001) {
      showToast(libraryGetCurrentRentModel.msg);
      BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryLogin);
      return null;
    }
    _list = libraryGetCurrentRentModel.data;
  } catch (e) {
    // showToast("收藏加载失败～");
  }
  return _list;
}

///获取我的历史借阅信息
Future<List<HitsoryRentBook>> getLibraryRentHistory() async {
  List<HitsoryRentBook> _list = [];
  try {
    var result;
    result = await JwcDao.getLibraryRentHistory(token);
    LibraryGetRentHistoryModel libraryGetRentHistoryModel =
        LibraryGetRentHistoryModel.fromJson(result);
    if (libraryGetRentHistoryModel.code == 40002 ||
        libraryGetRentHistoryModel.code == 40001) {
      showToast(libraryGetRentHistoryModel.msg);
      BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryLogin);
      return null;
    }
    _list = libraryGetRentHistoryModel.data;
  } catch (e) {
    print(e);
  }
  return _list;
}

///获取该图书详情
Future<LibraryGetBookDetailModel> getLibraryBookDetail(String url) async {
  LibraryGetBookDetailModel model;
  try {
    var result;
    result = await JwcDao.getLibraryBookDetail(token, url);
    LibraryGetBookDetailModel libraryGetBookDetailModel =
        LibraryGetBookDetailModel.fromJson(result);
    if (libraryGetBookDetailModel.code == 40002 ||
        libraryGetBookDetailModel.code == 40001) {
      showToast(libraryGetBookDetailModel.msg);
      BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryLogin);
      return LibraryGetBookDetailModel();
    }
    model = libraryGetBookDetailModel;
  } catch (e) {
    print(e);
  }
  return model;
}

///搜索图书
Future<LibrarySearchModel> getLibrarySearch(String keyWord,
    {int pageNum = 1, int pageSize = 10}) async {
  LibrarySearchModel librarySearchModel;
  try {
    var result = await JwcDao.getLibrarySearch(token, keyWord,
        pageNum: pageNum, pageSize: pageSize);

    librarySearchModel = LibrarySearchModel.fromJson(result);
    if (librarySearchModel.code == 40002 || librarySearchModel.code == 40001) {
      showToast(librarySearchModel.msg);
      BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryLogin);
      return null;
    }
  } catch (e) {
    print(e);
  }
  return librarySearchModel;
}

///收藏图书
Future<bool> addLibraryCollection(String title, String isbn, String author,
    String publisher, String detailUrl) async {
  bool isSuccessful = false;
  try {
    var result = await JwcDao.libraryAddCollection(
        token, title, isbn, author, publisher, detailUrl);

    if (result['code'] == 10000 || result['code'] == 10001) {
      showToast("收藏成功");
      isSuccessful = true;
    } else {
      showToast(result['msg']);
    }
  } catch (e) {
    print(e);
  }
  return isSuccessful;
}

///取消收藏
Future<bool> delLibraryCollection(String isbn) async {
  bool isSuccessful = false;
  try {
    var result = await JwcDao.libraryDelCollection(token, isbn);
    if (result['code'] == 10000 || result['code'] == 10001) {
      showToast(result['msg']);
      isSuccessful = true;
    } else {
      showToast(result['msg']);
    }
  } catch (e) {
    print(e);
  }
  return isSuccessful;
}

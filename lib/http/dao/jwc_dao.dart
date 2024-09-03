/*


 
    教务处 DAO 层
 


 */

import 'dart:convert';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/core/hi_net.dart';
import 'package:wust_helper_ios/http/request/admin_notice_request.dart';
import 'package:wust_helper_ios/http/request/admin_time_request.dart';
import 'package:wust_helper_ios/http/request/banner_request.dart';
import 'package:wust_helper_ios/http/request/base_request.dart';
import 'package:wust_helper_ios/http/request/check_token_request.dart';
import 'package:wust_helper_ios/http/request/countdown_request/countdown_add_request.dart';
import 'package:wust_helper_ios/http/request/countdown_request/countdown_del_request.dart';
import 'package:wust_helper_ios/http/request/countdown_request/countdown_list_request.dart';
import 'package:wust_helper_ios/http/request/countdown_request/countdown_modify_request.dart';
import 'package:wust_helper_ios/http/request/countdown_request/countdown_shared_request.dart';

import 'package:wust_helper_ios/http/request/graduate_student_request/graduate_stu_grade_request.dart';
import 'package:wust_helper_ios/http/request/graduate_student_request/graduate_stu_info_request.dart';
import 'package:wust_helper_ios/http/request/graduate_student_request/graduate_stu_login_request.dart';
import 'package:wust_helper_ios/http/request/graduate_student_request/graduate_stu_schedule_request.dart';
import 'package:wust_helper_ios/http/request/graduate_student_request/graduate_stu_training_request.dart';
import 'package:wust_helper_ios/http/request/jwc_combine_request.dart';
import 'package:wust_helper_ios/http/request/jwc_credit_request.dart';
import 'package:wust_helper_ios/http/request/jwc_grade_request.dart';
import 'package:wust_helper_ios/http/request/jwc_info_request.dart';
import 'package:wust_helper_ios/http/request/jwc_login_request.dart';
import 'package:wust_helper_ios/http/request/jwc_schedule_request.dart';
import 'package:wust_helper_ios/http/request/jwc_training_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_add_collection_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_del_collection_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_get_anno_content_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_get_book_detail_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_get_current_rent_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_get_history_rent_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_list_anno_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_list_collection_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_login_request.dart';
import 'package:wust_helper_ios/http/request/library_request/library_search_request.dart';
import 'package:wust_helper_ios/http/request/lost_tips_request.dart';
import 'package:wust_helper_ios/http/request/version_requset.dart';
import 'package:wust_helper_ios/http/request/wlsy_request/wlsy_login_request.dart';
import 'package:wust_helper_ios/http/request/wlsy_request/wlsy_schedule_request.dart';

import 'package:wust_helper_ios/model/admin_time_model.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/login_util.dart';
import 'package:wust_helper_ios/util/time_util.dart';

const String CONTENT_TYPE = "application/x-www-form-urlencoded"; //请求数据格式
const String PLATFORM = "ios";

/// 需要获取的数据类型
enum RequestType {
  COMBINE,
  INFO,
  GRADE,
  SCHEDULE,
  TIME,
  CREDIT,
  TRAINING,
  //管理端
  CHECK_TOKEN,
  NOTICE,
  VERSION,
  BANNER,
  //倒计时
  COUNTDOWN_ADD,
  COUNTDOWN_LIST,
  COUNTDOWN_SHARED,
  COUNTDOWN_MODIFY,
  COUNTDOWN_DEL,
  //研究生
  GRADUATE_STU_LOGIN,
  GRADUATE_STU_SCHEDULE,
  GRADUATE_STU_INFO,
  GRADUATE_STU_GRADE,
  GRADUATE_STU_TRAINGING,
  //物理实验
  WlSY_LOGIN,
  WLSY_SCHEDULE,
  //图书馆
  LIBRARY_LOGIN,
  LiBRARY_LIST_ANNO,
  LIBRARY_ANNO_CONTENT,
  LIBRARY_LIST_COLLECTION,
  LIBRARY_RENT_CURRENT,
  LIBRARY_RENT_HISTORY,
  LIBRARY_BOOK_DETAIL,
  LIBRARY_SEARCH_BOOK,
  LIBRARY_ADD_COLLECTION,
  LIBRARY_DEL_COLLECTION,
  //失物招领
  LOST_UN_READ,
  LOST_READ,
}

class JwcDao {
  ///[本科生相关]
  /// 结合登陆
  static combineLogin(String stuNum, String jwcPwd) async {
    return _send(stuNum: stuNum, jwcPwd: jwcPwd, type: RequestType.COMBINE);
  }

  static commonLogin(String stuNum, String jwcPwd) async {
    return _send(stuNum: stuNum, jwcPwd: jwcPwd);
  }

  /// 获取学生信息
  static getInfo(String token) {
    return _send(token: token, type: RequestType.INFO);
  }

  /// 获取成绩
  static getGrade(String token) {
    return _send(token: token, type: RequestType.GRADE);
  }

  /// 获取课程表
  static getSchedule(String token, {Map args}) {
    return _send(token: token, type: RequestType.SCHEDULE, args: args);
  }

  /// 获取学分统计html
  static getCredit(String token) {
    return _send(token: token, type: RequestType.CREDIT);
  }

  /// 获取培养方案html
  static getTraining(String token) {
    return _send(token: token, type: RequestType.TRAINING);
  }

  ///[管理端相关]
  /// 获取时间信息
  static getSchoolTime() {
    return _send(type: RequestType.TIME);
  }

  /// 监察token是否过期
  static checkToken() {
    return _send(type: RequestType.CHECK_TOKEN);
  }

  /// 获取管理端公告
  static getNotice(String token) {
    return _send(token: token, type: RequestType.NOTICE);
  }

  /// 获取版本信息
  static getVersion(String token) {
    return _send(token: token, type: RequestType.VERSION);
  }

  ///获取轮播图
  static getBanner(String token) {
    return _send(token: token, type: RequestType.BANNER);
  }

  ///[与倒计时有关]
  //添加
  static addCountdown(String token, Map addCountdownArgs) {
    return _send(
        token: token, type: RequestType.COUNTDOWN_ADD, args: addCountdownArgs);
  }

  //修改
  static modifyCountdown(String token, Map modifyCountdownArgs) {
    return _send(
        token: token,
        type: RequestType.COUNTDOWN_MODIFY,
        args: modifyCountdownArgs);
  }

  //查询
  static listCountdown(String token) {
    return _send(token: token, type: RequestType.COUNTDOWN_LIST);
  }

  //删除
  static delCountdown(String token, Map delCountdownArgs) {
    return _send(
        token: token, type: RequestType.COUNTDOWN_DEL, args: delCountdownArgs);
  }

  //分享
  static sharedCountdown(String token, Map sharedCountdownArgs) {
    return _send(token: token, type: RequestType.COUNTDOWN_SHARED);
  }

  ///[研究生相关]
  //登陆
  static graduateStuLogin(String stuNum, String jwcPwd) {
    return _send(
        jwcPwd: jwcPwd, stuNum: stuNum, type: RequestType.GRADUATE_STU_LOGIN);
  }

  //课表
  static graduateStuSchedule(String token) {
    return _send(token: token, type: RequestType.GRADUATE_STU_SCHEDULE);
  }

  //个人信息
  static graduateStuInfo(String token) {
    return _send(token: token, type: RequestType.GRADUATE_STU_INFO);
  }

  //成绩
  static graduateStuGrade(String token) {
    return _send(token: token, type: RequestType.GRADUATE_STU_GRADE);
  }

  //培养方案
  static graduateStuTraining(String token) {
    return _send(token: token, type: RequestType.GRADUATE_STU_TRAINGING);
  }

  ///[物理实验相关]
  //登陆
  static wlsyLogin(String token, String stuPwd) {
    return _send(token: token, jwcPwd: stuPwd, type: RequestType.WlSY_LOGIN);
  }

  //课表
  static wlsySchedule(String token) {
    return _send(token: token, type: RequestType.WLSY_SCHEDULE);
  }

  ///[图书馆相关]

  //登陆
  static libraryLogin(String token, String password) {
    return _send(
        token: token,
        args: {LibraryConst.libPwd: password},
        type: RequestType.LIBRARY_LOGIN);
  }

  //图书馆通知列表
  static getLibraryListAnno(String token, {int pageNum, int pageSize}) {
    return _send(
      token: token,
      type: RequestType.LiBRARY_LIST_ANNO,
      args: {"pageNum": pageNum, "pageSize": pageSize},
    );
  }

  //图书馆通知详细
  static getLibraryAnnoDetails(String token, int announcementId) {
    return _send(
      token: token,
      type: RequestType.LIBRARY_ANNO_CONTENT,
      args: {"announcementId": announcementId},
    );
  }

  //收藏列表
  static getLibraryListCollection(String token, {int pageNum, int pageSize}) {
    return _send(token: token, type: RequestType.LIBRARY_LIST_COLLECTION);
  }

  //获取本人当前借阅信息
  static getLibraryRentCurrent(String token) {
    return _send(token: token, type: RequestType.LIBRARY_RENT_CURRENT);
  }

  //获取本人历史借阅信息
  static getLibraryRentHistory(String token) {
    return _send(token: token, type: RequestType.LIBRARY_RENT_HISTORY);
  }

  //获取图书详情页面
  static getLibraryBookDetail(String token, String url) {
    return _send(
        token: token,
        args: {"url": url},
        type: RequestType.LIBRARY_BOOK_DETAIL);
  }

  //搜索图书
  static getLibrarySearch(String token, String keyWord,
      {int pageNum, int pageSize}) {
    return _send(
        token: token,
        args: {
          "keyWord": keyWord,
          "pageNum": pageNum,
          "pageSize": pageSize,
        },
        type: RequestType.LIBRARY_SEARCH_BOOK);
  }

  //收藏图书
  static libraryAddCollection(String token, String title, String isbn,
      String author, String publisher, String detailUrl) {
    return _send(token: token, type: RequestType.LIBRARY_ADD_COLLECTION, args: {
      "title": title,
      "isbn": isbn,
      "author": author,
      "publisher": publisher,
      "detailUrl": detailUrl,
    });
  }

  ///取消收藏图书
  static libraryDelCollection(String token, String isbn) {
    return _send(
        token: token,
        type: RequestType.LIBRARY_DEL_COLLECTION,
        args: {"isbn": isbn});
  }

  ///获取失物招领的弹窗
  static getLostTipsUnRead(String token) {
    return _send(token: token, type: RequestType.LOST_UN_READ);
  }

  static getLostTipsRead(String token) {
    return _send(token: token, type: RequestType.LOST_UN_READ);
  }
}

/// 可复用创建请求逻辑
_send(
    {String stuNum,
    String jwcPwd,
    String token,
    RequestType type,
    Map args}) async {
  BaseRequest request;
  if (type == RequestType.COMBINE || type == null) {
    if (type == RequestType.COMBINE) {
      /// 登陆时需要刷新当前学期
      try {
        AdminTimeData data = await refreshSchoolTime();
        request = JwcCombineRequest().add(JwcConst.term, data.currentTerm);
      } catch (e) {
        throw e;
      }
    } else {
      request = JwcLoginRequest();
    }
    request.add(ConstList.STU_NUM, stuNum).add(ConstList.JWC_PWD, jwcPwd);
  } else {
    switch (type) {

      ///[本科生相关]
      case RequestType.INFO:
        request = JwcInfoRequest();
        break;
      case RequestType.GRADE:
        request = JwcGradeRequest();
        break;
      case RequestType.SCHEDULE:
        request = JwcSchedulerequest();

        /// 获取课表时需要刷新当前学期
        //  初次登陆需要我们判断当前学期
        if (args[JwcConst.currentTerm] == null) {
          AdminTimeData data = await refreshSchoolTime();
          request.add(JwcConst.schoolTerm, data.currentTerm);
        }
        //用户自行切换课表
        else {
          request.add(JwcConst.schoolTerm, args[JwcConst.currentTerm]);
        }

        break;
      case RequestType.TIME:
        request = AdminTimeRequest();
        request.addHeaders("Platform", PLATFORM);
        break;
      //学分统计，暂时舍弃
      case RequestType.CREDIT:
        request = JwcCreditRequest();
        break;
      case RequestType.TRAINING:
        request = JwcTrainingRequest();
        break;

      ///[管理端相关]
      case RequestType.CHECK_TOKEN:
        request = CheckTokenRequest();
        // 如果验证token需要登陆则会造成死循环
        // 故应手动添加token
        token = await BaseCache.getInstance().get(JwcConst.token);
        request.addHeaders(JwcConst.token, token);
        break;
      case RequestType.NOTICE:
        request = AdminNoticeRequest();
        request
            // .addHeaders("Content-type", CONTENT_TYPE)
            .addHeaders("Platform", PLATFORM);
        break;
      case RequestType.VERSION:
        request = VersionRequest();
        request
            // .addHeaders("Content-type", CONTENT_TYPE)
            .addHeaders("Platform", PLATFORM);
        break;
      case RequestType.BANNER:
        request = BannerRequest();
        request
            .addHeaders("Content-type", CONTENT_TYPE)
            .addHeaders("Platform", PLATFORM);
        break;

      ///[失物招领]
      case RequestType.LOST_UN_READ:
        request = LostTipsUnReadRequest();
        break;
      case RequestType.LOST_READ:
        request = LostTipsReadRequest();
        break;

      ///[倒计时相关]
      case RequestType.COUNTDOWN_ADD:
        request = CountdownAddRequest();
        request
            .add(LhConst.countdownCourseName, args['name'])
            .add(LhConst.countdownNotes, args['comment'])
            .add(LhConst.countdownExamTime, args['time']);
        break;
      case RequestType.COUNTDOWN_DEL:
        request = CountdownDelRequest();
        request.add(LhConst.uuid, args['uuid']);

        break;
      case RequestType.COUNTDOWN_SHARED:
        request = CountdownSharedRequest();
        request.add(LhConst.uuid, args['uuid']);
        break;
      case RequestType.COUNTDOWN_MODIFY:
        request = CountdownModifyRequest();
        request
            .add(LhConst.countdownCourseName, args["name"])
            .add(LhConst.countdownExamTime, args['time'])
            .add(LhConst.countdownNotes, args['comment'])
            .add(LhConst.uuid, args['uuid']);
        break;
      case RequestType.COUNTDOWN_LIST:
        request = CountdownListRequest();
        break;

      ///[研究生相关]
      case RequestType.GRADUATE_STU_LOGIN:
        request = GraduateStuLoginRequest();
        request.add(ConstList.STU_NUM, stuNum).add(ConstList.JWC_PWD, jwcPwd);

        break;
      case RequestType.GRADUATE_STU_GRADE:
        request = GraduateStuGradeRequest();
        break;
      case RequestType.GRADUATE_STU_INFO:
        request = GraduateStuInfoRequest();
        break;

      case RequestType.GRADUATE_STU_SCHEDULE:
        request = GraduateStuScheduleRequest();

        /// 获取课表时需要刷新当前学期
        AdminTimeData data = await refreshSchoolTime();
        request.add(JwcConst.schoolTerm, data.currentTerm);
        break;
      case RequestType.GRADUATE_STU_TRAINGING:
        request = GraduateStuTrainingRequest();
        break;

      ///[物理实验]
      case RequestType.WlSY_LOGIN:
        request = WlsyRequest();
        request.add(ConstList.WLSY_PWD, jwcPwd);
        break;
      case RequestType.WLSY_SCHEDULE:
        request = WlsyScheduleRequest();
        break;

      ///[图书馆]
      //登陆
      case RequestType.LIBRARY_LOGIN:
        request = LibraryLoginRequest();
        request.add(LibraryConst.libPwd, args[LibraryConst.libPwd]);
        break;
      //通知列表
      case RequestType.LiBRARY_LIST_ANNO:
        request = LibraryListAnnoRequest();
        request.add('pageNum', args['pageNum']);
        request.add('pageSize', args['pageSize']);
        break;
      //通知详情
      case RequestType.LIBRARY_ANNO_CONTENT:
        request = LibraryGetAnnoContentRequest();
        request.add('announcementId', args['announcementId']);
        break;
      //我的收藏
      case RequestType.LIBRARY_LIST_COLLECTION:
        request = LibraryListCollectionRequest();
        break;
      //当前借阅
      case RequestType.LIBRARY_RENT_CURRENT:
        request = LibraryGetCurrentRentRequest();
        break;
      //历史借阅
      case RequestType.LIBRARY_RENT_HISTORY:
        request = LibraryGetHistoryRentRequest();
        break;
      //图书详情
      case RequestType.LIBRARY_BOOK_DETAIL:
        request = LibraryGetBookDetailRequest();
        request.add('url', args['url']);
        break;
      //搜索图书
      case RequestType.LIBRARY_SEARCH_BOOK:
        request = LibrarySearchRequest();
        request.add('keyWord', args['keyWord']);
        request.add('pageNum', args['pageNum']);
        request.add('pageSize', args['pageSize']);
        break;
      //收藏图书
      case RequestType.LIBRARY_ADD_COLLECTION:
        request = LibraryAddCollectionRequest();
        request.add("title", args['title'])
          ..add("isbn", args['isbn'])
          ..add("author", args['author'])
          ..add("publisher", args['publisher'])
          ..add("detailUrl", args['detailUrl']);
        break;
      //取消收藏
      case RequestType.LIBRARY_DEL_COLLECTION:
        request = LibraryDelCollectionRequest();
        request.add("isbn", args['isbn']);
        break;
      default:
        throw Exception("请求类型不存在");
    }
  }

  /// 确定是否携带 token
  if (request.needLogin()) {
    // 检查token是否过期
    token = await checkToken() ?? token;
    request.addHeaders(JwcConst.token, token);
  }
  // print(token);
  var result = await HiNet.getInstance().fire(request);

  /// 确定是否保存 token (主要是登录请求后进行保存)
  if ((result["code"] == 10000 || result['code'] == 70000) &&
      result["data"] != null &&
      (type == null ||
          type == RequestType.COMBINE ||
          type == RequestType.GRADUATE_STU_LOGIN)) {
    (type == null || type == RequestType.GRADUATE_STU_LOGIN)
        ? TokenProvider().setToken(result["data"])
        : TokenProvider().setToken(result["data"]["token"]);
    print("token已保存");
  }
  return result;
}

//刷新学期课表
Future<AdminTimeData> refreshSchoolTime() async {
  //得到开学时间（管理端自行设置，不要忘记）
  var result = await JwcDao.getSchoolTime();
  AdminTimeData data = AdminTime.fromJson(result).data;
  setSchoolTime(data);
  //当前学期  示例：2020-2021-2
  String time = data.termSetting[data.currentTerm];
  List<int> beginTime = time.split('-').map((e) => int.parse(e)).toList();
  await initAnchorPoint(DateTime(beginTime[0], beginTime[1], beginTime[2])
      .millisecondsSinceEpoch);
  //保存该学生的所有学期
  await BaseCache.getInstance()
      .setString(JwcConst.termList, JsonEncoder().convert(data.termSetting));

  return data;
}

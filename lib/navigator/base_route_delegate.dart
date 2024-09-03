import 'package:flutter/material.dart';
import 'package:wust_helper_ios/model/jwc_grade_model.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/navigator/bottom_navigator.dart';
import 'package:wust_helper_ios/pages/home_page/library_anno_details_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_book_details_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_home_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_login_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_rent_book_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_search_page.dart';
import 'package:wust_helper_ios/pages/home_page/qr_code_page.dart';
import 'package:wust_helper_ios/pages/home_page/student_community_page.dart';
import 'package:wust_helper_ios/pages/mine_page/about_author_page.dart';
import 'package:wust_helper_ios/pages/mine_page/about_official_page.dart';
import 'package:wust_helper_ios/pages/mine_page/about_page.dart';
import 'package:wust_helper_ios/pages/home_page/add_countdown_page.dart';
import 'package:wust_helper_ios/pages/mine_page/dark_mode_page.dart';
import 'package:wust_helper_ios/pages/mine_page/setting_page.dart';
import 'package:wust_helper_ios/pages/schedule_page/add_courses_page.dart';
import 'package:wust_helper_ios/pages/schedule_page/add_background_page.dart';
import 'package:wust_helper_ios/pages/home_page/banner_content_page.dart';
import 'package:wust_helper_ios/pages/home_page/calendar_page.dart';
import 'package:wust_helper_ios/pages/home_page/credit_page.dart';
import 'package:wust_helper_ios/pages/home_page/empty_room_page.dart';
import 'package:wust_helper_ios/pages/feedback.dart';
import 'package:wust_helper_ios/pages/home_page/grade_chart_page.dart';
import 'package:wust_helper_ios/pages/home_page/grade_page.dart';
import 'package:wust_helper_ios/pages/login_page.dart';
import 'package:wust_helper_ios/pages/home_page/lost_page.dart';
import 'package:wust_helper_ios/pages/home_page/qr_scanner_page.dart';
import 'package:wust_helper_ios/pages/home_page/scholarship_page.dart';
import 'package:wust_helper_ios/pages/home_page/school_bus_page.dart';
import 'package:wust_helper_ios/pages/schedule_page/schedule_setting_page.dart';
import 'package:wust_helper_ios/pages/home_page/share_countdown_page.dart';
import 'package:wust_helper_ios/pages/mine_page/stu_info_page.dart';
import 'package:wust_helper_ios/pages/home_page/wlsy_page.dart';
import 'package:wust_helper_ios/pages/home_page/yellow_page.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/login_util.dart';
import 'package:wust_helper_ios/util/show_version_and_notices.dart';

class BaseRouteDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey; // 全局定位
  List<MaterialPage> pages = []; // 路由栈
  RouteStatus _routeStatus = RouteStatus.navigator2; // 当前路由状态【默认为课表】
  List<String> courses; // 接受跳转时获取的课表数据
  int courseIndex; // 接受跳转时获取的课程卡片位置索引
  Courses course; // 接收跳转时的课程数据
  // 接收跳转时传递的成绩组
  List<GradeData> grades;
  // 跳转时传递的学期列表
  List<String> termList;
  // 跳转时接收的学号
  String stuNum;
  // 是否为第一次加载(用以判断公告弹出)
  bool isFirst = true;
  // 轮播图点击跳转的url
  String bannerContentUrl;
  //倒计时传递的二维码和课程名称
  String uuid;
  String courseName;
  //图书馆通知页面的具体详情
  int announcementId;
  //图书馆进入详细页面需要的图片url
  String url;
  BaseRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    BaseNavigator.getInstance().registerRouteJump(RouteJumpListener(
      onJumpTo: (RouteStatus routeStatus, {Map args}) {
        _routeStatus = routeStatus;

        /// [在这里添加跳转传参监听]
        if (_routeStatus == RouteStatus.addCourse) {
          if (args != null) {
            course = args['course'];
          }
        } else if (_routeStatus == RouteStatus.scholarship) {
          if (args != null) {
            grades = args['grades'];
            termList = args['termList'];
            stuNum = args[ConstList.STU_NUM];
          }
        } else if (_routeStatus == RouteStatus.bannercard) {
          if (args != null) {
            bannerContentUrl = args["bannerContentUrl"];
          }
        } else if (_routeStatus == RouteStatus.shareCountdown) {
          if (args != null) {
            uuid = args['uuid'];
            courseName = args['courseName'];
          }
        } else if (_routeStatus == RouteStatus.libraryAnnoDetailsPage) {
          announcementId = args['announcementId'];
        } else if (_routeStatus == RouteStatus.libraryBookDetails) {
          url = args['url'];
        }
        notifyListeners();
      },
    ));
  }
  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> newPages = pages;
    if (index != -1) {
      /// 如果页面已经存在，则将其上的所有页面出栈
      newPages = newPages.sublist(0, index);
    }

    /// 下面书写了[路由栈更新]的逻辑
    /// [page]为需要进栈的新页面，在判断路由状态[RouteStatus]后得以确定
    ///
    /// `注意：appBar自带的返回按钮不会触发自定义路由的状态的变化！！！`，
    ///
    /// 其他页面无法在返回主页时销毁
    /// 故应在创建新页面时[清空除BottomNavigator]的其他页面，
    var page;
    if (routeStatus == RouteStatus.navigator0) {
      newPages.clear();
      page = pageWrap(BottomNavigator(
        initialPage: 0,
      ));
      isFirst = false;
    } else if (routeStatus == RouteStatus.navigator1) {
      newPages.clear();
      page = pageWrap(BottomNavigator(
        initialPage: 1,
      ));
      isFirst = false;
    } else if (routeStatus == RouteStatus.navigator2) {
      newPages.clear();
      page = pageWrap(BottomNavigator(
        firstLoad: isFirst ? () => showVersionAndNotices(context) : () {},
        // firstLoad: () => showToast("msg"),
      ));
      isFirst = false;
    } else if (routeStatus == RouteStatus.navigator3) {
      newPages.clear();
      page = pageWrap(BottomNavigator(
        initialPage: 3,
      ));
      isFirst = false;
    } else if (routeStatus == RouteStatus.navigator4) {
      newPages.clear();
      page = pageWrap(BottomNavigator(
        initialPage: 4,
      ));
      isFirst = false;
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    } else if (routeStatus == RouteStatus.addCourse) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 2,
      // )));
      // 当修改课表时传入为相应的课程数据
      // 当添加课程时传入的应为 Null 不能是 空白Course（）
      page = pageWrap(AddCoursesPage(course));
      // 在这里需要将course重置
      // 因为base_route_delegate会保存上次接收的course数据
      course = null;
    } else if (routeStatus == RouteStatus.grade) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(GradePage());
    } else if (routeStatus == RouteStatus.lostAndFound) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(LostPage());
    } else if (routeStatus == RouteStatus.studentCommunity) {
      page = pageWrap(StudentCommunityPage());
    } else if (routeStatus == RouteStatus.feedback) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 4,
      // )));
      page = pageWrap(FeedbackPage());
    } else if (routeStatus == RouteStatus.credit) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(CreditPage());
    } else if (routeStatus == RouteStatus.yellowPage) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(YellowPage());
    } else if (routeStatus == RouteStatus.calendar) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(CalendarPage());
    } else if (routeStatus == RouteStatus.schoolBus) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(SchoolBusPage());
    } else if (routeStatus == RouteStatus.emptyRoom) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 0,
      // )));
      page = pageWrap(EmptyRoomPage());
    } else if (routeStatus == RouteStatus.about) {
      // newPages.clear();
      // newPages.add(pageWrap(BottomNavigator(
      //   initialPage: 4,
      // )));
      page = pageWrap(AboutPage());
    } else if (routeStatus == RouteStatus.aboutAuthor) {
      page = pageWrap(AboutAuthorPage());
      int index = getPageIndex(pages, RouteStatus.aboutOffical);
      if (index != -1) {
        newPages.remove(newPages[index]);
      }
    } else if (routeStatus == RouteStatus.aboutOffical) {
      int index = getPageIndex(pages, RouteStatus.aboutAuthor);
      if (index != -1) {
        newPages.remove(newPages[index]);
      }
      page = pageWrap(AboutOfficialPage());
    } else if (routeStatus == RouteStatus.info) {
      page = pageWrap(StudentInfoPage());
    } else if (routeStatus == RouteStatus.scholarship) {
      page = pageWrap(ScholarshipPage(grades, stuNum, termList));
    } else if (routeStatus == RouteStatus.bannercard) {
      page = pageWrap(BannerContentPage(bannerContentUrl));
    } else if (routeStatus == RouteStatus.countdown) {
      page = pageWrap(CountdownPage());
    } else if (routeStatus == RouteStatus.shareCountdown) {
      page = pageWrap(
        ShareCountdownPage(
          uuid: uuid,
          courseName: courseName,
        ),
      );
    } else if (routeStatus == RouteStatus.qrScanner) {
      page = pageWrap(QRScannerPage());
    } else if (routeStatus == RouteStatus.background) {
      page = pageWrap(BackgroundPage());
    } else if (routeStatus == RouteStatus.scheduleSetting) {
      page = pageWrap(ScheduleSetting());
    } else if (routeStatus == RouteStatus.wlsyPage) {
      page = pageWrap(WlsyPage());
    } else if (routeStatus == RouteStatus.gradeChart) {
      page = pageWrap(GradeChart());
    } else if (routeStatus == RouteStatus.libraryLogin) {
      page = pageWrap(LibraryLoginPage());
    } else if (routeStatus == RouteStatus.libraryHomePage) {
      page = pageWrap(LibraryHomePage());
    } else if (routeStatus == RouteStatus.libraryAnnoDetailsPage) {
      page = pageWrap(LibraryAnnoDetailsPage(announcementId));
    } else if (routeStatus == RouteStatus.libraryBookDetails) {
      page = pageWrap(LibraryBookDetailsPage(url));
    } else if (routeStatus == RouteStatus.librarySearch) {
      page = pageWrap(LibrarySearchPage());
    } else if (routeStatus == RouteStatus.libraryRentPage) {
      page = pageWrap(LibraryRentBook());
    } else if (routeStatus == RouteStatus.settingPage) {
      page = pageWrap(SettingPage());
    } else if (routeStatus == RouteStatus.darkModePage) {
      page = pageWrap(DarkModePage());
    } else if (routeStatus == RouteStatus.qrCodePage) {
      page = pageWrap(QRCodePage());
    }

    /// 重新创建路由栈，否则旧路由栈[pages]会因为[引用未变]而不会改变
    newPages = [...newPages, page];
    BaseNavigator.getInstance().notify(newPages, pages);
    pages = newPages;
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        // return route.didPop(result) ? true : false;
        if (!route.didPop(result)) return false;
        if (pages.length > 1) {
          pages.removeLast();
          return true;
        } else {
          return false;
        }
      },
    );
  }

  /// 在获取当前路由状态时进行拦截，可强制进行登陆
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.login && !hasLogin()) {
      return _routeStatus = RouteStatus.login;
    } else {
      return _routeStatus;
    }
  }

  @override
  // ignore: missing_return
  Future<void> setNewRoutePath(configuration) {}
}

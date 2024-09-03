import 'package:flutter/material.dart';
import 'package:wust_helper_ios/navigator/bottom_navigator.dart';
import 'package:wust_helper_ios/pages/home_page/library_anno_details_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_book_details_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_home_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_login_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_rent_book_page.dart';
import 'package:wust_helper_ios/pages/home_page/library_search_page.dart';
import 'package:wust_helper_ios/pages/home_page/qr_code_page.dart';
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
import 'package:wust_helper_ios/pages/home_page/school_bus_page.dart';
import 'package:wust_helper_ios/pages/schedule_page/schedule_setting_page.dart';
import 'package:wust_helper_ios/pages/home_page/share_countdown_page.dart';
import 'package:wust_helper_ios/pages/mine_page/stu_info_page.dart';
import 'package:wust_helper_ios/pages/home_page/wlsy_page.dart';
import 'package:wust_helper_ios/pages/home_page/yellow_page.dart';
import 'package:wust_helper_ios/util/system_state_util.dart';

/// 监听路由页面变化
typedef RouteChangeListener(
  RouteStatusInfo current, // 当前打开的页面
  RouteStatusInfo pre, // 上次打开的页面
);

enum RouteStatus {
  /// 该类枚举了所有路由状态
  /// [login]为登陆界面，不可回退
  /// [navigator]为根页面，不可回退
  /// 在跳转不可回退页面时清空其他页面
  login,
  // 默认为navigator2,即课表
  navigator,
  // 五个navigator对应下方五个按钮，具体跳转到navigato的哪个页面
  // 主页
  navigator0,
  // 志愿者
  navigator1,
  // 课表
  navigator2,
  // 新闻
  navigator3,
  // 我的
  navigator4,
  // 添加课程
  addCourse,
  // 首页主要功能
  grade,
  // // 计算奖学金页面
  scholarship,
  // //失物招领
  lostAndFound,
  //成绩查询
  credit,
  //空教室查询
  emptyRoom,
  //学生社区
  studentCommunity,
  // 首页小工具
  schoolBus,
  calendar,
  physics,
  yellowPage,
  // `我的`页面
  feedback,
  toQQ,
  update,
  about,
  aboutAuthor,
  aboutOffical,
  info,
  //可以对未知报错页面进行统一处理，暂未使用
  unknown,
  //轮播图
  bannercard,
  // 倒计时
  countdown,
  shareCountdown,
  qrScanner,
  //切换背景
  background,
  // 课表设置
  scheduleSetting,
  // 物理实验系统页面
  wlsyPage,
  // 成绩图表
  gradeChart,
  // 图书馆
  //登陆
  libraryLogin,
  libraryHomePage,
  libraryAnnoDetailsPage,
  libraryBookDetails,
  librarySearch,
  libraryRentPage,

  //setting
  settingPage,
  qrCodePage,
  darkModePage,
  gradeSettingPage
}

class BaseNavigator extends _RouteJumpListener {
  static BaseNavigator _instance;
  RouteJumpListener _jumpListener; // 用以监听路由跳转事件
  List<RouteChangeListener> _routeChangeListeners = [];
  RouteStatusInfo _pre; // 上次打开的页面
  BaseNavigator._();

  static BaseNavigator getInstance() {
    if (_instance == null) _instance = BaseNavigator._();
    return _instance;
  }

  /// 注册路由的逻辑
  registerRouteJump(RouteJumpListener routeJumpListener) {
    this._jumpListener = routeJumpListener;
  }

  /// 添加监听
  addListener(RouteChangeListener listener) {
    if (!_routeChangeListeners.contains(listener)) {
      _routeChangeListeners.add(listener);
    }
  }

  /// 移除监听
  removeListener(RouteChangeListener listener) {
    _routeChangeListeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map args}) {
    _jumpListener.onJumpTo(routeStatus, args: args);
  }

  notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var _current = RouteStatusInfo(
        getRouteStatus(currentPages.last), currentPages.last.child);
    _notify(_current);
  }

  void _notify(RouteStatusInfo _current) {
    _routeChangeListeners.forEach((listener) {
      listener(_current, _pre);
    });
    _pre = _current;
  }
}

/// 定义了跳转时回调的格式
typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map args});

/// 此处存放了跳转时传递参数的形式，为扩展 Navigator 时提供模版
/// 如有需要可添加定义相应类型
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

/// 定义路由跳转的逻辑，此处定义跳转时需要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
  RouteJumpListener({this.onJumpTo});
}

//查找路由状态在页面栈中的位置
getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    if (pages.length != 0) {
      if (routeStatus == RouteStatus.navigator0 ||
          routeStatus == RouteStatus.navigator1 ||
          routeStatus == RouteStatus.navigator2 ||
          routeStatus == RouteStatus.navigator3 ||
          routeStatus == RouteStatus.navigator4) {
        routeStatus = RouteStatus.navigator;
      }
      if (getRouteStatus(pages[i]) == routeStatus) {
        return i;
      }
    }
  }
  return -1;
}

/// 获取当前页面的路由信息
getRouteStatus(MaterialPage page) {
  if (page.child is LoginPage)
    return RouteStatus.login;
  else if (page.child is BottomNavigator) {
    return RouteStatus.navigator;
  } else if (page.child is AddCoursesPage) {
    return RouteStatus.addCourse;
  } else if (page.child is GradePage) {
    return RouteStatus.grade;
  } else if (page.child is LostPage) {
    return RouteStatus.lostAndFound;
  } else if (page.child is FeedbackPage) {
    return RouteStatus.feedback;
  } else if (page.child is CreditPage) {
    return RouteStatus.credit;
  } else if (page.child is YellowPage) {
    return RouteStatus.yellowPage;
  } else if (page.child is CalendarPage) {
    return RouteStatus.calendar;
  } else if (page.child is SchoolBusPage) {
    return RouteStatus.schoolBus;
  } else if (page.child is EmptyRoomPage) {
    return RouteStatus.emptyRoom;
  } else if (page.child is AboutPage) {
    return RouteStatus.about;
  } else if (page.child is AboutAuthorPage) {
    return RouteStatus.aboutAuthor;
  } else if (page.child is AboutOfficialPage) {
    return RouteStatus.aboutOffical;
  } else if (page.child is StudentInfoPage) {
    return RouteStatus.info;
  } else if (page.child is BannerContentPage) {
    return RouteStatus.bannercard;
  } else if (page.child is CountdownPage) {
    return RouteStatus.countdown;
  } else if (page.child is ShareCountdownPage) {
    return RouteStatus.shareCountdown;
  } else if (page.child is QRScannerPage) {
    return RouteStatus.qrScanner;
  } else if (page.child is BackgroundPage) {
    return RouteStatus.background;
  } else if (page.child is ScheduleSetting) {
    return RouteStatus.scheduleSetting;
  } else if (page.child is WlsyPage) {
    return RouteStatus.wlsyPage;
  } else if (page.child is GradeChart) {
    return RouteStatus.gradeChart;
  } else if (page.child is LibraryLoginPage) {
    return RouteStatus.libraryLogin;
  } else if (page.child is LibraryHomePage) {
    return RouteStatus.libraryHomePage;
  } else if (page.child is LibraryAnnoDetailsPage) {
    return RouteStatus.libraryAnnoDetailsPage;
  } else if (page.child is LibraryBookDetailsPage) {
    return RouteStatus.libraryBookDetails;
  } else if (page.child is LibrarySearchPage) {
    return RouteStatus.librarySearch;
  } else if (page.child is LibraryRentBook) {
    return RouteStatus.libraryRentPage;
  } else if (page.child is SettingPage) {
    return RouteStatus.settingPage;
  } else if (page.child is DarkModePage) {
    return RouteStatus.darkModePage;
  } else if (page.child is QRCodePage) {
    return RouteStatus.qrCodePage;
  } else
    return RouteStatus.unknown;
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// 生成路由页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

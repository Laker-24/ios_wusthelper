import 'package:flutter/material.dart';

class ConstList {
  /// 以下 key 的 value 以 [String] 存储
  //本科生登陆 学号 教务处密码 物理实验密码
  static const STU_NUM = 'stuNum';
  static const JWC_PWD = 'jwcPwd';
  static const WLSY_PWD = "wlsyPwd";
  //是否有失物招领的公告
  static const LOST_TIPS = "LostTips";

  //跳转url
  static const String QQ_URL =
      'mqq://card/show_pslcard?src_type=internal&version=1&uin=439648667&key=3ef6a176806d98ac68865f12e8ee2d4de12333215cdfc5c9214c2c458a3e1352&card_type=group&source=external';
  static const String APPSTORE_URL =
      'itms-apps://itunes.apple.com/cn/app/id1538426487?mt=8';
}

/// 请求教务处后需要存储的变量
class JwcConst {
  static const schoolTerm = 'schoolTerm';
  static const term = 'term';
  static const courses = 'courses';
  static const token = 'token';
  static const info = 'info';
  static const isLogin = 'isLogin';
  static const termList = 'termList';
  static const currentTerm = "currentTerm";
  static const loginIndex = "loginIndex";
  static const haveTerms = "haveTerms";
  static const trainingHtml = "trainingHtml";
  //第一次请求教务处的培养方案的时间，每个月只会重新请求一次，其他时候使用本地缓存
  static const traingingRequestTime = "traingingRequestTime";
}

/// 课表需要使用的常量
class ScheduleConst {
  static const switchCPSchedule = 'switchCPSchedule';
  static const showCourse = 'showCourse'; //是否显示所有课程
  static const cpSchedule = 'cpSchedule'; // 情侣课表
  static const scrach="scrach";
  static const currentMondayTime = 'currentMondayTime';
  static const now = 'now';
  static const anchorPoint = 'anchorPoint'; //锚点
  static const anchorPointWeek = 'anchorPointWeek';
  static const courseAndColor = 'courseAndColor';
  static const colors = 'colors';
  static const isLakeArea = 'isLakeArea'; //是否是湖区
  static const isCartoonBg = 'isCartoonBg'; //是否使用了卡通背景
}

/// 请求成绩后需要保存的变量
class GradeConst {
  static const grade = 'gradeList'; //成绩列表
  static const gpa = 'gpa'; //平均学分绩
  static const gga = 'gga';
  static const gradeRequestTime = "gradeRequestTime"; //请求时间(与请求培养方案形式相同)
  static const newCourse = 'newCourse';
}

///物理实验课表需要使用的常量
class WlsyConst {
  static const wlsyIsLogin = "wlsyIsLogin"; //是否登陆
  static const wlsyIsImport = "wlsyIsImport"; //是否导入课表
}

///图书馆需要使用的常量
class LibraryConst {
  static const isLogin = "libraryIsLogin"; //是否已经登陆
  static const libPwd = "libPwd"; //密码
  static const listAnno = "listAnno"; //公告
  static const pageNum = "pageNum"; //第pageNum页
  static const pageSize = "pageSize"; //每页pageSize页
}

/// 课程卡片颜色
const CoursesColors = [
  '#fd999a',
  '#66cc99',
  '#66bdb0',
  '#2196f3',
  '#bf83da',
  '#68c4cf',
  '#ff5722',
  '#00d4bb',
  '#968cdc',
  '#ff7878',
  //为什么要写两遍：因为重复使用有时会出岔子，为了方便干脆定义两组
  '#fd999a',
  '#66cc99',
  '#66bdb0',
  '#2196f3',
  '#bf83da',
  '#68c4cf',
  '#ff5722',
  '#00d4bb',
  '#968cdc',
  '#ff7878',
];

///图表统计的RGB色值
const ChartColors = [
  "#00FF00",
  "#FF6A6A",
  "#00BFFF",
  "#EEEE00",
  "#FFC1C1",
  '#ff5722',
  '#00d4bb',
  '#968cdc',
  '#ff7878',
  "#FF69B4",
  '#66cc99',
  '#66bdb0',
  '#2196f3',
];

///管理端信息
class AdminConst {
  //公告
  static const oldNotices = 'oldNotices';
  static const newNotices = 'newNotices';
  //版本号
  static const version = 'version';
  //是否提示
  static const isPrompt = 'isPrompt';
}

/// 课程信息
class CourseInfo {
  static const className = 'className';
  static const classroom = 'classroom';
  static const teachClass = 'teachClass';
  static const startWeek = 'startWeek';
  static const endWeek = 'endWeek';
  static const teacher = 'teacher';
  static const section = 'section';
  static const weekDay = 'weekDay';
}

/// 主题色【白】
const MaterialColor wustHelperWhite = MaterialColor(0xFFFFFFFF, <int, Color>{
  50: Color(0xFFFFFFFF),
  100: Color(0xFFFFFFFF),
  200: Color(0xFFFFFFFF),
  300: Color(0xFFFFFFFF),
  400: Color(0xFFFFFFFF),
  500: Color(0xFFFFFFFF),
  600: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
  800: Color(0xFFFFFFFF),
  900: Color(0xFFFFFFFF),
});

/// 主题色【蓝】
const MaterialColor wustHelperBlue = MaterialColor(
  0xFF4ba6ee,
  <int, Color>{
    50: Color(0xFFa2d0f6),
    100: Color(0xFF8ac5f4),
    200: Color(0xFF73b9f2),
    300: Color(0xFF5cadf0),
    400: Color(0xFF4ba6ee),
    500: Color(0xFF2d96ed),
    600: Color(0xFF168ae9),
    700: Color(0xFF147cd2),
  },
);

///请求领航业务时需要的常量
class LhConst {
  //倒计时业务
  static const countdownCourseName = 'name';
  static const countdownExamTime = 'time';
  static const countdownNotes = 'comment';
  static const uuid = "uuid";
  //设置背景
  static const transparency = 'transparency';
  static const isFullScreen = 'isFullScreen';
  static const imagePath = 'imagePath';
  static const isAddImage = 'isAddImage';

  static const darkMode = "darkMode";
}

const Color appBarColor = Colors.white;
const Color darkAppBarColor = Colors.grey;
const Color countdownColor = Colors.green;

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wust_helper_ios/provider/background_setting_provider.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/provider/courses_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/provider/darktheme_setting_provider.dart';
import 'package:wust_helper_ios/provider/page_controller_provider.dart';
import 'package:wust_helper_ios/provider/schedule_provider.dart';
import 'package:wust_helper_ios/provider/scrach_provider.dart';
import 'package:wust_helper_ios/provider/title_time_provider.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';

List<SingleChildWidget> wusthelperProvider = [
  ChangeNotifierProvider(create: (_) => CurrentWeekProvider()),
  ChangeNotifierProvider(create: (_) => CoursesProvider()),
  ChangeNotifierProvider(create: (_) => CoursesColorProvider()),
  ChangeNotifierProvider(create: (_) => TokenProvider()),
  ChangeNotifierProvider(create: (_) => ScheduleProvider()),
  ChangeNotifierProvider(create: (_) => TitleTimeProvider()),
  ChangeNotifierProvider(create: (_) => BackgroundSettingProvider()),
  ChangeNotifierProvider(create: (_) => PagingController()),
  ChangeNotifierProvider(create: (_) => DarkThemeSettingProvider()),
  ChangeNotifierProvider(create: (_) => ScrachProvider()),
];

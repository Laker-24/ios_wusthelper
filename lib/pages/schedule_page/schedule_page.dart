import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/background_setting_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/provider/schedule_provider.dart';
import 'package:wust_helper_ios/provider/title_time_provider.dart';
import 'package:wust_helper_ios/util/code_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/widget/courses_list_item.dart';
import 'package:wust_helper_ios/widget/courses_time_item.dart';
import 'package:wust_helper_ios/widget/schedule_appbar.dart';
import 'package:wust_helper_ios/widget/title_time_item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SchedulePage extends StatefulWidget {
  // 从其他页面接收需要在本页面执行的方法
  final Function firstLoad;

  SchedulePage({this.firstLoad});
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  var mondayTime = DateTime.now();
  // 为实现futureBuilder懒加载
  // final AsyncMemoizer _memoizer = AsyncMemoizer();
  // 判断是否第一次加载并显示公告
  Function firstLoad;
  var listener;
  // 获取当前时间
  var today = DateTime.now();
  // 用以确定当周周一的时间

  // 当前时间在一周中的索引
  int currentWeekdayIndex = 0;
  // 设置周数的数组方便未来调整每周的起始天
  List<String> weekdayListMonday = ['一', '二', '三', '四', '五', '六', '日'];

  List<String> weekdayListSunday = ['日', '一', '二', '三', '四', '五', '六'];

  // 加载状态
  bool isLoading = false;

  // 湖区时间表
  List<String> lakeTime = [
    '08:20',
    '10:00',
    '10:20',
    '12:00',
    '14:00',
    '15:40',
    '16:00',
    '17:40',
    '18:40',
    '20:20',
    '20:30',
    '22:10'
  ];
  // 青山时间表
  List<String> mountainTime = [
    '08:00',
    '09:40',
    '10:10',
    '11:50',
    '14:00',
    '15:40',
    '16:00',
    '17:40',
    '18:40',
    '20:20',
    '20:30',
    '22:10'
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //需要在课表页面调用的方法(用于弹出公告)
    firstLoad = widget.firstLoad == null ? () {} : widget.firstLoad;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setRealTitleTime(context);
    //判断是黄家湖还是青山
    bool isLakeArea = context.select<CurrentWeekProvider, bool>(
            (value) => value.getIsLakeArea()) ??
        true;
    //判断每周第一天为周日还是周一
    bool isMonday = context.select<CurrentWeekProvider, bool>(
        (value) => value.currentWeekIsMonday());
    //是否启用了卡通背景
    bool isCartoonBg = context
        .select<ScheduleProvider, bool>((value) => value.getIsCartoonBg());
    currentWeekdayIndex = context.read<TitleTimeProvider>().currentWeekday;
    //图片路径
    var imagePath = context
        .select<BackgroundSettingProvider, dynamic>((value) => value.imagePath);
    //图片透明度
    double trans = 1.0 -
        context.select<BackgroundSettingProvider, double>(
            (value) => value.getTrans());
    //图片显示区域是否为全屏
    bool isFullScreen = context
        .select<BackgroundSettingProvider, bool>((value) => value.isFullScreen);
    //是否存在背景图片
    bool isAddImage = context
        .select<BackgroundSettingProvider, bool>((value) => value.isAddImage);

    /// 需要在页面渲染完后调用
    WidgetsBinding.instance.addPostFrameCallback((mag) async {
      await firstLoad();
      firstLoad = () {};
    });
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          (isAddImage && isFullScreen)
              ? Opacity(
                  opacity: trans,
                  child: CodeUtil.base642Image(
                    imagePath,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                )
              : Container(),
          Opacity(
            opacity: (isAddImage && isFullScreen) ? 0.82 : 1.0,
            child: Column(
              children: [
                /// [AppBar]
                ScheduleAppBar(
                  currentWeekdayIndex,
                  () {
                    setState(() {
                      isLoading = !isLoading;
                    });
                  },
                  mondayTime: mondayTime,
                ),

                /// [Schedule]
                Expanded(child: Consumer<ScheduleProvider>(
                  builder: (context, value, child) {
                    List<String> dateList =
                        context.select<TitleTimeProvider, List>(
                            (value) => value.titleTime);

                    return Stack(children: [
                      (isAddImage && (!isFullScreen))
                          ? Opacity(
                              opacity: trans,
                              child: CodeUtil.base642Image(
                                imagePath,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                            )
                          : Container(),
                      Container(
                        decoration: BoxDecoration(
                          image: isCartoonBg
                              ? DecorationImage(
                                  image:
                                      AssetImage('assets/images/cartoon.png'),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// [第一行日期显示]
                                  SingleChildScrollView(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        // color: Colors.white
                                        ),
                                    child: Row(
                                      children: [
                                        //【当前月份，设置为每周第一天的月份】
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Consumer<TitleTimeProvider>(
                                                    builder: (context, value,
                                                            child) =>
                                                        Text(
                                                            "${int.parse(dateList[0].split('/')[0])}",
                                                            // '${mondayTime.month}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey))),
                                                Text("月",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey)),
                                              ],
                                            )),
                                        //
                                        Expanded(
                                          flex: 10,
                                          child: StaggeredGridView.countBuilder(
                                              shrinkWrap: true,
                                              itemCount: 7,
                                              crossAxisCount: 7,
                                              //不响应用户滑动
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              staggeredTileBuilder: (int
                                                      index) =>
                                                  StaggeredTile.count(
                                                      1, // 列数 = crossAxisCount / 1
                                                      index < 8 ? 1 : 1),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return TitleTimeItem(
                                                    // currentWeekdayIndex:
                                                    //     currentWeekdayIndex,
                                                    weekdayList: isMonday
                                                        ? weekdayListMonday
                                                        : weekdayListSunday,
                                                    // dateList: dateList,
                                                    index: index);
                                              }),
                                        ),
                                      ],
                                    ),
                                  )),

                                  /// [课程列表]
                                  Expanded(
                                    child: SingleChildScrollView(
                                        //防止滚动超过边界
                                        physics: ClampingScrollPhysics(),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                // 左侧时刻表
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: 6,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 1,
                                                      childAspectRatio: 7 / 24,
                                                    ),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Consumer<
                                                          CurrentWeekProvider>(
                                                        builder: (context,
                                                                value, child) =>
                                                            CoursesTimeItem(
                                                                isLakeArea
                                                                    ? lakeTime
                                                                    : mountainTime,
                                                                index),
                                                      );
                                                    }),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                // 课程列表
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: 42,
                                                    gridDelegate:
                                                        //确定一个横轴固定数量的Widget
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            //横轴数量
                                                            crossAxisCount: 7,
                                                            //子组件宽高长度比
                                                            childAspectRatio:
                                                                5 / 12),
                                                    //index为横轴方向递增
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return CoursesListItem(
                                                          index);
                                                    }),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]);
                  },
                ))
              ],
            ),
          ),
          isLoading ? showLoadingDialog() : Container(),
        ],
      )),
    );
  }

  @override
  void dispose() {
    BaseNavigator.getInstance().removeListener((this.listener));
    super.dispose();
  }

  /// 第一行日期显示
  void setRealTitleTime(BuildContext context) {
    // 获取周一的日期
    TitleTimeProvider timeProvider = context.read<TitleTimeProvider>();
    //判断每周第一天为（默认为周一）
    bool isMonday = context.select<CurrentWeekProvider, bool>(
        (value) => value.currentWeekIsMonday());
    if (isMonday) {
      while (mondayTime.weekday != DateTime.monday) {
        mondayTime = mondayTime.subtract(Duration(days: 1));
      }

      timeProvider.initTitleTime(mondayTime);
    } else {
      while (mondayTime.weekday != DateTime.sunday) {
        mondayTime = mondayTime.subtract(Duration(days: 1));
      }
      timeProvider.initTitleTime(mondayTime);
    }
    for (int i = 0; i < 7; i++) {
      if ((mondayTime.add(Duration(days: i)).day) == DateTime.now().day) {
        // 需要跳过第一格
        context.read<TitleTimeProvider>().initCurrentWeekday(i);
      }
    }
    // context.read<TitleTimeProvider>().initTitleTime(mondayTime);
  }
}

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/banner_widget.dart';
import 'package:wust_helper_ios/widget/index_card.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  MediaQueryData mediaQueryData;
  List<String> smallCardImages = [
    'assets/images/schoolBus.png',
    'assets/images/schoolCalendar.png',
    'assets/images/eduNews.png',
    'assets/images/yellowPages.png'
  ];
  List<String> smallCardContents = [
    '校车时刻',
    '学校校历',
    '物理实验',
    '校园黄页',
    '发车时刻查询',
    '了解学校安排',
    '导入实验课表',
    '号码通讯录'
  ];
  List<String> cardBgColors = [
    '#e8f6e9',
    '#e8eaf6',
    '#e4f2fd',
    '#fff2df',
    '#ece5f5',
    '#ffebed'
  ];
  List<Widget> cardChildren = [];
  //大Card的点击事件
  bool libraryIsLogin =
      BaseCache.getInstance().get(LibraryConst.isLogin) ?? false;
  List<Function> handleCardTaps = [];
  List<Function> handleSmallCardTaps = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleCardTaps = [
      // 成绩
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.grade),
      // 倒计时
      () => showToast('即将上线，敬请期待！'),
      // () => BaseNavigator.getInstance().onJumpTo(RouteStatus.countdown),
      // 失物招领
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.lostAndFound),
      // 学分统计
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.credit),
      // 空教室
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.emptyRoom),
      // 图书馆
      () => !libraryIsLogin
          ? BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryLogin)
          : BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryHomePage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String stuNum = JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
    bool wlsyIsLogin =
        BaseCache.getInstance().get(WlsyConst.wlsyIsLogin) ?? false;
    handleSmallCardTaps = [
      //校车时间
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.schoolBus),
      //校历
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.calendar),
      //物理实验课表
      () => wlsyIsLogin
          ? BaseNavigator.getInstance().onJumpTo(RouteStatus.wlsyPage)
          : showWLSYcard(context, stuNum),
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.yellowPage),
    ];
    // 卡片长宽以屏幕宽度为基准
    double screenWidth = ScreenUtil.getScreenW(context);
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView(
        children: [
          /// [标题] [轮播图]
          SizedBox(
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: screenWidth * 0.015),
                    child: Container(
                      height: 50,
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: screenWidth * 0.015 * 1.5),
                        child: Row(
                          children: [
                            Baseline(
                              baseline: 30,
                              baselineType: TextBaseline.ideographic,
                              child: Text(
                                '武科大助手',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.015 * 3.5,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.015),
                              child: Baseline(
                                baseline: 30,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  'WUST HELPER',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.015 * 2.5,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// [轮播图]
                  Container(
                    child: SizedBox(
                      height: 140,
                      child: BannerCard(),
                    ),
                  ),
                ],
              )),

          /// [热门功能]
          Container(
            margin: EdgeInsets.only(top: screenWidth * 0.015 * 2),
            child: SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: screenWidth * 0.015, top: screenWidth * 0.015),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '热门功能',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.015 * 3.2,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        itemCount: 6,
                        crossAxisCount: 24,
                        physics: NeverScrollableScrollPhysics(),
                        staggeredTileBuilder: (index) => StaggeredTile.count(
                          index == 0 ? 24 : 12,
                          index == 0
                              ? 10
                              : index == 1
                                  ? 14
                                  : 7,
                        ),
                        itemBuilder: (context, index) {
                          cardChildren = [
                            gradeCard(screenWidth),
                            countDownCard(screenWidth),
                            lostAndFoundCard(screenWidth),
                            creditsCard(screenWidth),
                            emptyRoom(screenWidth),
                            libraryCard(screenWidth)
                          ];
                          return IndexCard(null, null, cardBgColors[index],
                              cardChildren[index], handleCardTaps[index]);
                        },
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ))
                ],
              ),
            ),
          ),

          Divider(
            indent: 25,
            endIndent: 25,
            height: 60,
            color: Colors.black38,
          ),

          /// [小工具]
          Padding(
            padding: EdgeInsets.only(
                bottom: screenWidth * 0.015, top: screenWidth * 0.015),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '小工具',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.015 * 3.2,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
              child: GridView.builder(
            shrinkWrap: true,
            itemCount: 4,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 50 / 23),
            itemBuilder: (context, index) {
              return _smallCard(screenWidth, index);
            },
          ))
        ],
      ),
    ));
  }

  Widget _smallCard(double screenWidth, int index) {
    return Padding(
      padding: index % 2 == 0
          ? EdgeInsets.only(right: 12, bottom: 15)
          : EdgeInsets.only(left: 12, bottom: 15),
      child: IndexCard(
          screenWidth * 0.42,
          screenWidth * 0.42 * 0.5,
          '#ffffff',
          // "#000",
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(smallCardImages[index]),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      smallCardContents[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.015 * 3,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      smallCardContents[index + 4],
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: screenWidth * 0.015 * 2.3),
                    )
                  ],
                ))
              ],
            ),
          ),
          handleSmallCardTaps[index]),
    );
  }

  Widget gradeCard(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.015 * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '成绩查询',
                style: TextStyle(
                    color: Color(transformColor('FF', '#4cb04e')),
                    fontSize: screenWidth * 0.015 * 4,
                    fontWeight: FontWeight.w600),
              ),
              Text('成绩查询/绩点计算/均分查看',
                  style: TextStyle(
                    color: Color(transformColor('FF', '#4cb04e')),
                    fontSize: screenWidth * 0.015 * 2.2,
                  ))
            ],
          ),
        )),
        // Transform.rotate(angl)
        Image.asset('assets/images/grade.png')
      ],
    );
  }

  Widget countDownCard(double screenWidth) {
    return FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.015 * 11,
              height: screenWidth * 0.015 * 11,
              child: Image.asset('assets/images/alarmClock.png'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenWidth * 0.015,
              ),
              child: Text(
                '考试提醒',
                style: TextStyle(
                    color: Color(transformColor('ff', '#5963ba')),
                    fontSize: screenWidth * 0.015 * 3.5,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text('倒计时/消息通知',
                style: TextStyle(
                  color: Color(transformColor('ff', '#5963ba')),
                  fontSize: screenWidth * 0.015 * 2.2,
                ))
          ],
        ));
  }

  Widget lostAndFoundCard(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.015 * 1.5,
              bottom: screenWidth * 0.015 * 2.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('失物招领',
                  style: TextStyle(
                      color: Color(transformColor('ff', '#2095f2')),
                      fontSize: screenWidth * 0.015 * 3.5,
                      fontWeight: FontWeight.w600)),
              Text('丢失物品早拾到',
                  style: TextStyle(
                    color: Color(transformColor('ff', '#2095f2')),
                    fontSize: screenWidth * 0.015 * 2.2,
                  ))
            ],
          ),
        )),
        SizedBox(
          width: screenWidth * 0.015 * 12,
          height: screenWidth * 0.015 * 12,
          child: Image.asset('assets/images/icon_lost_card.png'),
        )
      ],
    );
  }

  Widget creditsCard(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.015 * 1.5,
              bottom: screenWidth * 0.015 * 2.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  // BaseCache.getInstance().get(JwcConst.loginIndex) == 0
                  // ?
                  // '学分统计'
                  "培养方案",
                  style: TextStyle(
                      color: Color(transformColor('ff', '#ff9700')),
                      fontSize: screenWidth * 0.015 * 3.5,
                      fontWeight: FontWeight.w600)),
              Text('掌握修读情况',
                  style: TextStyle(
                    color: Color(transformColor('ff', '#ff9700')),
                    fontSize: screenWidth * 0.015 * 2.2,
                  ))
            ],
          ),
        )),
        SizedBox(
          width: screenWidth * 0.015 * 12,
          height: screenWidth * 0.015 * 12,
          child: Image.asset('assets/images/credit.png'),
        )
      ],
    );
  }

  Widget emptyRoom(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.015 * 1.5,
              bottom: screenWidth * 0.015 * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教室查询',
                  style: TextStyle(
                      color: Color(transformColor('ff', '#673bb7')),
                      fontSize: screenWidth * 0.015 * 3.5,
                      fontWeight: FontWeight.w600)),
              Text('空教室/课程搜索',
                  style: TextStyle(
                    color: Color(transformColor('ff', '#673bb7')),
                    fontSize: screenWidth * 0.015 * 2.2,
                  ))
            ],
          ),
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
                width: screenWidth * 0.015 * 9,
                height: screenWidth * 0.015 * 9,
                child: Image.asset('assets/images/emptyRoom.png')),
          ],
        ),
      ],
    );
  }

  Widget libraryCard(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: screenWidth * 0.015),
          child: SizedBox(
            width: screenWidth * 0.015 * 10,
            height: screenWidth * 0.015 * 10,
            child: Image.asset('assets/images/library.png'),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.015),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('图书馆',
                  style: TextStyle(
                      color: Color(transformColor('ff', '#f44236')),
                      fontSize: screenWidth * 0.015 * 3.5,
                      fontWeight: FontWeight.w600)),
              Text('馆藏/借阅查询',
                  style: TextStyle(
                      color: Color(transformColor('ff', '#f44236')),
                      fontSize: screenWidth * 0.015 * 2.2))
            ],
          ),
        ))
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wust_helper_ios/model/countdown_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/countdown_util.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/countdown_card.dart';
import 'package:wust_helper_ios/widget/floating_button_widget.dart';
import 'package:async/async.dart';

class CountdownPage extends StatefulWidget {
  CountdownPage({Key key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with AutomaticKeepAliveClientMixin {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  //当前日期
  var today = DateTime.now();
  //当前进行中的任务数量
  int tasks = 0;
  CountdownData countdownData;
  Future future;

  @override
  void initState() {
    super.initState();
    future = _memoizer.runOnce(() async {
      countdownData = await getAlltasks();
      tasks = countdownData.pri.length + countdownData.pub.length;
    });
  }

  ///倒计时显示的语句
  List countdownSen = [
    "正当利用时间!你要理解什么，不要舍近求远。",
    "放弃时间的人，时间也放弃他。",
    "时间就是生命，时间就是速度，时间就是力量。",
    "在所有批评家中，最伟大、最正确，最天才的是时间。",
    "最不善于利用时间的人最爱抱怨时光短暂。",
    "时间比理性创造出更多的皈依者。",
    "人生天地之间，若白驹过隙，忽然而已。"
  ];

  ///生成随机数，显示第n个语句
  int random = new Random().nextInt(7);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //获取屏幕高度
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: countdownColor,
          leading: IconButton(
            onPressed: () => BaseNavigator.getInstance().onJumpTo(
              RouteStatus.navigator0,
            ),
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "倒计时",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  BaseNavigator.getInstance().onJumpTo(RouteStatus.qrScanner);
                },
                icon: Icon(
                  Icons.fullscreen,
                  size: 35.0,
                ),
              ),
            )
          ],
        ),
        //添加悬浮Button
        floatingActionButton: countdownFloatingActionButton(
          () {
            showCountdownCard(context, "添加倒计时", true);
          },
        ),
        floatingActionButtonLocation: CountdownFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, -30, -30),
        resizeToAvoidBottomInset: false, //输入框抵住键盘 内容不随键盘滚动
        body: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              return asyncSnapshot.connectionState == ConnectionState.done
                  ? Column(
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxHeight: 0.25 * screenHeight),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                  '${today.year}—${today.month}—${today.day}'),
                              TitleText('正在进行 : $tasks'),
                              TitleText(countdownSen[random]),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey[300].withOpacity(0.5),
                          height: 0.63 * screenHeight,
                          child: ListView.builder(
                            itemCount: tasks,
                            itemBuilder: (BuildContext context, int index) {
                              ///自己的想法(很笨┭┮﹏┭┮)
                              ///定义私有和公有的倒计时数量,从0开始计数
                              int pri = countdownData.pri.length - 1,
                                  pub = countdownData.pub.length - 1;

                              ///先显示私有的倒计时(包含二维码)
                              if (pri - index >= 0) {
                                return CountdownCard(
                                  courseName: countdownData.pri[index].name,
                                  timeData: countdownData.pri[index].time,
                                  notes: countdownData.pri[index].comment,
                                  uuid: countdownData.pri[index].uuid,
                                );
                              } else {
                                //再显示分享的倒计时(包含二维码)
                                if (pub != 0) {
                                  return CountdownCard(
                                    courseName:
                                        countdownData.pub[index - pub - 1].name,
                                    timeData:
                                        countdownData.pub[index - pub - 1].time,
                                    notes: countdownData
                                        .pub[index - pub - 1].comment,
                                    uuid:
                                        countdownData.pub[index - pub - 1].uuid,
                                  );
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : showLoadingDialog();
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TitleText extends StatefulWidget {
  final String content;
  final double paddingTop;
  TitleText(this.content, {this.paddingTop, Key key}) : super(key: key);

  @override
  State<TitleText> createState() => _TitleTextState();
}

class _TitleTextState extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        top: 15.0,
      ),
      child: Text(
        widget.content,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

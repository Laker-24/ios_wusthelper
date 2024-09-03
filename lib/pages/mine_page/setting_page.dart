import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int loginIndex;
  @override
  void initState() {
    loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<void Function()> settingHandle = [
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.darkModePage),
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.qrCodePage),
      () {
        clearCPSchedule(context);
      },
      () => showToast("新功能开发者中,请耐心等待")
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: ListView.builder(
        itemCount: settingContents.length,
        itemBuilder: (BuildContext context, int index) {
          return (loginIndex == 1 && (index == 1 || index == 2))
              ? Container() //这里返回null会报错
              : settingItem(index, settingHandle[index]);
        },
        // itemExtent: 20,
      ),
    );
  }

  List<String> settingContents = [
    "深色模式",
    "情侣课表二维码",
    "清除情侣课表数据",
    "button",
  ];
  List<Icon> settingIcon = [
    Icon(Icons.dark_mode),
    Icon(Icons.people),
    Icon(Icons.disabled_by_default),
    Icon(Icons.radio_button_checked)
  ];

  Widget settingItem(int index, void Function() settingHandle) {
    return ElevatedButton.icon(
      onPressed: settingHandle,
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
      icon: settingIcon[index],
      label: Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(settingContents[index]), Icon(Icons.chevron_right)],
      )),
    );
  }
}

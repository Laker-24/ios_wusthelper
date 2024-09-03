import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wust_helper_ios/provider/darktheme_setting_provider.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

class DarkModePage extends StatefulWidget {
  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  int currentindex;
  DarkThemeSettingProvider darkProvider = DarkThemeSettingProvider();
  @override
  void initState() {
    currentindex = darkProvider.darkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主题选择"),
      ),
      body: Center(
        child: Column(
          children: [
            themeMode(0, "深色模式跟随系统"),
            themeMode(1, "浅色模式"),
            themeMode(2, "深色模式")
          ],
        ),
      ),
    );
  }

  Widget themeMode(int index, String mode) {
    return InkWell(
      onTap: () {
        setState(() {
          DarkThemeSettingProvider().setMode(index);
          showToast("操作成功,将在下次打开app时刷新", toastGravity: ToastGravity.CENTER);
        });
        currentindex = index;
      },
      child: Container(
        // color: Colors.red,
        child: Row(
          children: [
            Checkbox(
                checkColor: Colors.blue,
                value: currentindex == index,
                onChanged: (value) {
                  currentindex = index;
                }),
            Text(mode)
          ],
        ),
      ),
    );
  }
}

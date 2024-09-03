import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_route_delegate.dart';
import 'package:wust_helper_ios/provider/darktheme_setting_provider.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/provider/wusthelper_provider.dart';
import 'package:wust_helper_ios/util/admin_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';

void main() {
  runApp(WustHelper());
  HubUtil.ready();
}

class WustHelper extends StatefulWidget {
  @override
  _WustHelperState createState() => _WustHelperState();
}

class _WustHelperState extends State<WustHelper> {
  BaseRouteDelegate _routeDelegate = BaseRouteDelegate();
  Future _future;
  @override
  void initState() {
    super.initState();
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _future = initWustHelper(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initWustHelper(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              // flutter首个界面
              : Scaffold(
                  body: Center(
                      child: Image.asset(
                    'assets/images/LaunchImage@3x.png',
                    fit: BoxFit.cover,
                  )),
                );
          return MultiProvider(
              providers: wusthelperProvider,
              child: Consumer(
                builder: (BuildContext context,
                    DarkThemeSettingProvider provider, Widget child) {
                  return MaterialApp(
                    builder:
                        //  EasyLoading.init(),
                        (context, child) => Scaffold(
                      body: GestureDetector(
                        onTap: () {
                          /// 全局点击空白处失去焦点
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus &&
                              currentFocus.focusedChild != null) {
                            FocusManager.instance.primaryFocus.unfocus();
                          }
                        },
                        //配置easyloading
                        child: FlutterEasyLoading(
                          child: child,
                        ),
                      ),
                    ),
                    home: widget,
                    theme: ThemeData(
                        primarySwatch: wustHelperWhite,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        appBarTheme:
                            AppBarTheme(backgroundColor: wustHelperWhite)),
                    darkTheme: ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: darkAppBarColor,
                      appBarTheme: AppBarTheme(
                          backgroundColor: darkAppBarColor.withOpacity(0.3),
                          iconTheme: IconThemeData(color: wustHelperWhite),
                          // textTheme: ,
                          actionsIconTheme:
                              IconThemeData(color: wustHelperWhite)),
                      // primaryColor: wustHelperBlue,
                      // primarySwatch: wustHelperBlue,
                      // visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),

                    themeMode: provider.themeMode,

                    //是否处于debug模式（右上角）
                    debugShowCheckedModeBanner: false,
                  );
                },
              ));
        });
  }

  /// TODO：在这里进行初始化
  Future initWustHelper(BuildContext context) async {
    /// [预初始化缓存]
    await BaseCache.preInit();

    /// 获取登陆态
    bool isLogin = await BaseCache.getInstance().get(JwcConst.isLogin) ?? false;
    if (isLogin) {
      String token = TokenProvider().token;

      /// [获取公告]
      getAdminNotice(token);

      /// [检查版本号]
      checkVersion(token);

      ///[失物招领公告]
      getLostTips(token);
    }
  }
}

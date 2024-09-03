import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:wust_helper_ios/provider/background_setting_provider.dart';

import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:provider/provider.dart';

import 'package:wust_helper_ios/util/code_util.dart';

//设置成枚举型方便以后添加新功能QAQ
enum BackgroundChoice {
  //是否全屏
  isFullScreen,
  //调节透明度
  adjusttrans,
}

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({Key key}) : super(key: key);

  @override
  _BackgroundPageState createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  @override
  Widget build(BuildContext context) {
    var backgoundSettingProvider = context.watch<BackgroundSettingProvider>();
    //是否全屏开关有无打开
    bool isFullValue = context.select<BackgroundSettingProvider, bool>(
            (value) => value.isFullScreen) ??
        false;
    //调节不透明度的值
    double adjustValue = context.select<BackgroundSettingProvider, double>(
            (value) => value.getTrans()) ??
        0.0;
    //获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    //图片路径
    var _imagePath = context
        .select<BackgroundSettingProvider, dynamic>((value) => value.imagePath);
    //是否选择了图片（如果为true，则显示预览）
    bool isAddImage = context
        .select<BackgroundSettingProvider, bool>((value) => value.isAddImage);
    // LogUtil.e(_imagePath);
    const String tips = '''1.选择背景图片分辨率太大，加载会很慢
2.某些深色图片全屏样式可能导致课程表图标难以辨认
3.有些图片可能由于尺寸问题导致拉伸或不全，请尽量选择适合屏幕大小的图片
''';
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "背景设置",
          style: TextStyle(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSingleDialog(context, '课程表背景设置说明', tips);
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: !isAddImage
                        ? () async {
                            var image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);
                            var imagePath;
                            await CodeUtil.imageBase64(image.path)
                                .then((value) {
                              imagePath = value;
                            });

                            setState(() {
                              if (imagePath != null) {
                                backgoundSettingProvider.setPath(imagePath);
                                backgoundSettingProvider.setAddImage(true);
                              }
                            });
                          }
                        : null,
                    child: Container(
                      margin: EdgeInsets.only(top: 0.055 * screenWidth),
                      height: 1.1 * screenWidth,
                      width: 0.6 * screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300].withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: isAddImage
                          ? InkWell(
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Opacity(
                                          opacity: 1.0 - adjustValue,
                                          child: CodeUtil.base642Image(
                                            _imagePath,
                                            fit: BoxFit.cover,
                                            width: 0.6 * screenWidth,
                                            height: 1.1 * screenWidth - 55.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 55.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                backgoundSettingProvider
                                                    .setPath(' ');
                                                backgoundSettingProvider
                                                    .setAddImage(false);
                                              },
                                            );
                                          },
                                          child: Text(
                                            "清除图片",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                "请选择图片",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                card(
                  '全屏设置',
                  BackgroundChoice.isFullScreen,
                  //iOS风格的switch开关
                  CupertinoSwitch(
                    value: isFullValue,
                    onChanged: (value) {
                      setState(() {
                        isFullValue = value;
                        backgoundSettingProvider.setisFull(isFullValue);
                      });
                    },
                    activeColor: Colors.green[300],
                    trackColor: Colors.grey[400],
                  ),
                  width: 0.9 * screenWidth,
                ),
                card(
                    '不透明度',
                    BackgroundChoice.adjusttrans,
                    //可拖动进度条（从一个范围中选一个值）,
                    CupertinoSlider(
                      value: adjustValue,
                      min: 0.0,
                      max: 1.0,
                      activeColor: Colors.green[300],
                      thumbColor: Colors.green[400],
                      onChanged: (value) {
                        adjustValue = value;
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          adjustValue = value;
                          backgoundSettingProvider.setTrans(adjustValue);
                        });
                      },
                    ),
                    value: adjustValue,
                    width: 0.9 * screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //选择图片下方的小卡片 【是否全屏，不透明度】
  card(String title, BackgroundChoice choice, Widget child,
      {double width, double value}) {
    // bool value1 = true;
    switch (choice) {
      case BackgroundChoice.isFullScreen:
        return Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Container(
            width: width,
            height: 0.12 * width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white70,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
        break;
      case BackgroundChoice.adjusttrans:
        return Container(
          width: width,
          height: 0.12 * width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white70,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                Expanded(child: child),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Text(
                    '${(value * 100).toInt()}%',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }
  }
}

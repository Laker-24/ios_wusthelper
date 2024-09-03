/*
 * 
 * 
 * IOS风格的齿轮选择器
 * 
 * 
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/util/common.dart';

clickSelectedCupertino(

    ///`pikers`为齿轮中的选项集合，`handleBeingSure`为确定按钮的回调函数
    ///`args` 为需要显示的一些内容

    BuildContext context,
    List<List<String>> sectionsList, // 选项集
    List<Function> handleSelectList,
    Function handleBeingSure,
    {String currentTerm}) {
  List<CupertinoPicker> cupertinoPickers = [];
  for (var i = 0; i < sectionsList.length; i++) {
    cupertinoPickers.add(CupertinoPicker(
      itemExtent: 50,
      onSelectedItemChanged: (index) {
        handleSelectList[i](index);
      },
      children: sectionsList[i].map((data) {
        return Center(
          child: Text('$data'),
        );
      }).toList(),
    ));
  }
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          child: Column(
            children: <Widget>[
              // 顶部 取消 确认 按钮
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 2),
                      child: FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "取消",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    currentTerm != null
                        ? Column(
                            children: [
                              Text(
                                "最新学期：",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(currentTerm),
                            ],
                          )
                        : Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10, top: 5, bottom: 2),
                      child: FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          handleBeingSure();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "确定",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                      child:
                          // 排列传入的Items
                          Row(children: popItem(cupertinoPickers)),
                    )),
              )
            ],
          ),
        );
      });
}

//`picker`的构造是形如下的函数
// Widget sectionPiker(List sectionList) {
//     return CupertinoPicker(
//       itemExtent: 50,
//       onSelectedItemChanged: (index) {
//         setState(() {});
//       },
//       children: sectionList.map((data) {
//         return Center(
//           child: Text('$data'),
//         );
//       }).toList(),
//     );
//   }

/// 根据`pikers`构造齿轮选项
List<Widget> popItem(List<Widget> pikers) {
  return pikers.map((piker) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
          child: piker,
        ),
      ),
    );
  }).toList();
}

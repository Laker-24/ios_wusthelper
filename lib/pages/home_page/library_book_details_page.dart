/*
 * 
 *    图书详情页面
 * 
 */

import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wust_helper_ios/model/library_model/library_get_book_detail_model.dart';
import 'package:wust_helper_ios/util/library_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

class LibraryBookDetailsPage extends StatefulWidget {
  final String url;
  const LibraryBookDetailsPage(this.url, {Key key}) : super(key: key);

  @override
  State<LibraryBookDetailsPage> createState() => _LibraryBookDetailsPageState();
}

class _LibraryBookDetailsPageState extends State<LibraryBookDetailsPage> {
  Future _future;
  String _detailUrl;
  LibraryGetBookDetailModel libraryGetBookDetailModel;
  var lastPopTime;

  Future<bool> intervalClick(int needTime) async {
    // 防重复点击
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      lastPopTime = DateTime.now();
      return true;
    } else {
      showToast("操作过于频繁");
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _future = _getBookDetails();
    _detailUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text("图书详情"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          Widget _widget;
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (libraryGetBookDetailModel.data == null &&
                  libraryGetBookDetailModel.code != 10000) {
                showToast(libraryGetBookDetailModel.msg);
                _widget = Center(
                  child: Text("加载图书详情失败～"),
                );
              } else {
                //图书详情信息
                BookDetail _bookDetail = libraryGetBookDetailModel.data;
                //是否有封面
                bool isEmpty = false;
                //该图书是否收藏过
                bool isCollection = false;
                if (_bookDetail.isCollection == 1) {
                  isCollection = true;
                }

                if (_bookDetail.imgUrl == "https://") {
                  _bookDetail.imgUrl = "assets/images/book_default.jpg";
                  isEmpty = true;
                }
                //图书下方模块
                _card(String title, String content) {
                  return Container(
                    margin: EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 15),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            content,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //主页面
                Widget widget = ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: ScreenUtil.getInstance().screenHeight * 0.5,
                          width: double.infinity,
                          child: ImageFiltered(
                            imageFilter:
                                ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: isEmpty
                                ? Image.asset(
                                    _bookDetail.imgUrl,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _bookDetail.imgUrl,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: ScreenUtil.getInstance().screenHeight * 0.115,
                          left: ScreenUtil.getInstance().screenWidth * 0.24,
                          child: Container(
                            height:
                                ScreenUtil.getInstance().screenHeight * 0.25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 0.5, color: Colors.blueGrey)),
                            child: isEmpty
                                ? Image.asset(
                                    _bookDetail.imgUrl,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _bookDetail.imgUrl,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: ScreenUtil.getInstance().screenHeight * 0.5 - 50,
                          // width: 60,
                          height: 50,
                          child: InkWell(
                            onTap: () async {
                              bool isEnable = await intervalClick(2);
                              if (isEnable) {
                                bool isSuccess;
                                //判断是否收藏
                                if (!isCollection) {
                                  //如果没有被收藏
                                  isSuccess = await addLibraryCollection(
                                      _bookDetail.bookNameAndAuth,
                                      _bookDetail.isbn,
                                      _bookDetail.bookNameAndAuth,
                                      _bookDetail.publisher,
                                      _detailUrl);
                                  if (isSuccess) {
                                    setState(() {
                                      _bookDetail.isCollection = 1;
                                    });
                                  }
                                } else {
                                  isSuccess = await delLibraryCollection(
                                      _bookDetail.isbn);
                                  if (isSuccess) {
                                    setState(() {
                                      _bookDetail.isCollection = 0;
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              // width: 40,
                              decoration: BoxDecoration(
                                color: isCollection ? Colors.pink : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/images/love.webp",
                                // height: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //图片下方模块
                    Container(
                      margin: EdgeInsets.only(right: 10, left: 10, top: 30),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[400], width: 0.5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200],
                              offset: Offset(1.0, 1.0),
                              spreadRadius: 0)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _card("题名/责任者", _bookDetail.bookNameAndAuth),
                          _card("出版发行项", _bookDetail.publisher),
                          _card("ISBN及定价", _bookDetail.isbn),
                          Padding(
                            padding: EdgeInsets.only(right: 20, left: 15),
                            child: Text(
                              "简介",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 15),
                            child: Text(
                              _bookDetail.introduction,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _bookDetail.list.length,
                        itemBuilder: (context, index) {
                          //当前借阅状态
                          List<String> statusText =
                              _clipText(_bookDetail.list[index].status);
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey[400], width: 0.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(1.0, 1.0),
                                )
                              ],
                            ),
                            margin:
                                EdgeInsets.only(top: 15, right: 10, left: 10),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Flex(
                              direction: Axis.horizontal,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/borrowable.webp",
                                        height: 30,
                                      ),
                                      statusText.length == 1
                                          ? ConstrainedBox(
                                              constraints:
                                                  BoxConstraints(minWidth: 50),
                                              child: Text(
                                                "    ${statusText[0]}",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  statusText[0],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  statusText[1],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("索书号"),
                                      Text("条码号"),
                                      Text("馆藏地总馆"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_bookDetail.list[index].barCode),
                                      Text(_bookDetail.list[index].callNo),
                                      Text(_bookDetail.list[index].location),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                );
                _widget = widget;
              }
              break;
            case ConnectionState.waiting:
              _widget = Center(
                child: showLoadingDialog(),
              );
              break;

            default:
          }

          return _widget;
        },
      ),
    );
  }

  List<String> _clipText(String text) {
    if (text == "可借")
      return [text];
    else
      print(text.split(':')[0]);
    return text.split(':');
  }

  _getBookDetails() async {
    libraryGetBookDetailModel = await getLibraryBookDetail(widget.url);
  }
}

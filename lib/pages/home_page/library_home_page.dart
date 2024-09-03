/*
 *      图书馆主页页面
 */

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/library_model/library_get_current_rent_model.dart';
import 'package:wust_helper_ios/model/library_model/library_get_rent_history_model.dart';
import 'package:wust_helper_ios/model/library_model/library_list_anno_model.dart';
import 'package:wust_helper_ios/model/library_model/library_list_collection_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/library_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

class LibraryHomePage extends StatefulWidget {
  const LibraryHomePage({Key key}) : super(key: key);

  @override
  State<LibraryHomePage> createState() => _LibraryHomePageState();
}

class _LibraryHomePageState extends State<LibraryHomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<String> tabs = ["图书查询", "我的收藏", "公告馆讯"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text("图书馆"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator0);
            // Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
          indicatorColor: Colors.black,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: TabBarView(controller: _tabController, children: [
          LibraryBookQuery(),
          MyCollection(),
          HallNews(),
        ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///图书查询
class LibraryBookQuery extends StatelessWidget {
  const LibraryBookQuery({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil.getInstance().screenWidth * 0.9;
    return Stack(
      children: [
        Positioned(
          top: 80,
          left: 15,
          height: 120,
          width: width,
          child: _card("馆藏查询", "查询喜欢的图书收藏吧～", "assets/images/search_book.png"),
        ),
        Positioned(
          top: 230,
          left: 15,
          height: 120,
          width: width,
          child: _card("图书借阅", "随时了解图书借阅情况~", "assets/images/my_book.png"),
        ),
      ],
    );
  }

  _card(String title, String hintText, String imagePath) {
    return InkWell(
      onTap: () {
        if (title == "馆藏查询") {
          BaseNavigator.getInstance().onJumpTo(RouteStatus.librarySearch);
        } else {
          BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryRentPage);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[100], width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(-1.0, 1.0),
                blurRadius: 0,
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
            Image.asset(
              imagePath,
              height: 60,
              width: 60,
            ),
          ],
        ),
      ),
    );
  }
}

///我的收藏
class MyCollection extends StatefulWidget {
  const MyCollection({Key key}) : super(key: key);

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  List<LibraryCollection> _collectionList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionList = [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? RefreshIndicator(
                  onRefresh: () async {
                    await _getData();
                  },
                  child: _collectionList != null && _collectionList.length != 0
                      ? ListView.builder(
                          itemCount: _collectionList.length,
                          itemBuilder: (context, index) {
                            return _card(_collectionList[index]);
                          })
                      : Center(
                          child: Text(
                            "快去收藏喜欢的书籍吧~",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                )
              : showLoadingDialog();
        });
  }

  Widget _card(LibraryCollection libraryCollection) {
    return InkWell(
      onTap: () {
        BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryBookDetails,
            args: {"url": libraryCollection.detailUrl});
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 10, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${libraryCollection.title}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    // overflow: TextOverflow.ellipsis,
                    fontSize: 16.0,
                  ),
                  children: [
                    TextSpan(
                      text: "作者：",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: "${libraryCollection.author}",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  // overflow: TextOverflow.ellipsis,
                  fontSize: 16.0,
                ),
                children: [
                  TextSpan(
                    text: "出版社：",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                      text: "${libraryCollection.publisher}",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              maxLines: 1,
            ),
            Divider(
              color: Colors.blueGrey,
              height: 1,
              thickness: 0.3,
            ),
          ],
        ),
      ),
    );
  }

  _getData() async {
    //默认页数从1开始
    _collectionList = await getLibraryListCollection();
  }
}

///公告馆讯
class HallNews extends StatefulWidget {
  const HallNews({Key key}) : super(key: key);

  @override
  State<HallNews> createState() => _HallNewsState();
}

class _HallNewsState extends State<HallNews>
    with AutomaticKeepAliveClientMixin {
  List<Anno> _annoList;
  int pageNum = 1;
  int pageSize = 10;
  Future future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _getListAnno(),
        builder: (context, snapshot) {
          Widget _widget = Container();
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _widget = _annoList.length != 0
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await _getListAnno();
                      },
                      child: ListView.builder(
                          itemCount: _annoList.length,
                          itemBuilder: (context, index) {
                            return _card(_annoList[index]);
                          }),
                    )
                  : Center(
                      child: Text("加载失败，请检查您的网络连接～"),
                    );
              break;
            case ConnectionState.waiting:
              _widget = showLoadingDialog();
              break;
            default:
          }
          return _widget;
        });
  }

  Future<void> _getListAnno() async {
    _annoList = await getLibraryListAnno();
  }

  _card(Anno anno) {
    return InkWell(
      onTap: () {
        BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryAnnoDetailsPage,
            args: {"announcementId": anno.id});
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 10, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/library_sign.webp',
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    "图书馆通知",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text("${anno.title}",
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Text(
                    "${anno.publishTime}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 0,
              thickness: 0.3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

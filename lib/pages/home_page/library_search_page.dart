/*
 * 
 *      图书搜索页面

 * 
 */

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wust_helper_ios/model/library_model/library_search_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/background_setting_provider.dart';
import 'package:wust_helper_ios/util/library_util.dart';
import 'package:wust_helper_ios/provider/page_controller_provider.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';

class LibrarySearchPage extends StatefulWidget {
  const LibrarySearchPage({Key key}) : super(key: key);

  @override
  State<LibrarySearchPage> createState() => _LibrarySearchPageState();
}

class _LibrarySearchPageState extends State<LibrarySearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  LibrarySearchModel librarySearchModel;
  bool isLoad = false;
  Future _future;
  String _keyWord = "";

  @override
  Widget build(BuildContext context) {
    var cont = context.watch<PagingController>();
    Future<List<SearchBook>> _initData() async {
      HubUtil.show(
        msg: '''正在搜索图书...
搜索时间可能较长，请耐心等待
              ''',
      );
      LibrarySearchModel model = await getLibrarySearch(cont.getkeyword);
      //内容是null说明登陆过期了
      if (model == null) {
        HubUtil.dismiss();
        return null;
      }

      List<SearchBook> list = model.data;
      HubUtil.dismiss();

      /// 数据不为空，则将数据添加到 data 中,然后页数++
      if (list != null && list.length != 0) {
        cont.loadData();
        cont.addData(list);
      } else {
        cont.setHasMore();
      }
      return list;
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil.getInstance().statusBarHeight,
                  right: 10,
                  left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      // BaseNavigator.getInstance()
                      //     .onJumpTo(RouteStatus.libraryHomePage);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          hintText: "输入书本信息查找",
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      onSubmitted: (value) async {
                        cont.initKeyWord(value);
                        cont.setIsInitData(false);
                        cont.initState();
                        setState(() {
                          _keyWord = value;
                        });

                        ///初始化数据
                        if (!cont.isInit) {
                          cont.setIsInitData(true);
                          _initData();
                        }
                      },
                      cursorColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            _keyWord != ""
                ? Expanded(
                    child: LibrarySearchPageListView(
                      keyword: _keyWord,
                    ),
                  )
                : Spacer(),
          ],
        ),
      ),
    );
  }
}

//避免重新build时加载过多，这里单独进行封装
//下面可能有一些注释掉的代码，为当时的尝试，不好看后面可以删掉
class LibrarySearchPageListView extends StatefulWidget {
  final String keyword;
  LibrarySearchPageListView({Key key, this.keyword}) : super(key: key);

  @override
  State<LibrarySearchPageListView> createState() =>
      _LibrarySearchPageListViewState();
}

class _LibrarySearchPageListViewState extends State<LibrarySearchPageListView> {
  RefreshController refreshController = RefreshController();
  // LibrarySearchModel librarySearchModel;
  // String _keyWord = " ";
  // //当前页数
  // int pageNum = 1;
  // //listview的滑动控制器
  // ScrollController _scrollController = ScrollController();
  // bool isGetMore = false;
  var controller;

  ///初始化数据
  Future<List<SearchBook>> _initData() async {
    HubUtil.show(
      msg: '''正在搜索图书...
搜索时间可能较长，请耐心等待
              ''',
    );
    LibrarySearchModel model = await getLibrarySearch(controller.getkeyword);

    //内容是null说明登陆过期了
    if (model == null) {
      HubUtil.dismiss();
      return null;
    }
    List<SearchBook> list = model.data;
    HubUtil.dismiss();

    /// 数据不为空，则将数据添加到 data 中,然后页数++
    if (list != null && list.length != 0) {
      controller.loadData();
      controller.addData(list);
    } else {
      controller.setHasMore();
    }
    return list;
  }

  ///数据加载
  Future<List<SearchBook>> _loadData(int pageNum) async {
    LibrarySearchModel model =
        await getLibrarySearch(controller.getkeyword, pageNum: pageNum);
    List<SearchBook> list = model.data;

    /// 数据不为空，则将数据添加到 data 中,然后页数++
    if (list != null && list.length != 0) {
      controller.loadData();
      controller.addData(list);
    } else {
      controller.setHasMore();
    }
    return list;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<PagingController>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PagingController>(
      builder: (context, controller, child) {
        return buildRefreshWidget(
          refreshController: refreshController,
          builder: () {
            return buildListView<SearchBook>(
                data: controller.data,
                itemBuilder: (item, index) {
                  if (controller.data.length == 0) return SizedBox();
                  return _card(item);
                },
                onItemClick: (item, index) {
                  BaseNavigator.getInstance().onJumpTo(
                      RouteStatus.libraryBookDetails,
                      args: {"url": item.detailUrl});
                });
          },

          enablePullDown: controller.ishasMore,

          onRefresh: () async {
            controller.initState();
            await _initData();
            //刷新完成
            refreshController.refreshCompleted();
          },
          enablePullUp: controller.hasMore,
          onLoad: () async {
            await _loadData(controller.pageNum);
            refreshController.loadComplete();
          },

          // enablePullUp: enablePullUp && controller.pagingState.hasMore,
        );
      },
    );
    // librarySearchModel == null?
    //  Center(child: Text(),): ListView.builder(
    //     shrinkWrap: true,
    //     controller: _scrollController,
    //     itemCount: librarySearchModel.data.length + 1,
    //     itemBuilder: (BuildContext context, int index) {
    //       if (index < librarySearchModel.data.length) {
    //         return _card(librarySearchModel.data[index]);
    //       } else {
    //         return _getMoreWidget();
    //       }
    //     });
  }

  ///封装listview(方便下面使用)
  Widget buildListView<T>(
      {Widget Function(T item, int index) itemBuilder,
      List<T> data,
      Function(T item, int index) onItemClick}) {
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => GestureDetector(
              child: itemBuilder.call(data[index], index),
              onTap: () => onItemClick.call(data[index], index),
            ));
  }

  //对 SmartRefresher 进行封装
  Widget buildRefreshWidget({
    Widget Function() builder,
    VoidCallback onRefresh,
    VoidCallback onLoad,
    RefreshController refreshController,
    bool enablePullUp = true,
    bool enablePullDown = true,
  }) {
    return SmartRefresher(
      enablePullUp: enablePullUp,
      enablePullDown: enablePullDown,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoad,
      header: const ClassicHeader(
        idleText: "下拉刷新",
        releaseText: "松开刷新",
        completeText: "刷新完成",
        refreshingText: "加载中......",
      ),
      footer: const ClassicFooter(
        idleText: "上拉加载更多",
        canLoadingText: "松开加载更多",
        loadingText: "加载中......",
      ),
      child: builder(),
    );
  }

  // Widget buildRefreshListWidget<T,
  //     C extends PagingController<T, PagingState<T>, BaseModel>>({
  //   Widget Function(T item, int index) itemBuilder,
  //   bool enablePullUp = true,
  //   bool enablePullDown = true,
  //   Function(T item, int index) onItemClick,
  // }) {
  //   return Consum<C>(
  //     builder: (controller) {
  //       return buildRefreshWidget(
  //         builder: () => buildListView<T>(
  //           data: controller.getState().data,
  //           itemBuilder: itemBuilder,
  //           onItemClick: onItemClick,
  //         ),
  //         refreshController: controller.refreshController,
  //         onRefresh: controller.refreshData,
  //         onLoad: controller.loadMoreData,
  //       );
  //     },
  //   );
  // }
//
//                     :
//     FutureBuilder(
//         future: _getData(_keyWord),
//         builder: (context, snapshot) {
//           Widget _widget;
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               HubUtil.dismiss();
//               _widget = RefreshIndicator(
//                 onRefresh: () async {
//                   await _getData(_keyWord);
//                 },
//                 child: librarySearchModel != null
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         controller: _scrollController,
//                         itemCount: librarySearchModel.data.length + 1,
//                         itemBuilder: (BuildContext context, int index) {
//                           if (index < librarySearchModel.data.length) {
//                             return _card(librarySearchModel.data[index]);
//                           } else {
//                             return _getMoreWidget();
//                           }
//                         })
//                     : Center(
//                         child: Text("加载失败了～"),
//                       ),
//               );
//               break;
//             case ConnectionState.waiting:
//               _widget = SizedBox();
//               HubUtil.show(
//                 msg: '''正在搜索图书...
// 搜索时间可能较长，请耐心等待
//               ''',
//               );
//               break;
//             case ConnectionState.none:
//               HubUtil.dismiss();
//               _widget = Center(
//                 child: Text("搜索失败，请检查您的网络～ "),
//               );
//               break;
//             default:
//           }
//           // Navigator.pop(context);

//           return _widget;
//         });

  //初始数据(显示10条)
//   void _initData(String keyword) async {
//     HubUtil.show(
//       msg: '''正在搜索图书...
// 搜索时间可能较长，请耐心等待
//               ''',
//     );
//     setState(() async {
//       librarySearchModel = await getLibrarySearch(keyword);
//     });

//     HubUtil.dismiss();
//   }

//   //上拉加载更多
//   void _getMoreData(String keyword) async {
//     //防止多次触发
//     if (!isGetMore) {
//       isGetMore = true;
//       pageNum++;
//       LibrarySearchModel model =
//           await getLibrarySearch(keyword, pageNum: pageNum);
//       setState(() {
//         librarySearchModel.data.addAll(model.data);
//         isGetMore = false;
//       });
//     }
//   }

  //listview的每个item
  _card(SearchBook searchBook) {
    bool isEmpty = false;
    //有些图书没有封面(后面是防止第二次加载时已经改变)
    if (searchBook.imgUrl == "https://" ||
        searchBook.imgUrl == "assets/images/book_default.jpg") {
      isEmpty = true;
      searchBook.imgUrl = "assets/images/book_default.jpg";
    }
    return GestureDetector(
      // onTap: () {
      //   BaseNavigator.getInstance().onJumpTo(RouteStatus.libraryBookDetails,
      //       args: {"url": searchBook.detailUrl});
      // },
      child: Container(
        // height: 150,
        margin: EdgeInsets.only(right: 20, left: 20, top: 10),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            searchBook.title.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        _showText("作者：", searchBook.author),
                        _showText("出版社：", searchBook.publisher),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _showText("馆藏副本：", searchBook.allNum),
                            _showText("可借副本：", searchBook.remainNum),
                          ],
                        )
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: isEmpty
                      ? Image.asset(
                          searchBook.imgUrl,
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          searchBook.imgUrl,
                          fit: BoxFit.contain,
                        ),
                ),
              ],
            ),
            Divider(
              color: Colors.blueGrey,
              height: 7,
              thickness: 0.3,
            ),
          ],
        ),
      ),
    );
  }

  //与card配合使用
  _showText(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: title, style: TextStyle(color: Colors.black)),
          TextSpan(text: content, style: TextStyle(color: Colors.grey)),
        ]),
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _getNoData() {
    return Text(
      '没有更多了   ',
      style: TextStyle(fontSize: 16.0),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _scrollController.dispose();
  }
}

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/model/library_model/library_get_current_rent_model.dart';
import 'package:wust_helper_ios/model/library_model/library_get_rent_history_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/library_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';

///借阅图书
class LibraryRentBook extends StatefulWidget {
  const LibraryRentBook({Key key}) : super(key: key);

  @override
  State<LibraryRentBook> createState() => _LibraryRentBookState();
}

class _LibraryRentBookState extends State<LibraryRentBook> {
  List<Widget> _list = [];
  List<CurrentRentBook> _rentBook = [];
  List<CurrentRentBook> _overDueBook = [];
  List<HitsoryRentBook> _historyRentBook = [];
  List<String> _title = [];
  List<CurrentRentBook> _currentRentBook = [];
  @override
  void initState() {
    super.initState();

    _title = ["条码号", "题名/责任者", "借阅日期", "应还日期", "馆藏地"];
  }

  Future<void> _future() async {
    _rentBook = await getLibraryRentCurrent();
    if (_rentBook == null) {
      HubUtil.dismiss();
      return null;
    }
    _historyRentBook = await getLibraryRentHistory();
    if (_historyRentBook == null) {
      HubUtil.dismiss();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "图书借阅",
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
            future: _future(),
            builder: (context, snapshot) {
              Widget _widget;
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _overDueBook = _getOverDueBook(_rentBook);

                  _currentRentBook =
                      _getCurrentRentBook(_rentBook, _overDueBook);
                  _list = [
                    _tag("assets/images/borrowing.webp", "在借的图书",
                        Colors.green[300], _currentRentBook),
                    _tag("assets/images/beyond_time.webp", "超期的图书",
                        Colors.red[300], _overDueBook),
                    _tag("assets/images/history_book.webp", "历史图书",
                        Colors.orange[100], _historyRentBook),
                  ];
                  HubUtil.dismiss();
                  _widget = ListView(
                    children: _list,
                  );
                  break;
                case ConnectionState.none:
                  _widget = Center(
                    child: Text(
                      "加载失败，请检查网络～",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  );
                  break;
                case ConnectionState.waiting:
                  HubUtil.show();
                  _widget = SizedBox();
                  break;
                case ConnectionState.active:
                  break;
              }
              return _widget;
            }),
      ),
    );
  }

  _tag(String imageUrl, String title, Color color, dynamic list) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    imageUrl,
                    height: 30,
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 20,
                    minWidth: 20,
                  ),
                  child: Text(
                    list.length.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
        list.length != 0
            ? ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      BaseNavigator.getInstance().onJumpTo(
                          RouteStatus.libraryBookDetails,
                          args: {"url": list[index].bookUrl});
                    },
                    child: Column(
                      children: [
                        ..._title
                            .map((e) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: ScreenUtil.getInstance()
                                                  .screenWidth *
                                              0.3,
                                          margin: EdgeInsets.only(
                                              top: 5,
                                              right: 20,
                                              left: 20,
                                              bottom: 5),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _getData(e, index, list),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                              // overflow:
                                              //     TextOverflow.ellipsis
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            .toList(),
                        Divider(
                          color: Colors.blueGrey,
                          height: 0,
                          thickness: 0.3,
                        ),
                      ],
                    ),
                  );
                })
            : Container(
                height: 0,
              ),
      ],
    );
  }

  //在这里判断哪些借阅的书籍超期
  _getOverDueBook(List<CurrentRentBook> list) {
    List<CurrentRentBook> _overDueBook = [];

    if (list != null && list.length != 0) {
      list.forEach((element) {
        List<int> time =
            element.returnTime.split('-').map((e) => int.parse(e)).toList();
        if ((DateTime(time[0], time[1], time[2]).millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch) <
            0) {
          _overDueBook.add(element);
        }
      });
    }

    return _overDueBook;
  }

  //得到正在借阅的图书
  _getCurrentRentBook(List<CurrentRentBook> currentRentBook,
      List<CurrentRentBook> overDueBook) {
    if (currentRentBook != null)
      List<CurrentRentBook> _currentRentBook = [...currentRentBook];

    if (_overDueBook != null) {
      _overDueBook.forEach((element) {
        _currentRentBook.remove(element);
      });
    }
    return _currentRentBook;
  }

  //匹配对应的数据
  _getData(String key, int index, dynamic list) {
    dynamic value;
    Map<String, dynamic> _maps = {};
    if (list != null) {
      _maps = {
        "条码号": list[index].bookCode,
        "题名/责任者": list[index].bookName,
        "借阅日期": list[index].rentTime,
        "应还日期": list[index].returnTime,
        "馆藏地": list[index].bookPlace
      };
    }
    value = _maps[key];
    return value.toString();
  }
}

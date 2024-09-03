import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/pages/home_page/index_page.dart';
import 'package:wust_helper_ios/pages/mine_page/mine_page.dart';
import 'package:wust_helper_ios/pages/news_page.dart';
import 'package:wust_helper_ios/pages/schedule_page/schedule_page.dart';
import 'package:wust_helper_ios/pages/volunteer_page/volunteer_page.dart';
import 'package:wust_helper_ios/util/common.dart';

// ignore: must_be_immutable
class BottomNavigator extends StatefulWidget {
  final initialPage;
  Function firstLoad;
  BottomNavigator({Key key, this.initialPage, this.firstLoad})
      : super(key: key);
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator>
    with AutomaticKeepAliveClientMixin {
  final _activeColor = Colors.green;
  bool isFirstLoad = true;
  int _currentIndex;
  PageController _controller;
  int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
  // int loginIndex = 0;
  final bottomIconList = [
    Image.asset('assets/images/ic_home_normal.webp'),
    Image.asset('assets/images/volunteering.webp'),
    Image.asset('assets/images/ic_course_normal.webp'),
    Image.asset('assets/images/news.webp'),
    Image.asset('assets/images/ic_mine_normal.webp')
  ];
  final bottomActiveIconList = [
    Image.asset('assets/images/ic_home_checked.webp'),
    Image.asset('assets/images/volunteering_active.webp'),
    Image.asset('assets/images/ic_course_checked.webp'),
    Image.asset('assets/images/news_active.webp'),
    Image.asset('assets/images/ic_mine_checked.webp')
  ];
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Function firstLoad = widget.firstLoad;
    // Function firstLoad = () => showToast("msg");
    widget.firstLoad = () {};

    isFirstLoad
        ? _currentIndex = widget.initialPage ?? (loginIndex == 0 ? 2 : 1)
        : _currentIndex = this._currentIndex;
    isFirstLoad = false;
    _controller = PageController(
        initialPage: loginIndex == 0
            ? (widget.initialPage ?? 2)
            : (widget.initialPage ?? 1));
    return Scaffold(
      body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: loginIndex == 0 ? 5 : 4,
          //itemCount: loginIndex == 0 ? 5 : 4,
          itemBuilder: (context, index) {
            return _page(index, loginIndex, firstLoad);
          }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          // backgroundColor: Colors.black54,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _activeColor,
          items: item(loginIndex)
          // _createItem('主页', bottomIconList[0], bottomActiveIconList[0]),
          // _createItem('志愿者', bottomIconList[1], bottomActiveIconList[1]),
          // _createItem('课程表', bottomIconList[2], bottomActiveIconList[2]),
          // _createItem('校园', bottomIconList[3], bottomActiveIconList[3]),
          // _createItem('我', bottomIconList[4], bottomActiveIconList[4]),
          ),
    );
  }

  _page(int index, int loginIndex, Function firstLoad) {
    List<Widget> pagesStu = [
      IndexPage(),
      VolunteerPage(),
      SchedulePage(
        firstLoad: firstLoad,
      ),
      NewsPage(),
      MinePage()
    ];
    List<Widget> pagesGraStu = [
      IndexPage(),
      SchedulePage(
        firstLoad: firstLoad,
      ),
      NewsPage(),
      MinePage()
    ];
    return loginIndex == 0 ? pagesStu[index] : pagesGraStu[index];
    // loginIndex == 0 ? pagesStu[index] : pagesGraStu[index];
  }

  item(int index) {
    List<BottomNavigationBarItem> itemStu = [
      _createItem('主页', bottomIconList[0], bottomActiveIconList[0]),
      _createItem('志愿者', bottomIconList[1], bottomActiveIconList[1]),
      _createItem('课程表', bottomIconList[2], bottomActiveIconList[2]),
      _createItem('校园', bottomIconList[3], bottomActiveIconList[3]),
      _createItem('我', bottomIconList[4], bottomActiveIconList[4]),
    ];
    List<BottomNavigationBarItem> itemGraStu = [
      _createItem('主页', bottomIconList[0], bottomActiveIconList[0]),
      _createItem('课程表', bottomIconList[2], bottomActiveIconList[2]),
      _createItem('校园', bottomIconList[3], bottomActiveIconList[3]),
      _createItem('我', bottomIconList[4], bottomActiveIconList[4]),
    ];
    return index == 0 ? itemStu : itemGraStu;
    // loginIndex == 0 ? itemStu[index] : itemGraStu[index];
  }

  _createItem(String title, Image icon, Image activeIcon) {
    return BottomNavigationBarItem(
        backgroundColor: Colors.amber,
        icon: SizedBox(
          height: 24,
          child: icon,
        ),
        activeIcon: SizedBox(
          height: 24,
          child: activeIcon,
        ),
        label: title);
  }
}

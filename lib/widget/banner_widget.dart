import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wust_helper_ios/model/get_banner_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/banner_util.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({Key key}) : super(key: key);

  @override
  _BannerCardState createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard>
    with AutomaticKeepAliveClientMixin {
  List<Data> list = [];
  // Future _bannerFuture;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // _bannerFuture =
    _getBannerRequest();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(height: 140, child: _banner());
  }

  Widget _banner() {
    return Container(
      child: Swiper(
        //多加一层判断防止用户在使用时突然无网络导致加载不出图片的现象
        itemCount: list == null ? 1 : list.length + 1,
        autoplay: list != null && list.length != 0,
        autoplayDisableOnInteraction: true, //当用户拖动时停止播放
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //设置圆角(避免轮播图滚动时，图片会瞬间填充Container的问题，所以对Container也进行装饰)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            margin: EdgeInsets.only(right: 10.0, left: 10.0),
            //对图片进行裁剪(圆角)
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
              child: index == 0
                  ? GestureDetector(
                      onTap: () {
                        BaseNavigator.getInstance()
                            .onJumpTo(RouteStatus.feedback);
                      },
                      child: Image.asset(
                        "assets/images/bannerImage.png",
                        fit: BoxFit.fill,
                      ),
                    )
                  : _bannerImage(
                      imageUrl: list[index - 1].imgUrl,
                      bannerContentUrl: list[index - 1].bannerContentUrl,
                    ),
            ),
          );
        },
      ),
    );
  }

  _getBannerRequest() async {
    List<Data> bannerList;
    bannerList = await sendBannerRequest(context);
    setState(() {
      list = bannerList;
    });
  }

  _bannerImage({String imageUrl, String bannerContentUrl}) {
    if (imageUrl != null && bannerContentUrl != null) {
      return GestureDetector(
        onTap: () {
          BaseNavigator.getInstance().onJumpTo(RouteStatus.bannercard,
              args: {"bannerContentUrl": bannerContentUrl});
        },
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}

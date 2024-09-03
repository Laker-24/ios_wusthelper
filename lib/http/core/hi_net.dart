/*

    网络层

*/

import 'package:wust_helper_ios/http/core/dio_adapter.dart';
import 'package:wust_helper_ios/http/core/hi_error.dart';
import 'package:wust_helper_ios/http/core/base_net_adapter.dart';
import 'package:wust_helper_ios/http/request/base_request.dart';

///网络层
class HiNet {
  HiNet._();
  static HiNet _instance;
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

  Future fire(BaseRequest request) async {
    BaseNetResponse response; //返回请求
    var error; //异常

    try {
      ///发送请求
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e?.data;
      _printLog("HiError:${e.toString()}");
    } catch (e) {
      error = e;
      response = e?.data;
    }

    if (response == null) {
      _printLog(error);
    }

    ///解析 Http 状态码

    switch (response.statusCode) {
      case 200:
        print(' 这里：${response.data}');
        return response.data;
      case 312:
        return response.data;
      default:
        throw JwcBoomError("jwcBoom");
    }
  }

  ///网络请求方法
  Future<dynamic> send<T>(BaseRequest request) async {
    ///第三方库适配
    BaseNetAdepter adepter = DioAdapter();
    return adepter.send(request);
  }

  _printLog(log) {
    print("hi_net: ${log.toString()}");
  }
}

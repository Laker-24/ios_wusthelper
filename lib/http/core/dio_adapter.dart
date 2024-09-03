/*

    Dio 适配层

*/

import 'package:dio/dio.dart';

import 'package:wust_helper_ios/http/request/base_request.dart';
import 'hi_error.dart';
import 'base_net_adapter.dart';

const String CONTENT_TYPE = "application/x-www-form-urlencoded"; //请求数据格式
const String PLATFORM = "ios";

class DioAdapter extends BaseNetAdepter {
  @override
  Future<BaseNetResponse<T>> send<T>(BaseRequest request) async {
    var response,
        options = Options(
          headers: request.headers,
          //  contentType: CONTENT_TYPE
        );
    //设置请求超时时间20s
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: 20000,
      receiveTimeout: 20000,
    );
    Dio dio = Dio(baseOptions);
    var error;
    if (request.httpStyles() == HttpStyles.JWC) {
      request
          .addHeaders("Content-type", CONTENT_TYPE)
          .addHeaders("Platform", PLATFORM);
    } else if (request.httpStyles() == HttpStyles.WLSY) {
      request.addHeaders("Content-type", CONTENT_TYPE);
    } else if (request.httpStyles() == HttpStyles.YJS) {
      request.addHeaders("content-type", CONTENT_TYPE);
    }

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await dio.get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        if (request.httpStyles() == HttpStyles.YJS) {
          response = await dio.post(request.url(),
              data: request.params, options: options);
        } else {
          response = await dio.post(request.url(),
              data: request.params, options: options);
        }
      }
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      print("DioError: HiNetError--${e.toString()}");
    } catch (e) {
      error = e;
      print("DioError: ${e.toString()}");
    }

    ///

    if (error != null) {
      ///如有异常，抛出
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }

    return buildRes(response, request);
  }
}

///构建 HiNetResponse
BaseNetResponse buildRes(Response response, BaseRequest request) {
  return BaseNetResponse(
      data: response.data,
      request: request,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extraData: response);
}

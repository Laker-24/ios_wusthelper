import 'package:wust_helper_ios/http/request/base_request.dart';
import 'base_net_adapter.dart';

// 模拟数据
class MockAdapter extends BaseNetAdepter {
  @override
  Future<BaseNetResponse<T>> send<T>(BaseRequest request) {
    return Future<BaseNetResponse>.delayed(Duration(milliseconds: 1000), () {
      return BaseNetResponse(
          data: {"code": 0, "message": "success"}, statusCode: 200);
    });
  }
}

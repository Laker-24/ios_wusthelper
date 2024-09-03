/*
 * 
 *        失物招领提示弹窗
 *        
 */

import 'package:wust_helper_ios/http/request/base_request.dart';

///每次进入主界面进行获取，如有则进行提示
class LostTipsUnReadRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String authority() {
    // TODO: implement authority
    return "neolaf.lensfrex.net/api/v1";
  }

  @override
  String path() {
    return "message/unread";
  }

  @override
  String url() {
    return "https://" + authority() + '/' + path();
  }
}

//当我们选择不再提醒，后台会自动销毁这条记录
class LostTipsReadRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String authority() {
    // TODO: implement authority
    return "neolaf.lensfrex.net/api/v1";
  }

  @override
  String path() {
    return "message/mark";
  }

  @override
  String url() {
    return "https://" + authority() + '/' + path();
  }
}

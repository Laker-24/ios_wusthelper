import 'package:wust_helper_ios/http/request/base_request.dart';

/*
 *  
 *        增添收藏图书
 * 
 */
class LibraryAddCollectionRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "mobileapi/v2/lib/add-collection";
  }

  @override
  HttpStyles httpStyles() {
    // TODO: implement httpStyles
    return HttpStyles.LH;
  }
}

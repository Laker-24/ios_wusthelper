/*
 * 
 *    封装的底层网络请求，所有请求request的基类
 * 
 */

///请求方法枚举类
enum HttpMethod { GET, POST }

///请求哪种接口  【JWC教务处模块，LH业务模块，YJS研究生模块,WLSY物理实验系统模块】
enum HttpStyles { JWC, LH, YJS, WLSY }

///基础网络请求格式
abstract class BaseRequest {
  //路径参数
  var pathParams;
  //使用 https ，否则使用 http
  bool useHttps = true;
  String authority() {
    return "wusthelper.wustlinghang.cn";
  }

  /* 请求方法 */
  HttpMethod httpMethod();
  /*请求哪种接口 */
  HttpStyles httpStyles() {
    //默认为教务处
    return HttpStyles.JWC;
  }

  //查询参数
  Map<String, String> params = Map();

  /* 短路径 */
  String path();
  /* 拼接Url */
  String url() {
    Uri uri;
    var pathStr = path();
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    return uri.toString();
  }

  //是否需要登陆
  bool needLogin();

  BaseRequest add(String key, dynamic value) {
    params[key] = value.toString();
    return this;
  }

  //请求头
  Map<String, String> headers = Map();

  BaseRequest addHeaders(String key, dynamic value) {
    headers[key] = value.toString();
    return this;
  }
}

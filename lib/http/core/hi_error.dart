/*

    Error 统一逻辑处理层

*/
///[本科生相关]
///30101
///教务处登录失败:账号或密码错误
class CodeWrongError extends HiNetError {
  CodeWrongError(String messagge, {int code = 30101}) : super(code, messagge);
}

///30102
///教务处登录失败:需用户前往教务处修改默认密码
class DefalutCodeNeedChangeError extends HiNetError {
  DefalutCodeNeedChangeError(String messagge, {int code = 30102})
      : super(code, messagge);
}

///30103
///教务登录失败:教务崩溃|本地登录失败:本地账号或密码错误
class JwcBoomOrLocalCodeError extends HiNetError {
  JwcBoomOrLocalCodeError(String messagge, {int code = 30103})
      : super(code, messagge);
}

///30104
///登录失败:教务系统异常，请重试
class JwcBoomError extends HiNetError {
  JwcBoomError(String messagge, {int code = 30104}) : super(code, messagge);
}

///[物理实验]
///70101
///获取已选实验课失败：实验系统官网异常
class WlsyLoginError extends HiNetError {
  WlsyLoginError(String message, {int code = 70101}) : super(code, message);
}

///网络异常统一格式
class HiNetError implements Exception {
  final int code; //状态码
  final String message; //状态信息
  final dynamic data;

  HiNetError(this.code, this.message, {this.data});
}

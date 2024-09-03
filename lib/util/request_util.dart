///请求是否成功
bool isSuccessful(Map result) {
  if (result['code'] == 10000 || result['code'] == 11000) {
    return true;
  }
  return false;
}

bool wustyjsIsSuccessful(Map result) {
  if (result['code'] == 70000) {
    return true;
  }
  return false;
}

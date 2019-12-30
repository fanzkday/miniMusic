import 'package:dio/dio.dart';

Dio _dio = new Dio(BaseOptions(
  baseUrl: 'http://www.lovecf.cn/cloudapi',
  connectTimeout: 5000,
  receiveTimeout: 10000,
));

List cookies = [];

request({String url, String method, dynamic data, bool isLogin = false}) async {
  Response response = await _dio.request(
    url,
    data: data,
    options: Options(
      method: method,
      receiveDataWhenStatusError: true,
      followRedirects: false,
      validateStatus: (int code) {
        return true;
      },
      headers: {'cookie': cookies.join(';')},
    ),
  );
  if (response.statusCode == 200) {
    if (isLogin) {
      cookies = response.headers['set-cookie'];
    }
    return response.data;
  }
  print('http请求失败: ${response.statusCode}');
  return response.data;
}

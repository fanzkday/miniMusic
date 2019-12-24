import 'package:dio/dio.dart';

Dio _dio = new Dio(BaseOptions(
  baseUrl: 'http://www.lovecf.cn/cloudapi',
  connectTimeout: 5000,
  receiveTimeout: 10000,
));

request({String url, String method, dynamic data}) async {
  Response response = await _dio.request(
    url,
    data: data,
    options: Options(method: method),
  );
  if (response.statusCode == 200) {
    return response.data;
  }
  print('http请求失败: ${response.statusCode}');
  return response.data;
}

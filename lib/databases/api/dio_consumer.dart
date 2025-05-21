// import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
// import 'package:mostaqur_doctor/core/utils/user_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/network/local/user_helper.dart';

import 'api_consumer.dart';
// import 'end_points.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.options.headers['X-Requested-With'] = 'XMLHttpRequest';
    dio.options.headers['accept-tokenapi'] = 'a3b1f4d7e8c9f01234567890abcdef12';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['accept-language'] = 'ar';
    dio.options.followRedirects = false;
    dio.interceptors.addAll([
      // ChuckerDioInterceptor(),
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        enabled: true,
        requestHeader: true,
        request: true,
      )
    ]);
  }
  void _addToken() {
    if (UserHelper.getUserToken() != null) {
      dio.options.headers['Authorization'] =
          'Bearer ${UserHelper.getUserToken()}';
    }
  }

//!POST
  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    _addToken();
    var response = await dio.post(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

//!GET
  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _addToken();
    var res = await dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return res.data;
  }

//!DELETE
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _addToken();
    var res = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return res.data;
  }

//!PATCH
  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    _addToken();
    var res = await dio.patch(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
    );
    return res.data;
  }

  @override
  Future put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    _addToken();
    var response = await dio.put(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future getPdf(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _addToken();
    var res = await dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data;
  }
}

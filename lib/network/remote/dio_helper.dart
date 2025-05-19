import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// const String baseUrl = 'http://zdev.z-laundry.com/public/api/v1/'; // for dev
const String baseUrl =
    'http://app.z-laundry.com/public/api/v1/'; // for production

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          receiveDataWhenStatusError: true,
          contentType: "application/json",
          followRedirects: false,
          responseType: ResponseType.json,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    dio!.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio?.options.validateStatus = (status) => true;
    dio?.options.responseType = ResponseType.json;
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'format-locale': 'ar'
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData(
      {required String? url,
      Map<String, dynamic>? query,
      dynamic data,
      String? token}) async {
    dio?.options.responseType = ResponseType.json;
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'format-locale': 'ar'
    };

    return await dio!.post(
      url!,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> postDataMultipart(
      {String? url,
      dynamic data,
      Map<String, dynamic>? query,
      String? token}) async {
    dio?.options.contentType = 'multipart/form-data';
    dio?.options.responseType = ResponseType.plain;
    dio?.options.validateStatus = (status) => true;
    dio?.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };
    return await dio!.post(url!, data: data, queryParameters: query);
  }

  static Future<Response> updateData(
      {required String? url,
      required Map<String, dynamic>? data,
      Map<String, dynamic>? query,
      String? token}) async {
    dio?.options.responseType = ResponseType.json;
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // debugPrint('req : $data');
    return await dio!.put(url ?? '', data: data, queryParameters: query);
  }

  static Future<Response> deleteData(
      {required String? url,
      Map<String, dynamic>? data,
      Map<String, dynamic>? query,
      required String? token}) async {
    dio?.options.responseType = ResponseType.json;
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await dio!.delete(url!, data: data, queryParameters: query);
  }
}

import 'package:dio/dio.dart';
import '../../helpers/safe_print.dart';
import 'api_constants.dart';
import 'dio_interceptor.dart';

class ApiService {
  static late Dio dio;
  static init() {
    safePrint("Initializing Dio...");
    dio = Dio();
    safePrint("Dio Initialized");
    dio.interceptors.add(DioInterceptor());
    safePrint("Dio Initialized with Interceptor");
  }

  static Future<dynamic> postData({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await dio.post(
        ApiConstants.apiBaseUrl+endPoint,
        data: data,

        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      return (e);
    }
  }

  static Future<dynamic> uploadFile({
    required String endPoint,
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      var response = await dio.post(
        ApiConstants.apiBaseUrl+ endPoint,
        data: formData,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      return (e);
    }
  }

  static Future<dynamic> putData({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      var response = await dio.put(
        ApiConstants.apiBaseUrl+endPoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> patchData({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? token,
    bool isRaw = false,
  }) async {
    try {
      var response = await dio.patch(
        ApiConstants.apiBaseUrl+endPoint,
        data: data == null
            ? null
            : isRaw
                ? data
                : FormData.fromMap(data),
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> deleteData({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      var response = await dio.delete(
        ApiConstants.apiBaseUrl+endPoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> getData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      var response = await dio.get(
        ApiConstants.apiBaseUrl+endPoint,
        queryParameters: queryParameters,
        // options:  Options(
        //     headers: {
        //       'Authorization' : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3ZjYXJlLmludGVncmF0aW9uMjUuY29tL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNzI4Mzk0MDg5LCJleHAiOjE3Mjg0ODA0ODksIm5iZiI6MTcyODM5NDA4OSwianRpIjoiN1RiazNueHhoS0Y5UVlCbCIsInN1YiI6IjIzNDEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.DTU4Gi51tMZZEFdqcZJ5cjg7lxp34C1lKT26SqfTPmA",
        //     }
        // ),
      );
      return response.data;
    } catch (e) {
      return e.toString();
    }
  }
}

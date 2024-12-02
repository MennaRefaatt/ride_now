import 'package:dio/dio.dart';
import '../../helpers/secure_storage/secure_keys.dart';
import '../../helpers/safe_print.dart';
import '../../helpers/secure_storage/secure_storage.dart';
import '../../helpers/shared_pref.dart';
import 'api_constants.dart';
import 'api_error_handler.dart';

class DioInterceptor extends Interceptor {
  Dio dio = Dio(BaseOptions(
    baseUrl: ApiConstants.apiBaseUrl,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Connection": "keep-alive",
      "lang": SharedPref.getCurrentLanguage(),

    },

    connectTimeout: const Duration(minutes: 1),
    sendTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(minutes: 1),
  ));

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    safePrint("Request to: ${options.uri}");

    try {
      String? token = await SecureStorageService.readData(SecureKeys.token);
      safePrint("Token: $token");

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = token;
      }
    } catch (e) {
      safePrint("Failed to read token: $e");
    }

    // Continue with the request
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    safePrint("Error occurred: ${err.toString()}");
    if (err.response != null) {
      safePrint(
          "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} => MESSAGE: ${err.response?.data}");
    } else {
      safePrint(
          "ERROR => PATH: ${err.requestOptions.path} => MESSAGE: ${err.message}");

      ErrorHandler errorHandler = ErrorHandler.handle(
          err, err.message != null ? err.message! : ApiErrors.unknownError);

      handler.resolve(Response(
        requestOptions: err.requestOptions,
        data: {"message": errorHandler.message},
        statusCode: err.response?.statusCode,
      ));
    }
    handler.resolve(Response(
      requestOptions: err.requestOptions,
      data: {"message": err.response?.statusMessage!},
      statusCode: err.response?.statusCode,
    ));
  }
}

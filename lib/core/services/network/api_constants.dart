import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String apiBaseUrl = "";
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? "";
  static String get openRouteServiceApiKey => dotenv.env['OPENROUTE_API_KEY'] ?? "";
  static String get openRouteServiceBaseUrl =>dotenv.env['OPENROUTE_BASE_URL'] ?? "";
  static String get stripePublishableKey =>dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? "";
  static String get stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? "";
}
class AgoraConstants {
  static String get appId => dotenv.env['AGORA_APP_ID'] ?? "";
  static String get token => dotenv.env['AGORA_TOKEN'] ?? "";
  static String get channelId => dotenv.env['AGORA_CHANNEL_ID'] ?? "";
  static String get serverUrl => dotenv.env['SERVER_URL'] ?? "";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}

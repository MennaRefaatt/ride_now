class ApiConstants {
  static const String apiBaseUrl = "https://student.valuxapps.com/api/";
}
class EndPoints {
  static const String login = 'login';
  static const String register = "register";
  static const String home = 'home';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String updateProfile = 'update-profile';
  static const String settings = 'settings';
  static const String productDetails = 'products/';
  static const String fAQs = 'faqs';
  static const String changePassword = 'change-password';
  static const String notifications = 'notifications';
  static const String languages = 'languages';
  static const String contactUs = 'contacts';
  static const String complaints = 'complaints';
  static const String logout = 'logout';
  static const String categoryDetails = 'categories/';
  static const String favorites = 'favorites';
  static const String cart = 'carts';
  static const String cartAdd = 'carts';
  static const String cartDelete = 'carts/';
  static const String cartUpdate = 'carts/';
  static const String address = 'addresses';
  static const String addressUpdate = 'addresses/';
  static const String addressDelete = 'addresses/';
  static const String search = 'products/search';
  static const String addOrders = 'orders';
  static const String getOrders = 'orders';
  static const String getOrderDetails = 'orders/';
  // Dynamic endpoint for cancelling an order
  static String cancelOrder(int orderId) => 'orders/$orderId/cancel';
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

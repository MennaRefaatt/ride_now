class SocketConstants {
  static String get chatBaseUrl => 'http://192.168.1.23:3000';
  static String get socketUrl => 'http://192.168.1.23'; // Replace localhost with your machine's IP
  static String get chatMessageEndpoint => '/api/messages/:';
  static const String getRoomIdEndpoint = '/getRoomId'; // The endpoint to get roomId

}


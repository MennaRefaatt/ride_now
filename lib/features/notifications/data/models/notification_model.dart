import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String senderId;
  final String receiverId;
  final String receiverDeviceToken;
  bool isRead;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.senderId,
    required this.receiverId,
    required this.receiverDeviceToken,
    required this.isRead,
    required this.timestamp,
  });
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? senderId,
    String? receiverId,
    String? deviceToken,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      receiverDeviceToken: deviceToken ?? this.receiverDeviceToken,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      receiverDeviceToken: data['receiverDeviceToken'] ?? '',
      isRead: data['isRead'] ?? false,
      timestamp: (data['timestamp'] != null && data['timestamp'] is Timestamp)
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'senderId': senderId,
      'receiverId': receiverId,
      'receiverDeviceToken': receiverDeviceToken,
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }
}

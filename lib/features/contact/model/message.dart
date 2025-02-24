import 'package:freezed_annotation/freezed_annotation.dart';
part 'message.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String message;
  final String createdAt;
  final String userId;
  final String roomId;
  final String userName;
  final String userImage;
   bool isRead;

  MessageModel({
    required this.userId,
    required this.id,
    required this.message,
    required this.createdAt,
    required this.roomId,
    required this.userName,
    required this.userImage,
    required this.isRead,
  });

  // Factory constructor to create a MessageModel instance from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  // Convert the MessageModel instance to a JSON object
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
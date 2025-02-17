// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      userId: json['userId'] as String,
      id: json['id'] as String,
      message: json['message'] as String,
      createdAt: json['createdAt'] as String,
      roomId: json['roomId'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'createdAt': instance.createdAt,
      'userId': instance.userId,
      'roomId': instance.roomId,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'isRead': instance.isRead,
    };

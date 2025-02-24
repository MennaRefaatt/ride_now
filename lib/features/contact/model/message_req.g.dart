// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReq _$MessageReqFromJson(Map<String, dynamic> json) => MessageReq(
      message: json['message'] as String,
      id: json['userId'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$MessageReqToJson(MessageReq instance) =>
    <String, dynamic>{
      'message': instance.message,
      'createdAt': instance.createdAt,
      'userId': instance.id,
    };

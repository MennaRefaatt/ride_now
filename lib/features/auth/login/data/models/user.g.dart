// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      phoneNumber: json['phoneNumber'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      city: json['city'] as String?,
      type: json['type'] as String?,
      photoUrl: json['photoUrl'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'city': instance.city,
      'type': instance.type,
    };

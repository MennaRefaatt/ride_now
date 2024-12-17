import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String phoneNumber;

  UserModel( {required this.phoneNumber,
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

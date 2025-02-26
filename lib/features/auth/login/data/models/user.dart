import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../rating/data/models/rating_model.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String phoneNumber;
  final String? city;
  final String? type;
  final String? currentTripId;
  final String? deviceToken;
  final RatingModel? rating;
  final int ratingGivenCount;
  UserModel({
    required this.phoneNumber,
    required this.uid,
    required this.name,
    required this.email,
    required this.city,
    required this.type,
    required this.photoUrl,
    required this.currentTripId,
    required this.deviceToken,
    this.rating,
    this.ratingGivenCount = 0
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}


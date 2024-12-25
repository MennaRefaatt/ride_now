import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String photoUrl;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

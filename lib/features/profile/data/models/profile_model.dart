import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String uid;
  final String name;
  final String email;
  late String phoneNumber;
  final String photoUrl;
  final String? city;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.city,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
  ProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? city,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
    );
  }
}

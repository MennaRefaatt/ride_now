import 'package:freezed_annotation/freezed_annotation.dart';
part 'city_model.g.dart';
@JsonSerializable()
class CityModel {
  final String cityName;
  CityModel({required this.cityName});
  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  final double rating;
  final int ratingCount;
  final String comment;

  RatingModel({
    required this.rating,
    required this.ratingCount,
    this.comment = '',
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
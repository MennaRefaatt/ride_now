// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
      rating: (json['rating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      comment: json['comment'] as String? ?? '',
    );

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'comment': instance.comment,
    };

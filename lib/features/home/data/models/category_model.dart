import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String name;
  final String image;
  final String description;
  final String id;
  CategoryModel(
      {required this.name,
      required this.image,
      required this.description,
      required this.id});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

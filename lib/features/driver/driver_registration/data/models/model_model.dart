import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_model.freezed.dart';
part 'model_model.g.dart';

@freezed
class ModelModel with _$ModelModel {
  const factory ModelModel({
    required String name,
  }) = _ModelModel;

  factory ModelModel.fromJson(Map<String, dynamic> json) =>
      _$ModelModelFromJson(json);
}

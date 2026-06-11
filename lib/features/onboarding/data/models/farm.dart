// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm.freezed.dart';
part 'farm.g.dart';

@freezed
class Farm with _$Farm {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Farm({
    required String id,
    required String name,
    String? location,
    required String farmType,
    DateTime? createdAt,
  }) = _Farm;

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);
}

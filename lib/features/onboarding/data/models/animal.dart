// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_collar_app/core/utils/json_converters.dart';

part 'animal.freezed.dart';
part 'animal.g.dart';

@freezed
class Animal with _$Animal {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Animal({
    required String id,
    required String farmId,
    required String animalTag,
    required String species,
    required String sex,
    @JsonKey(fromJson: nullableIntFromJson) int? ageMonths,
    @JsonKey(fromJson: nullableDoubleFromJson) double? weightKg,
    String? notes,
    DateTime? createdAt,
  }) = _Animal;

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
}

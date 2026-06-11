// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

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
    int? ageMonths,
    double? weightKg,
    String? notes,
    DateTime? createdAt,
  }) = _Animal;

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalImpl _$$AnimalImplFromJson(Map<String, dynamic> json) => _$AnimalImpl(
  id: json['id'] as String,
  farmId: json['farm_id'] as String,
  animalTag: json['animal_tag'] as String,
  species: json['species'] as String,
  sex: json['sex'] as String,
  ageMonths: nullableIntFromJson(json['age_months']),
  weightKg: nullableDoubleFromJson(json['weight_kg']),
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$AnimalImplToJson(_$AnimalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farm_id': instance.farmId,
      'animal_tag': instance.animalTag,
      'species': instance.species,
      'sex': instance.sex,
      'age_months': instance.ageMonths,
      'weight_kg': instance.weightKg,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };

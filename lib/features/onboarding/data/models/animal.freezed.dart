// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Animal _$AnimalFromJson(Map<String, dynamic> json) {
  return _Animal.fromJson(json);
}

/// @nodoc
mixin _$Animal {
  String get id => throw _privateConstructorUsedError;
  String get farmId => throw _privateConstructorUsedError;
  String get animalTag => throw _privateConstructorUsedError;
  String get species => throw _privateConstructorUsedError;
  String get sex => throw _privateConstructorUsedError;
  @JsonKey(fromJson: nullableIntFromJson)
  int? get ageMonths => throw _privateConstructorUsedError;
  @JsonKey(fromJson: nullableDoubleFromJson)
  double? get weightKg => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Animal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimalCopyWith<Animal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalCopyWith<$Res> {
  factory $AnimalCopyWith(Animal value, $Res Function(Animal) then) =
      _$AnimalCopyWithImpl<$Res, Animal>;
  @useResult
  $Res call({
    String id,
    String farmId,
    String animalTag,
    String species,
    String sex,
    @JsonKey(fromJson: nullableIntFromJson) int? ageMonths,
    @JsonKey(fromJson: nullableDoubleFromJson) double? weightKg,
    String? notes,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$AnimalCopyWithImpl<$Res, $Val extends Animal>
    implements $AnimalCopyWith<$Res> {
  _$AnimalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? animalTag = null,
    Object? species = null,
    Object? sex = null,
    Object? ageMonths = freezed,
    Object? weightKg = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            farmId: null == farmId
                ? _value.farmId
                : farmId // ignore: cast_nullable_to_non_nullable
                      as String,
            animalTag: null == animalTag
                ? _value.animalTag
                : animalTag // ignore: cast_nullable_to_non_nullable
                      as String,
            species: null == species
                ? _value.species
                : species // ignore: cast_nullable_to_non_nullable
                      as String,
            sex: null == sex
                ? _value.sex
                : sex // ignore: cast_nullable_to_non_nullable
                      as String,
            ageMonths: freezed == ageMonths
                ? _value.ageMonths
                : ageMonths // ignore: cast_nullable_to_non_nullable
                      as int?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnimalImplCopyWith<$Res> implements $AnimalCopyWith<$Res> {
  factory _$$AnimalImplCopyWith(
    _$AnimalImpl value,
    $Res Function(_$AnimalImpl) then,
  ) = __$$AnimalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String farmId,
    String animalTag,
    String species,
    String sex,
    @JsonKey(fromJson: nullableIntFromJson) int? ageMonths,
    @JsonKey(fromJson: nullableDoubleFromJson) double? weightKg,
    String? notes,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$AnimalImplCopyWithImpl<$Res>
    extends _$AnimalCopyWithImpl<$Res, _$AnimalImpl>
    implements _$$AnimalImplCopyWith<$Res> {
  __$$AnimalImplCopyWithImpl(
    _$AnimalImpl _value,
    $Res Function(_$AnimalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? animalTag = null,
    Object? species = null,
    Object? sex = null,
    Object? ageMonths = freezed,
    Object? weightKg = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$AnimalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        farmId: null == farmId
            ? _value.farmId
            : farmId // ignore: cast_nullable_to_non_nullable
                  as String,
        animalTag: null == animalTag
            ? _value.animalTag
            : animalTag // ignore: cast_nullable_to_non_nullable
                  as String,
        species: null == species
            ? _value.species
            : species // ignore: cast_nullable_to_non_nullable
                  as String,
        sex: null == sex
            ? _value.sex
            : sex // ignore: cast_nullable_to_non_nullable
                  as String,
        ageMonths: freezed == ageMonths
            ? _value.ageMonths
            : ageMonths // ignore: cast_nullable_to_non_nullable
                  as int?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$AnimalImpl implements _Animal {
  const _$AnimalImpl({
    required this.id,
    required this.farmId,
    required this.animalTag,
    required this.species,
    required this.sex,
    @JsonKey(fromJson: nullableIntFromJson) this.ageMonths,
    @JsonKey(fromJson: nullableDoubleFromJson) this.weightKg,
    this.notes,
    this.createdAt,
  });

  factory _$AnimalImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalImplFromJson(json);

  @override
  final String id;
  @override
  final String farmId;
  @override
  final String animalTag;
  @override
  final String species;
  @override
  final String sex;
  @override
  @JsonKey(fromJson: nullableIntFromJson)
  final int? ageMonths;
  @override
  @JsonKey(fromJson: nullableDoubleFromJson)
  final double? weightKg;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Animal(id: $id, farmId: $farmId, animalTag: $animalTag, species: $species, sex: $sex, ageMonths: $ageMonths, weightKg: $weightKg, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.animalTag, animalTag) ||
                other.animalTag == animalTag) &&
            (identical(other.species, species) || other.species == species) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.ageMonths, ageMonths) ||
                other.ageMonths == ageMonths) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    farmId,
    animalTag,
    species,
    sex,
    ageMonths,
    weightKg,
    notes,
    createdAt,
  );

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalImplCopyWith<_$AnimalImpl> get copyWith =>
      __$$AnimalImplCopyWithImpl<_$AnimalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalImplToJson(this);
  }
}

abstract class _Animal implements Animal {
  const factory _Animal({
    required final String id,
    required final String farmId,
    required final String animalTag,
    required final String species,
    required final String sex,
    @JsonKey(fromJson: nullableIntFromJson) final int? ageMonths,
    @JsonKey(fromJson: nullableDoubleFromJson) final double? weightKg,
    final String? notes,
    final DateTime? createdAt,
  }) = _$AnimalImpl;

  factory _Animal.fromJson(Map<String, dynamic> json) = _$AnimalImpl.fromJson;

  @override
  String get id;
  @override
  String get farmId;
  @override
  String get animalTag;
  @override
  String get species;
  @override
  String get sex;
  @override
  @JsonKey(fromJson: nullableIntFromJson)
  int? get ageMonths;
  @override
  @JsonKey(fromJson: nullableDoubleFromJson)
  double? get weightKg;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimalImplCopyWith<_$AnimalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

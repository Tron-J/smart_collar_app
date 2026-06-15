// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Collar _$CollarFromJson(Map<String, dynamic> json) {
  return _Collar.fromJson(json);
}

/// @nodoc
mixin _$Collar {
  String get id => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String? get farmId => throw _privateConstructorUsedError;
  String? get animalId => throw _privateConstructorUsedError;
  String? get firmwareVersion => throw _privateConstructorUsedError;
  @JsonKey(fromJson: nullableIntFromJson)
  int? get batteryPct => throw _privateConstructorUsedError;
  @JsonKey(fromJson: nullableIntFromJson)
  int? get wifiRssi => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Collar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollarCopyWith<Collar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollarCopyWith<$Res> {
  factory $CollarCopyWith(Collar value, $Res Function(Collar) then) =
      _$CollarCopyWithImpl<$Res, Collar>;
  @useResult
  $Res call({
    String id,
    String deviceId,
    String? farmId,
    String? animalId,
    String? firmwareVersion,
    @JsonKey(fromJson: nullableIntFromJson) int? batteryPct,
    @JsonKey(fromJson: nullableIntFromJson) int? wifiRssi,
    DateTime? lastSeen,
    bool isOnline,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$CollarCopyWithImpl<$Res, $Val extends Collar>
    implements $CollarCopyWith<$Res> {
  _$CollarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? farmId = freezed,
    Object? animalId = freezed,
    Object? firmwareVersion = freezed,
    Object? batteryPct = freezed,
    Object? wifiRssi = freezed,
    Object? lastSeen = freezed,
    Object? isOnline = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            farmId: freezed == farmId
                ? _value.farmId
                : farmId // ignore: cast_nullable_to_non_nullable
                      as String?,
            animalId: freezed == animalId
                ? _value.animalId
                : animalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            firmwareVersion: freezed == firmwareVersion
                ? _value.firmwareVersion
                : firmwareVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
            batteryPct: freezed == batteryPct
                ? _value.batteryPct
                : batteryPct // ignore: cast_nullable_to_non_nullable
                      as int?,
            wifiRssi: freezed == wifiRssi
                ? _value.wifiRssi
                : wifiRssi // ignore: cast_nullable_to_non_nullable
                      as int?,
            lastSeen: freezed == lastSeen
                ? _value.lastSeen
                : lastSeen // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$CollarImplCopyWith<$Res> implements $CollarCopyWith<$Res> {
  factory _$$CollarImplCopyWith(
    _$CollarImpl value,
    $Res Function(_$CollarImpl) then,
  ) = __$$CollarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String deviceId,
    String? farmId,
    String? animalId,
    String? firmwareVersion,
    @JsonKey(fromJson: nullableIntFromJson) int? batteryPct,
    @JsonKey(fromJson: nullableIntFromJson) int? wifiRssi,
    DateTime? lastSeen,
    bool isOnline,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$CollarImplCopyWithImpl<$Res>
    extends _$CollarCopyWithImpl<$Res, _$CollarImpl>
    implements _$$CollarImplCopyWith<$Res> {
  __$$CollarImplCopyWithImpl(
    _$CollarImpl _value,
    $Res Function(_$CollarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? farmId = freezed,
    Object? animalId = freezed,
    Object? firmwareVersion = freezed,
    Object? batteryPct = freezed,
    Object? wifiRssi = freezed,
    Object? lastSeen = freezed,
    Object? isOnline = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CollarImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        farmId: freezed == farmId
            ? _value.farmId
            : farmId // ignore: cast_nullable_to_non_nullable
                  as String?,
        animalId: freezed == animalId
            ? _value.animalId
            : animalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        firmwareVersion: freezed == firmwareVersion
            ? _value.firmwareVersion
            : firmwareVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        batteryPct: freezed == batteryPct
            ? _value.batteryPct
            : batteryPct // ignore: cast_nullable_to_non_nullable
                  as int?,
        wifiRssi: freezed == wifiRssi
            ? _value.wifiRssi
            : wifiRssi // ignore: cast_nullable_to_non_nullable
                  as int?,
        lastSeen: freezed == lastSeen
            ? _value.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$CollarImpl implements _Collar {
  const _$CollarImpl({
    required this.id,
    required this.deviceId,
    this.farmId,
    this.animalId,
    this.firmwareVersion,
    @JsonKey(fromJson: nullableIntFromJson) this.batteryPct,
    @JsonKey(fromJson: nullableIntFromJson) this.wifiRssi,
    this.lastSeen,
    this.isOnline = false,
    this.createdAt,
  });

  factory _$CollarImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollarImplFromJson(json);

  @override
  final String id;
  @override
  final String deviceId;
  @override
  final String? farmId;
  @override
  final String? animalId;
  @override
  final String? firmwareVersion;
  @override
  @JsonKey(fromJson: nullableIntFromJson)
  final int? batteryPct;
  @override
  @JsonKey(fromJson: nullableIntFromJson)
  final int? wifiRssi;
  @override
  final DateTime? lastSeen;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Collar(id: $id, deviceId: $deviceId, farmId: $farmId, animalId: $animalId, firmwareVersion: $firmwareVersion, batteryPct: $batteryPct, wifiRssi: $wifiRssi, lastSeen: $lastSeen, isOnline: $isOnline, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.animalId, animalId) ||
                other.animalId == animalId) &&
            (identical(other.firmwareVersion, firmwareVersion) ||
                other.firmwareVersion == firmwareVersion) &&
            (identical(other.batteryPct, batteryPct) ||
                other.batteryPct == batteryPct) &&
            (identical(other.wifiRssi, wifiRssi) ||
                other.wifiRssi == wifiRssi) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    deviceId,
    farmId,
    animalId,
    firmwareVersion,
    batteryPct,
    wifiRssi,
    lastSeen,
    isOnline,
    createdAt,
  );

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollarImplCopyWith<_$CollarImpl> get copyWith =>
      __$$CollarImplCopyWithImpl<_$CollarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollarImplToJson(this);
  }
}

abstract class _Collar implements Collar {
  const factory _Collar({
    required final String id,
    required final String deviceId,
    final String? farmId,
    final String? animalId,
    final String? firmwareVersion,
    @JsonKey(fromJson: nullableIntFromJson) final int? batteryPct,
    @JsonKey(fromJson: nullableIntFromJson) final int? wifiRssi,
    final DateTime? lastSeen,
    final bool isOnline,
    final DateTime? createdAt,
  }) = _$CollarImpl;

  factory _Collar.fromJson(Map<String, dynamic> json) = _$CollarImpl.fromJson;

  @override
  String get id;
  @override
  String get deviceId;
  @override
  String? get farmId;
  @override
  String? get animalId;
  @override
  String? get firmwareVersion;
  @override
  @JsonKey(fromJson: nullableIntFromJson)
  int? get batteryPct;
  @override
  @JsonKey(fromJson: nullableIntFromJson)
  int? get wifiRssi;
  @override
  DateTime? get lastSeen;
  @override
  bool get isOnline;
  @override
  DateTime? get createdAt;

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollarImplCopyWith<_$CollarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

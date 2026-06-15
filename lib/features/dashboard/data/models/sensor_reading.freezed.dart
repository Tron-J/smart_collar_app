// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SensorReading _$SensorReadingFromJson(Map<String, dynamic> json) {
  return _SensorReading.fromJson(json);
}

/// @nodoc
mixin _$SensorReading {
  String get collarId => throw _privateConstructorUsedError;
  String get animalId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get tempC => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromJson)
  int get heartRateBpm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get spo2Pct => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get accelX => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get accelY => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get accelZ => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromJson)
  int get activityIndex => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get mcuTempC => throw _privateConstructorUsedError;
  String get behavior => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromJson)
  int get pprRiskScore => throw _privateConstructorUsedError;
  bool get isAnomaly => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromJson)
  int get batteryPct => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromJson)
  int get wifiRssi => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;

  /// Serializes this SensorReading to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SensorReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorReadingCopyWith<SensorReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorReadingCopyWith<$Res> {
  factory $SensorReadingCopyWith(
    SensorReading value,
    $Res Function(SensorReading) then,
  ) = _$SensorReadingCopyWithImpl<$Res, SensorReading>;
  @useResult
  $Res call({
    String collarId,
    String animalId,
    @JsonKey(fromJson: doubleFromJson) double tempC,
    @JsonKey(fromJson: intFromJson) int heartRateBpm,
    @JsonKey(fromJson: doubleFromJson) double spo2Pct,
    @JsonKey(fromJson: doubleFromJson) double accelX,
    @JsonKey(fromJson: doubleFromJson) double accelY,
    @JsonKey(fromJson: doubleFromJson) double accelZ,
    @JsonKey(fromJson: intFromJson) int activityIndex,
    @JsonKey(fromJson: doubleFromJson) double mcuTempC,
    String behavior,
    @JsonKey(fromJson: intFromJson) int pprRiskScore,
    bool isAnomaly,
    @JsonKey(fromJson: intFromJson) int batteryPct,
    @JsonKey(fromJson: intFromJson) int wifiRssi,
    DateTime recordedAt,
  });
}

/// @nodoc
class _$SensorReadingCopyWithImpl<$Res, $Val extends SensorReading>
    implements $SensorReadingCopyWith<$Res> {
  _$SensorReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SensorReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collarId = null,
    Object? animalId = null,
    Object? tempC = null,
    Object? heartRateBpm = null,
    Object? spo2Pct = null,
    Object? accelX = null,
    Object? accelY = null,
    Object? accelZ = null,
    Object? activityIndex = null,
    Object? mcuTempC = null,
    Object? behavior = null,
    Object? pprRiskScore = null,
    Object? isAnomaly = null,
    Object? batteryPct = null,
    Object? wifiRssi = null,
    Object? recordedAt = null,
  }) {
    return _then(
      _value.copyWith(
            collarId: null == collarId
                ? _value.collarId
                : collarId // ignore: cast_nullable_to_non_nullable
                      as String,
            animalId: null == animalId
                ? _value.animalId
                : animalId // ignore: cast_nullable_to_non_nullable
                      as String,
            tempC: null == tempC
                ? _value.tempC
                : tempC // ignore: cast_nullable_to_non_nullable
                      as double,
            heartRateBpm: null == heartRateBpm
                ? _value.heartRateBpm
                : heartRateBpm // ignore: cast_nullable_to_non_nullable
                      as int,
            spo2Pct: null == spo2Pct
                ? _value.spo2Pct
                : spo2Pct // ignore: cast_nullable_to_non_nullable
                      as double,
            accelX: null == accelX
                ? _value.accelX
                : accelX // ignore: cast_nullable_to_non_nullable
                      as double,
            accelY: null == accelY
                ? _value.accelY
                : accelY // ignore: cast_nullable_to_non_nullable
                      as double,
            accelZ: null == accelZ
                ? _value.accelZ
                : accelZ // ignore: cast_nullable_to_non_nullable
                      as double,
            activityIndex: null == activityIndex
                ? _value.activityIndex
                : activityIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            mcuTempC: null == mcuTempC
                ? _value.mcuTempC
                : mcuTempC // ignore: cast_nullable_to_non_nullable
                      as double,
            behavior: null == behavior
                ? _value.behavior
                : behavior // ignore: cast_nullable_to_non_nullable
                      as String,
            pprRiskScore: null == pprRiskScore
                ? _value.pprRiskScore
                : pprRiskScore // ignore: cast_nullable_to_non_nullable
                      as int,
            isAnomaly: null == isAnomaly
                ? _value.isAnomaly
                : isAnomaly // ignore: cast_nullable_to_non_nullable
                      as bool,
            batteryPct: null == batteryPct
                ? _value.batteryPct
                : batteryPct // ignore: cast_nullable_to_non_nullable
                      as int,
            wifiRssi: null == wifiRssi
                ? _value.wifiRssi
                : wifiRssi // ignore: cast_nullable_to_non_nullable
                      as int,
            recordedAt: null == recordedAt
                ? _value.recordedAt
                : recordedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SensorReadingImplCopyWith<$Res>
    implements $SensorReadingCopyWith<$Res> {
  factory _$$SensorReadingImplCopyWith(
    _$SensorReadingImpl value,
    $Res Function(_$SensorReadingImpl) then,
  ) = __$$SensorReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String collarId,
    String animalId,
    @JsonKey(fromJson: doubleFromJson) double tempC,
    @JsonKey(fromJson: intFromJson) int heartRateBpm,
    @JsonKey(fromJson: doubleFromJson) double spo2Pct,
    @JsonKey(fromJson: doubleFromJson) double accelX,
    @JsonKey(fromJson: doubleFromJson) double accelY,
    @JsonKey(fromJson: doubleFromJson) double accelZ,
    @JsonKey(fromJson: intFromJson) int activityIndex,
    @JsonKey(fromJson: doubleFromJson) double mcuTempC,
    String behavior,
    @JsonKey(fromJson: intFromJson) int pprRiskScore,
    bool isAnomaly,
    @JsonKey(fromJson: intFromJson) int batteryPct,
    @JsonKey(fromJson: intFromJson) int wifiRssi,
    DateTime recordedAt,
  });
}

/// @nodoc
class __$$SensorReadingImplCopyWithImpl<$Res>
    extends _$SensorReadingCopyWithImpl<$Res, _$SensorReadingImpl>
    implements _$$SensorReadingImplCopyWith<$Res> {
  __$$SensorReadingImplCopyWithImpl(
    _$SensorReadingImpl _value,
    $Res Function(_$SensorReadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SensorReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collarId = null,
    Object? animalId = null,
    Object? tempC = null,
    Object? heartRateBpm = null,
    Object? spo2Pct = null,
    Object? accelX = null,
    Object? accelY = null,
    Object? accelZ = null,
    Object? activityIndex = null,
    Object? mcuTempC = null,
    Object? behavior = null,
    Object? pprRiskScore = null,
    Object? isAnomaly = null,
    Object? batteryPct = null,
    Object? wifiRssi = null,
    Object? recordedAt = null,
  }) {
    return _then(
      _$SensorReadingImpl(
        collarId: null == collarId
            ? _value.collarId
            : collarId // ignore: cast_nullable_to_non_nullable
                  as String,
        animalId: null == animalId
            ? _value.animalId
            : animalId // ignore: cast_nullable_to_non_nullable
                  as String,
        tempC: null == tempC
            ? _value.tempC
            : tempC // ignore: cast_nullable_to_non_nullable
                  as double,
        heartRateBpm: null == heartRateBpm
            ? _value.heartRateBpm
            : heartRateBpm // ignore: cast_nullable_to_non_nullable
                  as int,
        spo2Pct: null == spo2Pct
            ? _value.spo2Pct
            : spo2Pct // ignore: cast_nullable_to_non_nullable
                  as double,
        accelX: null == accelX
            ? _value.accelX
            : accelX // ignore: cast_nullable_to_non_nullable
                  as double,
        accelY: null == accelY
            ? _value.accelY
            : accelY // ignore: cast_nullable_to_non_nullable
                  as double,
        accelZ: null == accelZ
            ? _value.accelZ
            : accelZ // ignore: cast_nullable_to_non_nullable
                  as double,
        activityIndex: null == activityIndex
            ? _value.activityIndex
            : activityIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        mcuTempC: null == mcuTempC
            ? _value.mcuTempC
            : mcuTempC // ignore: cast_nullable_to_non_nullable
                  as double,
        behavior: null == behavior
            ? _value.behavior
            : behavior // ignore: cast_nullable_to_non_nullable
                  as String,
        pprRiskScore: null == pprRiskScore
            ? _value.pprRiskScore
            : pprRiskScore // ignore: cast_nullable_to_non_nullable
                  as int,
        isAnomaly: null == isAnomaly
            ? _value.isAnomaly
            : isAnomaly // ignore: cast_nullable_to_non_nullable
                  as bool,
        batteryPct: null == batteryPct
            ? _value.batteryPct
            : batteryPct // ignore: cast_nullable_to_non_nullable
                  as int,
        wifiRssi: null == wifiRssi
            ? _value.wifiRssi
            : wifiRssi // ignore: cast_nullable_to_non_nullable
                  as int,
        recordedAt: null == recordedAt
            ? _value.recordedAt
            : recordedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SensorReadingImpl implements _SensorReading {
  const _$SensorReadingImpl({
    required this.collarId,
    required this.animalId,
    @JsonKey(fromJson: doubleFromJson) required this.tempC,
    @JsonKey(fromJson: intFromJson) required this.heartRateBpm,
    @JsonKey(fromJson: doubleFromJson) required this.spo2Pct,
    @JsonKey(fromJson: doubleFromJson) required this.accelX,
    @JsonKey(fromJson: doubleFromJson) required this.accelY,
    @JsonKey(fromJson: doubleFromJson) required this.accelZ,
    @JsonKey(fromJson: intFromJson) required this.activityIndex,
    @JsonKey(fromJson: doubleFromJson) required this.mcuTempC,
    required this.behavior,
    @JsonKey(fromJson: intFromJson) required this.pprRiskScore,
    required this.isAnomaly,
    @JsonKey(fromJson: intFromJson) required this.batteryPct,
    @JsonKey(fromJson: intFromJson) required this.wifiRssi,
    required this.recordedAt,
  });

  factory _$SensorReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorReadingImplFromJson(json);

  @override
  final String collarId;
  @override
  final String animalId;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double tempC;
  @override
  @JsonKey(fromJson: intFromJson)
  final int heartRateBpm;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double spo2Pct;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double accelX;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double accelY;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double accelZ;
  @override
  @JsonKey(fromJson: intFromJson)
  final int activityIndex;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double mcuTempC;
  @override
  final String behavior;
  @override
  @JsonKey(fromJson: intFromJson)
  final int pprRiskScore;
  @override
  final bool isAnomaly;
  @override
  @JsonKey(fromJson: intFromJson)
  final int batteryPct;
  @override
  @JsonKey(fromJson: intFromJson)
  final int wifiRssi;
  @override
  final DateTime recordedAt;

  @override
  String toString() {
    return 'SensorReading(collarId: $collarId, animalId: $animalId, tempC: $tempC, heartRateBpm: $heartRateBpm, spo2Pct: $spo2Pct, accelX: $accelX, accelY: $accelY, accelZ: $accelZ, activityIndex: $activityIndex, mcuTempC: $mcuTempC, behavior: $behavior, pprRiskScore: $pprRiskScore, isAnomaly: $isAnomaly, batteryPct: $batteryPct, wifiRssi: $wifiRssi, recordedAt: $recordedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorReadingImpl &&
            (identical(other.collarId, collarId) ||
                other.collarId == collarId) &&
            (identical(other.animalId, animalId) ||
                other.animalId == animalId) &&
            (identical(other.tempC, tempC) || other.tempC == tempC) &&
            (identical(other.heartRateBpm, heartRateBpm) ||
                other.heartRateBpm == heartRateBpm) &&
            (identical(other.spo2Pct, spo2Pct) || other.spo2Pct == spo2Pct) &&
            (identical(other.accelX, accelX) || other.accelX == accelX) &&
            (identical(other.accelY, accelY) || other.accelY == accelY) &&
            (identical(other.accelZ, accelZ) || other.accelZ == accelZ) &&
            (identical(other.activityIndex, activityIndex) ||
                other.activityIndex == activityIndex) &&
            (identical(other.mcuTempC, mcuTempC) ||
                other.mcuTempC == mcuTempC) &&
            (identical(other.behavior, behavior) ||
                other.behavior == behavior) &&
            (identical(other.pprRiskScore, pprRiskScore) ||
                other.pprRiskScore == pprRiskScore) &&
            (identical(other.isAnomaly, isAnomaly) ||
                other.isAnomaly == isAnomaly) &&
            (identical(other.batteryPct, batteryPct) ||
                other.batteryPct == batteryPct) &&
            (identical(other.wifiRssi, wifiRssi) ||
                other.wifiRssi == wifiRssi) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    collarId,
    animalId,
    tempC,
    heartRateBpm,
    spo2Pct,
    accelX,
    accelY,
    accelZ,
    activityIndex,
    mcuTempC,
    behavior,
    pprRiskScore,
    isAnomaly,
    batteryPct,
    wifiRssi,
    recordedAt,
  );

  /// Create a copy of SensorReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorReadingImplCopyWith<_$SensorReadingImpl> get copyWith =>
      __$$SensorReadingImplCopyWithImpl<_$SensorReadingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorReadingImplToJson(this);
  }
}

abstract class _SensorReading implements SensorReading {
  const factory _SensorReading({
    required final String collarId,
    required final String animalId,
    @JsonKey(fromJson: doubleFromJson) required final double tempC,
    @JsonKey(fromJson: intFromJson) required final int heartRateBpm,
    @JsonKey(fromJson: doubleFromJson) required final double spo2Pct,
    @JsonKey(fromJson: doubleFromJson) required final double accelX,
    @JsonKey(fromJson: doubleFromJson) required final double accelY,
    @JsonKey(fromJson: doubleFromJson) required final double accelZ,
    @JsonKey(fromJson: intFromJson) required final int activityIndex,
    @JsonKey(fromJson: doubleFromJson) required final double mcuTempC,
    required final String behavior,
    @JsonKey(fromJson: intFromJson) required final int pprRiskScore,
    required final bool isAnomaly,
    @JsonKey(fromJson: intFromJson) required final int batteryPct,
    @JsonKey(fromJson: intFromJson) required final int wifiRssi,
    required final DateTime recordedAt,
  }) = _$SensorReadingImpl;

  factory _SensorReading.fromJson(Map<String, dynamic> json) =
      _$SensorReadingImpl.fromJson;

  @override
  String get collarId;
  @override
  String get animalId;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get tempC;
  @override
  @JsonKey(fromJson: intFromJson)
  int get heartRateBpm;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get spo2Pct;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get accelX;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get accelY;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get accelZ;
  @override
  @JsonKey(fromJson: intFromJson)
  int get activityIndex;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get mcuTempC;
  @override
  String get behavior;
  @override
  @JsonKey(fromJson: intFromJson)
  int get pprRiskScore;
  @override
  bool get isAnomaly;
  @override
  @JsonKey(fromJson: intFromJson)
  int get batteryPct;
  @override
  @JsonKey(fromJson: intFromJson)
  int get wifiRssi;
  @override
  DateTime get recordedAt;

  /// Create a copy of SensorReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorReadingImplCopyWith<_$SensorReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

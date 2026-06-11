// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return _Alert.fromJson(json);
}

/// @nodoc
mixin _$Alert {
  String get id => throw _privateConstructorUsedError;
  String get collarId => throw _privateConstructorUsedError;
  String get animalId => throw _privateConstructorUsedError;
  String get farmId => throw _privateConstructorUsedError;
  AlertType get alertType => throw _privateConstructorUsedError;
  AlertSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  double? get tempAtAlert => throw _privateConstructorUsedError;
  int? get hrAtAlert => throw _privateConstructorUsedError;
  int? get riskScore => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertCopyWith<Alert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) then) =
      _$AlertCopyWithImpl<$Res, Alert>;
  @useResult
  $Res call({
    String id,
    String collarId,
    String animalId,
    String farmId,
    AlertType alertType,
    AlertSeverity severity,
    String message,
    double? tempAtAlert,
    int? hrAtAlert,
    int? riskScore,
    bool isResolved,
    DateTime? resolvedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AlertCopyWithImpl<$Res, $Val extends Alert>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collarId = null,
    Object? animalId = null,
    Object? farmId = null,
    Object? alertType = null,
    Object? severity = null,
    Object? message = null,
    Object? tempAtAlert = freezed,
    Object? hrAtAlert = freezed,
    Object? riskScore = freezed,
    Object? isResolved = null,
    Object? resolvedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            collarId: null == collarId
                ? _value.collarId
                : collarId // ignore: cast_nullable_to_non_nullable
                      as String,
            animalId: null == animalId
                ? _value.animalId
                : animalId // ignore: cast_nullable_to_non_nullable
                      as String,
            farmId: null == farmId
                ? _value.farmId
                : farmId // ignore: cast_nullable_to_non_nullable
                      as String,
            alertType: null == alertType
                ? _value.alertType
                : alertType // ignore: cast_nullable_to_non_nullable
                      as AlertType,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as AlertSeverity,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            tempAtAlert: freezed == tempAtAlert
                ? _value.tempAtAlert
                : tempAtAlert // ignore: cast_nullable_to_non_nullable
                      as double?,
            hrAtAlert: freezed == hrAtAlert
                ? _value.hrAtAlert
                : hrAtAlert // ignore: cast_nullable_to_non_nullable
                      as int?,
            riskScore: freezed == riskScore
                ? _value.riskScore
                : riskScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            isResolved: null == isResolved
                ? _value.isResolved
                : isResolved // ignore: cast_nullable_to_non_nullable
                      as bool,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertImplCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$$AlertImplCopyWith(
    _$AlertImpl value,
    $Res Function(_$AlertImpl) then,
  ) = __$$AlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String collarId,
    String animalId,
    String farmId,
    AlertType alertType,
    AlertSeverity severity,
    String message,
    double? tempAtAlert,
    int? hrAtAlert,
    int? riskScore,
    bool isResolved,
    DateTime? resolvedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AlertImplCopyWithImpl<$Res>
    extends _$AlertCopyWithImpl<$Res, _$AlertImpl>
    implements _$$AlertImplCopyWith<$Res> {
  __$$AlertImplCopyWithImpl(
    _$AlertImpl _value,
    $Res Function(_$AlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collarId = null,
    Object? animalId = null,
    Object? farmId = null,
    Object? alertType = null,
    Object? severity = null,
    Object? message = null,
    Object? tempAtAlert = freezed,
    Object? hrAtAlert = freezed,
    Object? riskScore = freezed,
    Object? isResolved = null,
    Object? resolvedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$AlertImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        collarId: null == collarId
            ? _value.collarId
            : collarId // ignore: cast_nullable_to_non_nullable
                  as String,
        animalId: null == animalId
            ? _value.animalId
            : animalId // ignore: cast_nullable_to_non_nullable
                  as String,
        farmId: null == farmId
            ? _value.farmId
            : farmId // ignore: cast_nullable_to_non_nullable
                  as String,
        alertType: null == alertType
            ? _value.alertType
            : alertType // ignore: cast_nullable_to_non_nullable
                  as AlertType,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as AlertSeverity,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        tempAtAlert: freezed == tempAtAlert
            ? _value.tempAtAlert
            : tempAtAlert // ignore: cast_nullable_to_non_nullable
                  as double?,
        hrAtAlert: freezed == hrAtAlert
            ? _value.hrAtAlert
            : hrAtAlert // ignore: cast_nullable_to_non_nullable
                  as int?,
        riskScore: freezed == riskScore
            ? _value.riskScore
            : riskScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        isResolved: null == isResolved
            ? _value.isResolved
            : isResolved // ignore: cast_nullable_to_non_nullable
                  as bool,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$AlertImpl implements _Alert {
  const _$AlertImpl({
    required this.id,
    required this.collarId,
    required this.animalId,
    required this.farmId,
    required this.alertType,
    required this.severity,
    required this.message,
    this.tempAtAlert,
    this.hrAtAlert,
    this.riskScore,
    required this.isResolved,
    this.resolvedAt,
    required this.createdAt,
  });

  factory _$AlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertImplFromJson(json);

  @override
  final String id;
  @override
  final String collarId;
  @override
  final String animalId;
  @override
  final String farmId;
  @override
  final AlertType alertType;
  @override
  final AlertSeverity severity;
  @override
  final String message;
  @override
  final double? tempAtAlert;
  @override
  final int? hrAtAlert;
  @override
  final int? riskScore;
  @override
  final bool isResolved;
  @override
  final DateTime? resolvedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Alert(id: $id, collarId: $collarId, animalId: $animalId, farmId: $farmId, alertType: $alertType, severity: $severity, message: $message, tempAtAlert: $tempAtAlert, hrAtAlert: $hrAtAlert, riskScore: $riskScore, isResolved: $isResolved, resolvedAt: $resolvedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.collarId, collarId) ||
                other.collarId == collarId) &&
            (identical(other.animalId, animalId) ||
                other.animalId == animalId) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.tempAtAlert, tempAtAlert) ||
                other.tempAtAlert == tempAtAlert) &&
            (identical(other.hrAtAlert, hrAtAlert) ||
                other.hrAtAlert == hrAtAlert) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    collarId,
    animalId,
    farmId,
    alertType,
    severity,
    message,
    tempAtAlert,
    hrAtAlert,
    riskScore,
    isResolved,
    resolvedAt,
    createdAt,
  );

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      __$$AlertImplCopyWithImpl<_$AlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertImplToJson(this);
  }
}

abstract class _Alert implements Alert {
  const factory _Alert({
    required final String id,
    required final String collarId,
    required final String animalId,
    required final String farmId,
    required final AlertType alertType,
    required final AlertSeverity severity,
    required final String message,
    final double? tempAtAlert,
    final int? hrAtAlert,
    final int? riskScore,
    required final bool isResolved,
    final DateTime? resolvedAt,
    required final DateTime createdAt,
  }) = _$AlertImpl;

  factory _Alert.fromJson(Map<String, dynamic> json) = _$AlertImpl.fromJson;

  @override
  String get id;
  @override
  String get collarId;
  @override
  String get animalId;
  @override
  String get farmId;
  @override
  AlertType get alertType;
  @override
  AlertSeverity get severity;
  @override
  String get message;
  @override
  double? get tempAtAlert;
  @override
  int? get hrAtAlert;
  @override
  int? get riskScore;
  @override
  bool get isResolved;
  @override
  DateTime? get resolvedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

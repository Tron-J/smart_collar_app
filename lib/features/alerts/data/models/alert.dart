// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_collar_app/core/utils/json_converters.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum AlertType { highTemp, lowHr, highHr, lethargy, pprRisk, offline }

@JsonEnum(fieldRename: FieldRename.snake)
enum AlertSeverity { info, warning, critical }

@freezed
class Alert with _$Alert {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Alert({
    required String id,
    required String collarId,
    required String animalId,
    required String farmId,
    required AlertType alertType,
    required AlertSeverity severity,
    required String message,
    @JsonKey(fromJson: nullableDoubleFromJson) double? tempAtAlert,
    @JsonKey(fromJson: nullableIntFromJson) int? hrAtAlert,
    @JsonKey(fromJson: nullableIntFromJson) int? riskScore,
    required bool isResolved,
    DateTime? resolvedAt,
    required DateTime createdAt,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

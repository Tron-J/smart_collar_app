import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum AlertType {
  highTemp,
  lowHr,
  highHr,
  lethargy,
  pprRisk,
  offline,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum AlertSeverity {
  info,
  warning,
  critical,
}

@freezed
class Alert with _$Alert {
  const factory Alert({
    required String id,
    required String collarId,
    required String animalId,
    required String farmId,
    required AlertType alertType,
    required AlertSeverity severity,
    required String message,
    double? tempAtAlert,
    int? hrAtAlert,
    int? riskScore,
    required bool isResolved,
    DateTime? resolvedAt,
    required DateTime createdAt,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

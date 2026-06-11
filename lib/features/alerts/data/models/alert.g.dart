// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
  id: json['id'] as String,
  collarId: json['collar_id'] as String,
  animalId: json['animal_id'] as String,
  farmId: json['farm_id'] as String,
  alertType: $enumDecode(_$AlertTypeEnumMap, json['alert_type']),
  severity: $enumDecode(_$AlertSeverityEnumMap, json['severity']),
  message: json['message'] as String,
  tempAtAlert: (json['temp_at_alert'] as num?)?.toDouble(),
  hrAtAlert: (json['hr_at_alert'] as num?)?.toInt(),
  riskScore: (json['risk_score'] as num?)?.toInt(),
  isResolved: json['is_resolved'] as bool,
  resolvedAt: json['resolved_at'] == null
      ? null
      : DateTime.parse(json['resolved_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collar_id': instance.collarId,
      'animal_id': instance.animalId,
      'farm_id': instance.farmId,
      'alert_type': _$AlertTypeEnumMap[instance.alertType]!,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'temp_at_alert': instance.tempAtAlert,
      'hr_at_alert': instance.hrAtAlert,
      'risk_score': instance.riskScore,
      'is_resolved': instance.isResolved,
      'resolved_at': instance.resolvedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$AlertTypeEnumMap = {
  AlertType.highTemp: 'high_temp',
  AlertType.lowHr: 'low_hr',
  AlertType.highHr: 'high_hr',
  AlertType.lethargy: 'lethargy',
  AlertType.pprRisk: 'ppr_risk',
  AlertType.offline: 'offline',
};

const _$AlertSeverityEnumMap = {
  AlertSeverity.info: 'info',
  AlertSeverity.warning: 'warning',
  AlertSeverity.critical: 'critical',
};

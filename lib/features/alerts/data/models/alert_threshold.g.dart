// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_threshold.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertThresholdImpl _$$AlertThresholdImplFromJson(Map<String, dynamic> json) =>
    _$AlertThresholdImpl(
      id: json['id'] as String,
      farmId: json['farm_id'] as String,
      animalId: json['animal_id'] as String?,
      tempHighC: doubleFromJson(json['temp_high_c']),
      tempLowC: doubleFromJson(json['temp_low_c']),
      hrHighBpm: intFromJson(json['hr_high_bpm']),
      hrLowBpm: intFromJson(json['hr_low_bpm']),
      activityLowPct: intFromJson(json['activity_low_pct']),
      pprRiskThreshold: intFromJson(json['ppr_risk_threshold']),
    );

Map<String, dynamic> _$$AlertThresholdImplToJson(
  _$AlertThresholdImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'farm_id': instance.farmId,
  'animal_id': instance.animalId,
  'temp_high_c': instance.tempHighC,
  'temp_low_c': instance.tempLowC,
  'hr_high_bpm': instance.hrHighBpm,
  'hr_low_bpm': instance.hrLowBpm,
  'activity_low_pct': instance.activityLowPct,
  'ppr_risk_threshold': instance.pprRiskThreshold,
};

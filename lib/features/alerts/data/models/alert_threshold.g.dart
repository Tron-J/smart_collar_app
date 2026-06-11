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
      tempHighC: (json['temp_high_c'] as num).toDouble(),
      tempLowC: (json['temp_low_c'] as num).toDouble(),
      hrHighBpm: (json['hr_high_bpm'] as num).toInt(),
      hrLowBpm: (json['hr_low_bpm'] as num).toInt(),
      activityLowPct: (json['activity_low_pct'] as num).toInt(),
      pprRiskThreshold: (json['ppr_risk_threshold'] as num).toInt(),
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorReadingImpl _$$SensorReadingImplFromJson(Map<String, dynamic> json) =>
    _$SensorReadingImpl(
      collarId: json['collar_id'] as String,
      animalId: json['animal_id'] as String,
      tempC: (json['temp_c'] as num).toDouble(),
      heartRateBpm: (json['heart_rate_bpm'] as num).toInt(),
      spo2Pct: (json['spo2_pct'] as num).toDouble(),
      accelX: (json['accel_x'] as num).toDouble(),
      accelY: (json['accel_y'] as num).toDouble(),
      accelZ: (json['accel_z'] as num).toDouble(),
      activityIndex: (json['activity_index'] as num).toInt(),
      mcuTempC: (json['mcu_temp_c'] as num).toDouble(),
      behavior: json['behavior'] as String,
      pprRiskScore: (json['ppr_risk_score'] as num).toInt(),
      isAnomaly: json['is_anomaly'] as bool,
      batteryPct: (json['battery_pct'] as num).toInt(),
      wifiRssi: (json['wifi_rssi'] as num).toInt(),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );

Map<String, dynamic> _$$SensorReadingImplToJson(_$SensorReadingImpl instance) =>
    <String, dynamic>{
      'collar_id': instance.collarId,
      'animal_id': instance.animalId,
      'temp_c': instance.tempC,
      'heart_rate_bpm': instance.heartRateBpm,
      'spo2_pct': instance.spo2Pct,
      'accel_x': instance.accelX,
      'accel_y': instance.accelY,
      'accel_z': instance.accelZ,
      'activity_index': instance.activityIndex,
      'mcu_temp_c': instance.mcuTempC,
      'behavior': instance.behavior,
      'ppr_risk_score': instance.pprRiskScore,
      'is_anomaly': instance.isAnomaly,
      'battery_pct': instance.batteryPct,
      'wifi_rssi': instance.wifiRssi,
      'recorded_at': instance.recordedAt.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorReadingImpl _$$SensorReadingImplFromJson(Map<String, dynamic> json) =>
    _$SensorReadingImpl(
      collarId: json['collar_id'] as String,
      animalId: json['animal_id'] as String,
      tempC: doubleFromJson(json['temp_c']),
      heartRateBpm: intFromJson(json['heart_rate_bpm']),
      spo2Pct: doubleFromJson(json['spo2_pct']),
      accelX: doubleFromJson(json['accel_x']),
      accelY: doubleFromJson(json['accel_y']),
      accelZ: doubleFromJson(json['accel_z']),
      activityIndex: intFromJson(json['activity_index']),
      mcuTempC: doubleFromJson(json['mcu_temp_c']),
      behavior: json['behavior'] as String,
      pprRiskScore: intFromJson(json['ppr_risk_score']),
      isAnomaly: json['is_anomaly'] as bool,
      batteryPct: intFromJson(json['battery_pct']),
      wifiRssi: intFromJson(json['wifi_rssi']),
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

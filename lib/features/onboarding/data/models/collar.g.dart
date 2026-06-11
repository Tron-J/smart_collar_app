// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollarImpl _$$CollarImplFromJson(Map<String, dynamic> json) => _$CollarImpl(
  id: json['id'] as String,
  deviceId: json['device_id'] as String,
  farmId: json['farm_id'] as String?,
  animalId: json['animal_id'] as String?,
  firmwareVersion: json['firmware_version'] as String?,
  batteryPct: (json['battery_pct'] as num?)?.toInt(),
  wifiRssi: (json['wifi_rssi'] as num?)?.toInt(),
  lastSeen: json['last_seen'] == null
      ? null
      : DateTime.parse(json['last_seen'] as String),
  isOnline: json['is_online'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$CollarImplToJson(_$CollarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'farm_id': instance.farmId,
      'animal_id': instance.animalId,
      'firmware_version': instance.firmwareVersion,
      'battery_pct': instance.batteryPct,
      'wifi_rssi': instance.wifiRssi,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'is_online': instance.isOnline,
      'created_at': instance.createdAt?.toIso8601String(),
    };

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_reading.freezed.dart';
part 'sensor_reading.g.dart';

@freezed
class SensorReading with _$SensorReading {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SensorReading({
    required String collarId,
    required String animalId,
    required double tempC,
    required int heartRateBpm,
    required double spo2Pct,
    required double accelX,
    required double accelY,
    required double accelZ,
    required int activityIndex,
    required double mcuTempC,
    required String behavior,
    required int pprRiskScore,
    required bool isAnomaly,
    required int batteryPct,
    required int wifiRssi,
    required DateTime recordedAt,
  }) = _SensorReading;

  factory SensorReading.fromJson(Map<String, dynamic> json) =>
      _$SensorReadingFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_collar_app/core/utils/json_converters.dart';

part 'sensor_reading.freezed.dart';
part 'sensor_reading.g.dart';

@freezed
class SensorReading with _$SensorReading {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SensorReading({
    required String collarId,
    required String animalId,
    @JsonKey(fromJson: doubleFromJson) required double tempC,
    @JsonKey(fromJson: intFromJson) required int heartRateBpm,
    @JsonKey(fromJson: doubleFromJson) required double spo2Pct,
    @JsonKey(fromJson: doubleFromJson) required double accelX,
    @JsonKey(fromJson: doubleFromJson) required double accelY,
    @JsonKey(fromJson: doubleFromJson) required double accelZ,
    @JsonKey(fromJson: intFromJson) required int activityIndex,
    @JsonKey(fromJson: doubleFromJson) required double mcuTempC,
    required String behavior,
    @JsonKey(fromJson: intFromJson) required int pprRiskScore,
    required bool isAnomaly,
    @JsonKey(fromJson: intFromJson) required int batteryPct,
    @JsonKey(fromJson: intFromJson) required int wifiRssi,
    required DateTime recordedAt,
  }) = _SensorReading;

  factory SensorReading.fromJson(Map<String, dynamic> json) =>
      _$SensorReadingFromJson(json);
}

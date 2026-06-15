// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_collar_app/core/utils/json_converters.dart';

part 'alert_threshold.freezed.dart';
part 'alert_threshold.g.dart';

@freezed
class AlertThreshold with _$AlertThreshold {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AlertThreshold({
    required String id,
    required String farmId,
    String? animalId,
    @JsonKey(fromJson: doubleFromJson) required double tempHighC,
    @JsonKey(fromJson: doubleFromJson) required double tempLowC,
    @JsonKey(fromJson: intFromJson) required int hrHighBpm,
    @JsonKey(fromJson: intFromJson) required int hrLowBpm,
    @JsonKey(fromJson: intFromJson) required int activityLowPct,
    @JsonKey(fromJson: intFromJson) required int pprRiskThreshold,
  }) = _AlertThreshold;

  factory AlertThreshold.fromJson(Map<String, dynamic> json) =>
      _$AlertThresholdFromJson(json);
}

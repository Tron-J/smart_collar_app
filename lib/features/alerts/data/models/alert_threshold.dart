// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_threshold.freezed.dart';
part 'alert_threshold.g.dart';

@freezed
class AlertThreshold with _$AlertThreshold {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AlertThreshold({
    required String id,
    required String farmId,
    String? animalId,
    required double tempHighC,
    required double tempLowC,
    required int hrHighBpm,
    required int hrLowBpm,
    required int activityLowPct,
    required int pprRiskThreshold,
  }) = _AlertThreshold;

  factory AlertThreshold.fromJson(Map<String, dynamic> json) =>
      _$AlertThresholdFromJson(json);
}

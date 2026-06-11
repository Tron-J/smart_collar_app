// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collar.freezed.dart';
part 'collar.g.dart';

@freezed
class Collar with _$Collar {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Collar({
    required String id,
    required String deviceId,
    String? farmId,
    String? animalId,
    String? firmwareVersion,
    int? batteryPct,
    int? wifiRssi,
    DateTime? lastSeen,
    @Default(false) bool isOnline,
    DateTime? createdAt,
  }) = _Collar;

  factory Collar.fromJson(Map<String, dynamic> json) => _$CollarFromJson(json);
}

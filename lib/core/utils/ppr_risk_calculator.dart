class PprRiskBreakdown {
  const PprRiskBreakdown({
    required this.temperaturePoints,
    required this.heartRatePoints,
    required this.activityPoints,
  });

  final int temperaturePoints;
  final int heartRatePoints;
  final int activityPoints;

  int get total => temperaturePoints + heartRatePoints + activityPoints;
}

PprRiskBreakdown calculatePprRiskBreakdown({
  required double tempC,
  required int heartRateBpm,
  required int activityIndex,
}) {
  final temperaturePoints = tempC >= 40
      ? 45
      : tempC >= 39.7
      ? 25
      : 0;
  final heartRatePoints = heartRateBpm >= 120 || heartRateBpm <= 50 ? 25 : 0;
  final activityPoints = activityIndex <= 10
      ? 30
      : activityIndex <= 20
      ? 15
      : 0;

  return PprRiskBreakdown(
    temperaturePoints: temperaturePoints,
    heartRatePoints: heartRatePoints,
    activityPoints: activityPoints,
  );
}

import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';

String animalStateLabel(SensorReading? reading) {
  if (reading == null) return 'Waiting for readings';

  final behavior = reading.behavior.trim().toLowerCase();
  if (behavior == 'grazing') return 'Grazing';
  if (behavior == 'sleeping') return 'Sleeping';
  if (behavior == 'resting') {
    return reading.activityIndex <= 5 ? 'Sleeping' : 'Resting';
  }

  if (reading.activityIndex <= 5) return 'Sleeping';
  if (reading.activityIndex <= 25) return 'Resting';
  return 'Grazing';
}

String animalStateDetail(SensorReading? reading) {
  if (reading == null) return 'No live collar data has arrived yet.';

  final state = animalStateLabel(reading);
  return '$state from activity ${reading.activityIndex}%, '
      '${reading.heartRateBpm} bpm, ${reading.tempC.toStringAsFixed(1)} C.';
}

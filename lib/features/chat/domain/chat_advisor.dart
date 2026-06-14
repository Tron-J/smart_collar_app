import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/dashboard/domain/animal_state.dart';

class ChatAdvisor {
  static const examples = [
    'Hello',
    'What is PPR?',
    'Is this animal healthy?',
    'Why is the pulse high?',
    'What does low activity mean?',
    'What should I do if PPR risk is high?',
  ];

  String reply({
    required String message,
    required List<SensorReading> readings,
    SensorReading? selectedReading,
  }) {
    final text = message.trim().toLowerCase();
    final reading = selectedReading;

    if (text.isEmpty) {
      return 'Ask me about PPR risk, pulse, temperature, activity, behavior, battery, or Wi-Fi.';
    }
    if (_isGreeting(text)) {
      return 'Hello. I can help you interpret collar readings and give practical PPR-aware health suggestions.';
    }
    if (text.contains('example') || text.contains('what can i ask')) {
      return 'Try: "What is PPR?", "Is this animal healthy?", "Why is the pulse high?", or "What should I do if PPR risk is high?"';
    }
    if (text.contains('ppr') ||
        text.contains('peste') ||
        text.contains('petits') ||
        text.contains('ruminants')) {
      return _pprReply(reading, readings);
    }
    if (text.contains('healthy') ||
        text.contains('health') ||
        text.contains('sick') ||
        text.contains('risk')) {
      return _healthReply(reading, readings);
    }
    if (text.contains('temp') ||
        text.contains('fever') ||
        text.contains('hot')) {
      return _temperatureReply(reading, readings);
    }
    if (text.contains('pulse') ||
        text.contains('heart') ||
        text.contains('bpm')) {
      return _pulseReply(reading, readings);
    }
    if (text.contains('activity') ||
        text.contains('sleep') ||
        text.contains('rest') ||
        text.contains('graz')) {
      return _behaviorReply(reading, readings);
    }
    if (text.contains('battery') || text.contains('charge')) {
      return _batteryReply(reading, readings);
    }
    if (text.contains('wifi') ||
        text.contains('online') ||
        text.contains('network')) {
      return _wifiReply(reading, readings);
    }

    return _summaryReply(reading, readings);
  }

  bool _isGreeting(String text) {
    return text == 'hi' ||
        text == 'hello' ||
        text == 'hey' ||
        text.contains('good morning') ||
        text.contains('good afternoon') ||
        text.contains('good evening');
  }

  String _pprReply(SensorReading? reading, List<SensorReading> readings) {
    final risk =
        reading?.pprRiskScore ??
        _averageInt(readings.map((r) => r.pprRiskScore));
    final context = risk == null ? '' : ' Current risk score is $risk%.';
    return 'Peste des Petits Ruminants (PPR) is a serious contagious viral disease of sheep and goats. Watch for fever, mouth sores, nasal or eye discharge, coughing, diarrhea, weakness, and reduced feeding.$context If risk is high or symptoms are visible, isolate the animal, reduce contact with the herd, provide clean water, and contact a veterinary professional.';
  }

  String _healthReply(SensorReading? reading, List<SensorReading> readings) {
    if (reading == null && readings.isEmpty) {
      return 'I do not have live readings yet. Pair a collar and keep it online so I can assess pulse, temperature, movement, and PPR risk.';
    }
    final risk =
        reading?.pprRiskScore ??
        _averageInt(readings.map((r) => r.pprRiskScore));
    if (risk == null) return 'No risk reading is available yet.';
    if (risk >= 80) {
      return 'Risk is critical at $risk%. Isolate the animal, check for fever or discharge, confirm the collar is fitted properly, and call a vet urgently.';
    }
    if (risk >= 60) {
      return 'Risk is elevated at $risk%. Observe closely for PPR signs, check temperature and feeding behavior, and keep the animal separate if symptoms appear.';
    }
    if (risk >= 31) {
      return 'Risk is moderate at $risk%. Continue monitoring. If temperature rises, pulse stays high, or activity drops, inspect the animal physically.';
    }
    return 'Risk is low at $risk%. Keep monitoring and maintain normal feeding, water, hygiene, and vaccination routines.';
  }

  String _temperatureReply(
    SensorReading? reading,
    List<SensorReading> readings,
  ) {
    final temp = reading?.tempC ?? _averageDouble(readings.map((r) => r.tempC));
    if (temp == null) return 'Temperature data is not available yet.';
    if (temp >= 40) {
      return 'Temperature is high at ${temp.toStringAsFixed(1)} C. Fever can be an early warning sign. Check the animal physically and isolate if other PPR signs appear.';
    }
    if (temp < 37.5) {
      return 'Temperature is low at ${temp.toStringAsFixed(1)} C. Check collar placement and confirm the animal is not cold, weak, or inactive.';
    }
    return 'Temperature is ${temp.toStringAsFixed(1)} C, which does not look alarming by itself. Keep watching it together with pulse and activity.';
  }

  String _pulseReply(SensorReading? reading, List<SensorReading> readings) {
    final pulse =
        reading?.heartRateBpm ??
        _averageInt(readings.map((r) => r.heartRateBpm));
    if (pulse == null) return 'Pulse data is not available yet.';
    if (pulse > 110) {
      return 'Pulse is high at $pulse bpm. Stress, heat, movement, or illness can raise pulse. Compare it with temperature, activity, and visible symptoms.';
    }
    if (pulse < 55) {
      return 'Pulse is low at $pulse bpm. Confirm the sensor is touching the animal properly and check for weakness or abnormal behavior.';
    }
    return 'Pulse is $pulse bpm. It looks reasonable, but it should still be interpreted with temperature, activity, and PPR risk.';
  }

  String _behaviorReply(SensorReading? reading, List<SensorReading> readings) {
    if (reading != null) {
      return 'This animal appears to be ${animalStateLabel(reading).toLowerCase()}. Activity is ${reading.activityIndex}%. Low activity with fever or high pulse may need attention.';
    }
    if (readings.isEmpty) return 'No behavior reading is available yet.';
    final grazing = readings
        .where((r) => animalStateLabel(r) == 'Grazing')
        .length;
    final sleeping = readings
        .where((r) => animalStateLabel(r) == 'Sleeping')
        .length;
    final resting = readings
        .where((r) => animalStateLabel(r) == 'Resting')
        .length;
    return 'Farm behavior summary: $grazing grazing, $sleeping sleeping, $resting resting. Animals with low activity and rising temperature should be checked first.';
  }

  String _batteryReply(SensorReading? reading, List<SensorReading> readings) {
    final battery =
        reading?.batteryPct ?? _averageInt(readings.map((r) => r.batteryPct));
    if (battery == null) return 'Battery data is not available yet.';
    if (battery <= 20) {
      return 'Battery is low at $battery%. Charge or replace it soon to avoid losing readings.';
    }
    return 'Battery is $battery%. Monitoring should continue normally.';
  }

  String _wifiReply(SensorReading? reading, List<SensorReading> readings) {
    final wifi =
        reading?.wifiRssi ?? _averageInt(readings.map((r) => r.wifiRssi));
    if (wifi == null) return 'Wi-Fi data is not available yet.';
    if (wifi < 35) {
      return 'Wi-Fi signal is weak at $wifi%. Move the collar closer to the router or improve farm network coverage.';
    }
    return 'Wi-Fi signal is $wifi%. The collar should be able to stream readings if the backend and MQTT connection are online.';
  }

  String _summaryReply(SensorReading? reading, List<SensorReading> readings) {
    if (reading != null) {
      return 'Current collar summary: ${animalStateLabel(reading)}, ${reading.heartRateBpm} bpm, ${reading.tempC.toStringAsFixed(1)} C, activity ${reading.activityIndex}%, PPR risk ${reading.pprRiskScore}%.';
    }
    if (readings.isEmpty) {
      return 'I can help once collars start sending readings. You can ask about PPR, pulse, temperature, activity, battery, or Wi-Fi.';
    }
    final risk = _averageInt(readings.map((r) => r.pprRiskScore));
    final pulse = _averageInt(readings.map((r) => r.heartRateBpm));
    final temp = _averageDouble(readings.map((r) => r.tempC));
    return 'Farm summary: average risk ${risk ?? '--'}%, pulse ${pulse ?? '--'} bpm, temperature ${temp?.toStringAsFixed(1) ?? '--'} C across ${readings.length} active collars.';
  }

  int? _averageInt(Iterable<int> values) {
    final list = values.toList();
    if (list.isEmpty) return null;
    return (list.reduce((a, b) => a + b) / list.length).round();
  }

  double? _averageDouble(Iterable<double> values) {
    final list = values.toList();
    if (list.isEmpty) return null;
    return list.reduce((a, b) => a + b) / list.length;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';

final currentFarmIdProvider = FutureProvider<String?>((ref) {
  return ref.watch(secureStorageProvider).readCurrentFarmId();
});

final currentAnimalIdProvider = FutureProvider<String?>((ref) {
  return ref.watch(secureStorageProvider).readCurrentAnimalId();
});

Future<void> saveCurrentFarmId(Ref ref, String farmId) async {
  await ref.read(secureStorageProvider).saveCurrentFarmId(farmId);
  ref.invalidate(currentFarmIdProvider);
}

Future<void> saveCurrentAnimalId(Ref ref, String animalId) async {
  await ref.read(secureStorageProvider).saveCurrentAnimalId(animalId);
  ref.invalidate(currentAnimalIdProvider);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/features/herd/data/herd_repository.dart';
import 'package:smart_collar_app/features/onboarding/data/models/animal.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';

final herdRepositoryProvider = Provider<HerdRepository>((ref) {
  return HerdRepository(apiClient: ref.watch(apiClientProvider));
});

final herdAnimalsProvider = FutureProvider<List<Animal>>((ref) async {
  final farmId = await ref.watch(currentFarmIdProvider.future);
  if (farmId == null) return [];
  return ref.watch(herdRepositoryProvider).fetchAnimals(farmId);
});

final farmCollarsProvider = FutureProvider<List<Collar>>((ref) async {
  final farmId = await ref.watch(currentFarmIdProvider.future);
  if (farmId == null) return [];
  return ref.watch(herdRepositoryProvider).fetchCollars(farmId);
});

final animalDetailProvider = FutureProvider.family<Animal, String>((
  ref,
  animalId,
) {
  return ref.watch(herdRepositoryProvider).fetchAnimal(animalId);
});

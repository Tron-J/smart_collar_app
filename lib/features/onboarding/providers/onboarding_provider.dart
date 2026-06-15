import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/features/onboarding/data/models/animal.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';
import 'package:smart_collar_app/features/onboarding/data/models/farm.dart';
import 'package:smart_collar_app/features/onboarding/data/onboarding_repository.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(apiClient: ref.watch(apiClientProvider));
});

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, AsyncValue<OnboardingState>>(
      (ref) => OnboardingController(ref),
    );

final userFarmsProvider = FutureProvider<List<Farm>>((ref) {
  return ref.watch(onboardingRepositoryProvider).fetchFarms();
});

final completedFarmProvider = FutureProvider<Farm?>((ref) async {
  final farms = await ref.watch(userFarmsProvider.future);
  if (farms.isEmpty) return null;
  final farm = farms.first;
  await saveCurrentFarmId(ref, farm.id);
  return farm;
});

class OnboardingState {
  const OnboardingState({this.farm, this.animal, this.collar});

  final Farm? farm;
  final Animal? animal;
  final Collar? collar;

  OnboardingState copyWith({Farm? farm, Animal? animal, Collar? collar}) {
    return OnboardingState(
      farm: farm ?? this.farm,
      animal: animal ?? this.animal,
      collar: collar ?? this.collar,
    );
  }
}

class OnboardingController extends StateNotifier<AsyncValue<OnboardingState>> {
  OnboardingController(this._ref) : super(const AsyncData(OnboardingState()));

  final Ref _ref;

  OnboardingRepository get _repository =>
      _ref.read(onboardingRepositoryProvider);

  Future<Farm> createFarm({
    required String name,
    String? location,
    required String farmType,
  }) async {
    final previous = state.value ?? const OnboardingState();
    state = const AsyncLoading();
    try {
      final farm = await _repository.createFarm(
        name: name,
        location: location,
        farmType: farmType,
      );
      await saveCurrentFarmId(_ref, farm.id);
      _ref.invalidate(userFarmsProvider);
      _ref.invalidate(completedFarmProvider);
      state = AsyncData(previous.copyWith(farm: farm));
      return farm;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<Animal> createAnimal({
    required String animalTag,
    required String species,
    required String sex,
    int? ageMonths,
    double? weightKg,
  }) async {
    final previous = state.value ?? const OnboardingState();
    final farmId =
        previous.farm?.id ??
        await _ref.read(secureStorageProvider).readCurrentFarmId();
    if (farmId == null) {
      throw StateError('Create a farm before adding animals.');
    }
    state = const AsyncLoading();
    try {
      final animal = await _repository.createAnimal(
        farmId: farmId,
        animalTag: animalTag,
        species: species,
        sex: sex,
        ageMonths: ageMonths,
        weightKg: weightKg,
      );
      await saveCurrentAnimalId(_ref, animal.id);
      _ref.invalidate(herdAnimalsProvider);
      state = AsyncData(previous.copyWith(animal: animal));
      return animal;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AnimalCollarRegistration> createAnimalWithCollar({
    required String animalTag,
    required String species,
    required String sex,
    int? ageMonths,
    double? weightKg,
    required String deviceId,
  }) async {
    final previous = state.value ?? const OnboardingState();
    final farmId =
        previous.farm?.id ??
        await _ref.read(secureStorageProvider).readCurrentFarmId();
    if (farmId == null) {
      throw StateError('Create a farm before adding animals.');
    }
    state = const AsyncLoading();
    try {
      final registration = await _repository.createAnimalWithCollar(
        farmId: farmId,
        animalTag: animalTag,
        species: species,
        sex: sex,
        ageMonths: ageMonths,
        weightKg: weightKg,
        deviceId: deviceId,
      );
      await saveCurrentAnimalId(_ref, registration.animal.id);
      _ref.invalidate(herdAnimalsProvider);
      _ref.invalidate(farmCollarsProvider);
      state = AsyncData(
        previous.copyWith(
          animal: registration.animal,
          collar: registration.collar,
        ),
      );
      return registration;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<Collar> pairCollar(String deviceId) async {
    final previous = state.value ?? const OnboardingState();
    final storage = _ref.read(secureStorageProvider);
    final farmId = previous.farm?.id ?? await storage.readCurrentFarmId();
    final animalId = previous.animal?.id ?? await storage.readCurrentAnimalId();
    if (farmId == null || animalId == null) {
      throw StateError('Add a farm and animal before pairing a collar.');
    }
    state = const AsyncLoading();
    try {
      final collar = await _repository.pairCollar(
        deviceId: deviceId,
        farmId: farmId,
        animalId: animalId,
      );
      _ref.invalidate(farmCollarsProvider);
      state = AsyncData(previous.copyWith(collar: collar));
      return collar;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

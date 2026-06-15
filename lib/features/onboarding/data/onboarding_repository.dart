import 'package:dio/dio.dart';
import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/core/network/endpoints.dart';
import 'package:smart_collar_app/features/onboarding/data/models/animal.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';
import 'package:smart_collar_app/features/onboarding/data/models/farm.dart';

class OnboardingRepository {
  OnboardingRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  Future<List<Farm>> fetchFarms() async {
    try {
      final response = await _api.dio.get(ApiEndpoints.farms);
      return _extractList(response.data).map(Farm.fromJson).toList();
    } on DioException catch (error) {
      throw ApiException(_messageFromDio(error, 'Failed to load farms'));
    }
  }

  Future<Farm> createFarm({
    required String name,
    String? location,
    required String farmType,
  }) async {
    try {
      final response = await _api.dio.post(
        ApiEndpoints.farms,
        data: {
          'name': name.trim(),
          if (location != null && location.trim().isNotEmpty)
            'location': location.trim(),
          'farm_type': farmType,
        },
      );
      return Farm.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(_messageFromDio(error, 'Failed to create farm'));
    }
  }

  Future<Animal> createAnimal({
    required String farmId,
    required String animalTag,
    required String species,
    required String sex,
    int? ageMonths,
    double? weightKg,
  }) async {
    try {
      final payload = <String, dynamic>{
        'animal_tag': animalTag.trim(),
        'species': species,
        'sex': sex,
      };
      if (ageMonths != null) payload['age_months'] = ageMonths;
      if (weightKg != null) payload['weight_kg'] = weightKg;

      final response = await _api.dio.post(
        ApiEndpoints.farmAnimals(farmId),
        data: payload,
      );
      return Animal.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(_messageFromDio(error, 'Failed to add animal'));
    }
  }

  Future<AnimalCollarRegistration> createAnimalWithCollar({
    required String farmId,
    required String species,
    required String sex,
    int? ageMonths,
    double? weightKg,
    required String deviceId,
  }) async {
    try {
      final payload = <String, dynamic>{
        'species': species,
        'sex': sex,
        'device_id': deviceId.trim(),
      };
      if (ageMonths != null) payload['age_months'] = ageMonths;
      if (weightKg != null) payload['weight_kg'] = weightKg;

      final response = await _api.dio.post(
        ApiEndpoints.farmAnimalWithCollar(farmId),
        data: payload,
      );
      final object = _extractObject(response.data);
      return AnimalCollarRegistration(
        animal: Animal.fromJson(object['animal'] as Map<String, dynamic>),
        collar: Collar.fromJson(object['collar'] as Map<String, dynamic>),
      );
    } on DioException catch (error) {
      throw ApiException(
        _messageFromDio(error, 'Failed to register animal and collar'),
      );
    }
  }

  Future<Collar> pairCollar({
    required String deviceId,
    required String farmId,
    required String animalId,
  }) async {
    try {
      final response = await _api.dio.post(
        ApiEndpoints.collarsPair,
        data: {
          'device_id': deviceId.trim(),
          'farm_id': farmId,
          'animal_id': animalId,
        },
      );
      return Collar.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(_messageFromDio(error, 'Failed to pair collar'));
    }
  }

  Map<String, dynamic> _extractObject(Object? data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractList(Object? data) {
    final value = data is Map<String, dynamic> ? data['data'] : data;
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  String _messageFromDio(DioException error, String fallback) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] ?? responseData['error'];
      if (message is String && message.isNotEmpty) return message;
    }
    return error.message ?? fallback;
  }
}

class AnimalCollarRegistration {
  const AnimalCollarRegistration({required this.animal, required this.collar});

  final Animal animal;
  final Collar collar;
}

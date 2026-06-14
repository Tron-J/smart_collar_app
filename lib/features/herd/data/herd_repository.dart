import 'package:dio/dio.dart';
import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/core/network/endpoints.dart';
import 'package:smart_collar_app/features/onboarding/data/models/animal.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';

class HerdRepository {
  HerdRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  Future<List<Animal>> fetchAnimals(String farmId) async {
    try {
      final response = await _api.dio.get(ApiEndpoints.farmAnimals(farmId));
      return _extractList(response.data).map(Animal.fromJson).toList();
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to load herd');
    }
  }

  Future<Animal> fetchAnimal(String animalId) async {
    try {
      final response = await _api.dio.get(ApiEndpoints.animalById(animalId));
      return Animal.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to load animal');
    }
  }

  Future<List<Collar>> fetchCollars(String farmId) async {
    try {
      final response = await _api.dio.get(ApiEndpoints.farmCollars(farmId));
      return _extractList(response.data).map(Collar.fromJson).toList();
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to load collars');
    }
  }

  Future<Collar> disconnectCollar(String collarId) async {
    try {
      final response = await _api.dio.patch(
        ApiEndpoints.collarDisconnect(collarId),
      );
      return Collar.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to disconnect collar');
    }
  }

  List<Map<String, dynamic>> _extractList(Object? data) {
    final value = data is Map<String, dynamic> ? data['data'] : data;
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  Map<String, dynamic> _extractObject(Object? data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }
    return <String, dynamic>{};
  }
}

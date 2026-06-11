import 'package:dio/dio.dart';
import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/core/network/endpoints.dart';
import 'package:smart_collar_app/core/storage/hive_service.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';

class DashboardRepository {
  DashboardRepository({
    required ApiClient apiClient,
    required HiveService hiveService,
  }) : _api = apiClient,
       _hive = hiveService;

  final ApiClient _api;
  final HiveService _hive;

  Future<SensorReading?> fetchLatestReading(String animalId) async {
    try {
      final response = await _api.dio.get(
        ApiEndpoints.animalReadingsLatest(animalId),
      );
      final data = _extractObject(response.data);
      if (data.isEmpty) return null;
      await _hive.putJsonList(
        boxName: 'readings_$animalId',
        key: 'latest',
        value: [data],
      );
      return SensorReading.fromJson(data);
    } on DioException catch (error) {
      final cached = await _hive.readJsonList(
        boxName: 'readings_$animalId',
        key: 'latest',
      );
      if (cached.isNotEmpty) return SensorReading.fromJson(cached.first);
      throw ApiException(error.message ?? 'Failed to load latest reading');
    }
  }

  Future<List<SensorReading>> fetchReadings({
    required String animalId,
    DateTime? from,
    DateTime? to,
    int limit = 500,
  }) async {
    try {
      final response = await _api.dio.get(
        ApiEndpoints.animalReadings(animalId),
        queryParameters: {
          if (from != null) 'from': from.toIso8601String(),
          if (to != null) 'to': to.toIso8601String(),
          'limit': limit,
        },
      );
      final list = _extractList(response.data);
      await _hive.putJsonList(
        boxName: 'readings_$animalId',
        key: 'history',
        value: list,
      );
      return list.map(SensorReading.fromJson).toList();
    } on DioException catch (error) {
      final cached = await _hive.readJsonList(
        boxName: 'readings_$animalId',
        key: 'history',
      );
      if (cached.isNotEmpty) return cached.map(SensorReading.fromJson).toList();
      throw ApiException(error.message ?? 'Failed to load readings');
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
}

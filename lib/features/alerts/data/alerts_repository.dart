import 'package:dio/dio.dart';
import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/core/network/endpoints.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert_threshold.dart';

class AlertsRepository {
  AlertsRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  Future<List<Alert>> fetchAlerts({
    required String farmId,
    bool? resolved,
  }) async {
    try {
      final response = await _api.dio.get(
        ApiEndpoints.farmAlerts(farmId),
        queryParameters: resolved == null ? null : {'resolved': resolved},
      );
      final data = response.data;
      final list = data is Map<String, dynamic> ? data['data'] : data;
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map(Alert.fromJson)
            .toList();
      }
      return [];
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to load alerts');
    }
  }

  Future<Alert> fetchAlert(String alertId) async {
    try {
      final response = await _api.dio.get(ApiEndpoints.alertById(alertId));
      return Alert.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to load alert');
    }
  }

  Future<Alert> resolveAlert(String alertId) async {
    try {
      final response = await _api.dio.patch(ApiEndpoints.alertResolve(alertId));
      return Alert.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to resolve alert');
    }
  }

  Future<AlertThreshold?> fetchThreshold(String farmId) async {
    try {
      final response = await _api.dio.get(ApiEndpoints.farmThresholds(farmId));
      final list = _extractList(response.data);
      if (list.isEmpty) return null;
      return AlertThreshold.fromJson(list.first);
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to load thresholds');
    }
  }

  Future<AlertThreshold> updateThreshold(AlertThreshold threshold) async {
    try {
      final response = await _api.dio.patch(
        ApiEndpoints.thresholdById(threshold.id),
        data: threshold.toJson(),
      );
      return AlertThreshold.fromJson(_extractObject(response.data));
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Failed to update thresholds');
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

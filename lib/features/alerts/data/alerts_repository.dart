import 'package:dio/dio.dart';
import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/core/network/endpoints.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert.dart';

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
}

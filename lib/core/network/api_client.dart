import 'package:dio/dio.dart';
import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/storage/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  ApiClient({required String baseUrl, SecureStorage? storage})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (baseUrl.trim().isEmpty) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: ApiException(
                  'API_BASE_URL is not configured. Run with '
                  '--dart-define=API_BASE_URL=https://your-server',
                ),
              ),
            );
          }

          final token = _readSupabaseToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;

  Dio get dio => _dio;

  String? _readSupabaseToken() {
    try {
      return Supabase.instance.client.auth.currentSession?.accessToken;
    } catch (_) {
      return null;
    }
  }
}

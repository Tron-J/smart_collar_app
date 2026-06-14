import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/features/auth/data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    storage: ref.watch(secureStorageProvider),
    config: ref.watch(appConfigProvider),
  );
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthSession?>>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });

class AuthController extends StateNotifier<AsyncValue<AuthSession?>> {
  AuthController(this._repository) : super(const AsyncData(null));

  final AuthRepository _repository;

  Future<bool> hasStoredToken() => _repository.hasStoredToken();

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final session = await _repository.login(email: email, password: password);
      state = AsyncData(session);
      return session;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AuthSession> continueWithGoogle() async {
    state = const AsyncLoading();
    try {
      final session = await _repository.continueWithGoogle();
      state = AsyncData(session);
      return session;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await _repository.logout();
    state = const AsyncData(null);
  }
}

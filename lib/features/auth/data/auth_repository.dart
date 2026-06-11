import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/storage/secure_storage.dart';
import 'package:smart_collar_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    this.user,
    this.requiresOnboarding = true,
  });

  final String token;
  final UserModel? user;
  final bool requiresOnboarding;
}

class AuthRepository {
  AuthRepository({required SecureStorage storage}) : _storage = storage;

  final SecureStorage _storage;
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'full_name': fullName.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      },
    );
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final session = response.session;
    if (session == null) {
      throw ApiException('Supabase did not return a session.');
    }
    return _sessionFromSupabase(session);
  }

  Future<AuthSession> continueWithGoogle() async {
    final started = await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.smartcollar://login-callback',
    );
    if (!started) {
      throw ApiException('Google sign-in could not be started.');
    }

    final session = _supabase.auth.currentSession;
    if (session == null) {
      return const AuthSession(token: '', requiresOnboarding: true);
    }
    return _sessionFromSupabase(session);
  }

  Future<bool> hasStoredToken() async {
    return _supabase.auth.currentSession != null;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    await _storage.clearSession();
  }

  AuthSession _sessionFromSupabase(Session session) {
    final user = session.user;
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    return AuthSession(
      token: session.accessToken,
      user: UserModel(
        id: user.id,
        fullName:
            metadata['full_name'] as String? ??
            metadata['name'] as String? ??
            user.email ??
            'Farmer',
        email: user.email ?? '',
        phone: metadata['phone'] as String?,
        createdAt: DateTime.tryParse(user.createdAt),
      ),
      requiresOnboarding: true,
    );
  }
}

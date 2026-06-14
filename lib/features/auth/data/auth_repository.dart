import 'package:smart_collar_app/core/errors/exceptions.dart';
import 'package:smart_collar_app/core/config/app_config.dart';
import 'package:smart_collar_app/core/storage/secure_storage.dart';
import 'package:smart_collar_app/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  AuthRepository({required SecureStorage storage, required AppConfig config})
    : _storage = storage,
      _config = config;

  final SecureStorage _storage;
  final AppConfig _config;
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
    if (_config.googleWebClientId.trim().isEmpty) {
      throw ApiException(
        'Google sign-in is not configured. Build the app with GOOGLE_WEB_CLIENT_ID.',
      );
    }

    final googleSignIn = GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: _config.googleWebClientId,
    );
    await googleSignIn.signOut();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw ApiException('Google sign-in was cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw ApiException(
        'Google did not return an ID token. Check the Google Web Client ID.',
      );
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
    final session = response.session;
    if (session == null) {
      throw ApiException('Supabase did not return a Google session.');
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

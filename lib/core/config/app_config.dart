class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.websocketBaseUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment('API_BASE_URL'),
      websocketBaseUrl: String.fromEnvironment('WS_BASE_URL'),
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }

  final String apiBaseUrl;
  final String websocketBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get hasApiBaseUrl => apiBaseUrl.trim().isNotEmpty;
  bool get hasWebsocketBaseUrl => websocketBaseUrl.trim().isNotEmpty;
  bool get hasSupabaseConfig =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;
}

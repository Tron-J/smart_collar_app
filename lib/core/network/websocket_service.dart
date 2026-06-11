import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService({required this.baseUrl});

  final String baseUrl;
  WebSocketChannel? _channel;
  String? _token;
  Timer? _reconnectTimer;
  int _attempt = 0;
  bool _closedByUser = false;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect(String token) {
    _token = token;
    _closedByUser = false;
    final uri = Uri.parse('$baseUrl?token=$token');
    _channel = WebSocketChannel.connect(uri);
    _channel?.stream.listen(
      (event) {
        _attempt = 0;
        if (event is String) {
          final decoded = json.decode(event);
          if (decoded is Map<String, dynamic>) {
            _controller.add(decoded);
          }
        }
      },
      onError: (_) => _scheduleReconnect(),
      onDone: _scheduleReconnect,
    );
  }

  void disconnect() {
    _closedByUser = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  void _scheduleReconnect() {
    if (_closedByUser || _token == null || baseUrl.trim().isEmpty) return;
    _reconnectTimer?.cancel();
    final seconds = (1 << _attempt).clamp(1, 30);
    _attempt = (_attempt + 1).clamp(0, 5);
    _reconnectTimer = Timer(Duration(seconds: seconds), () {
      final token = _token;
      if (token != null && !_closedByUser) {
        connect(token);
      }
    });
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}

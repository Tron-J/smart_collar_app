import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService({required this.baseUrl});

  final String baseUrl;
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect(String token) {
    final uri = Uri.parse('$baseUrl?token=$token');
    _channel = WebSocketChannel.connect(uri);
    _channel?.stream.listen(
      (event) {
        if (event is String) {
          final decoded = json.decode(event);
          if (decoded is Map<String, dynamic>) {
            _controller.add(decoded);
          }
        }
      },
      onError: (_) {},
      onDone: () {},
    );
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}

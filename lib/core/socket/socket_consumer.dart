import 'package:cliniq/core/socket/socket_status.dart';

abstract class SocketConsumer {
  SocketStatus get status;

  Stream<SocketStatus> get statusStream;

  bool get isConnected;

  void init({
    String? url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool autoConnect = false,
  });

  Future<void> connect();

  Future<void> disconnect();

  Future<void> reconnect();

  void emit(String event, [dynamic data]);

  void on(String event, void Function(dynamic data) handler);

  void off(String event, [void Function(dynamic data)? handler]);

  void dispose();
}

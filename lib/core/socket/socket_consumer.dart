import 'package:cliniq/core/socket/socket_status.dart';

abstract class SocketConsumer {
  SocketStatus get status;

  Stream<SocketStatus> get statusStream;

  bool get isConnected;

  Future<void> connect();

  Future<void> disconnect();

  Future<void> reconnect();

  Future<void> invoke(String method, List<dynamic> args);

  void on(String event, void Function(List<dynamic>? arguments) handler);

  void dispose();
}

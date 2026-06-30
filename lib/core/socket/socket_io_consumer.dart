import 'dart:async';

import 'package:cliniq/core/socket/socket_config.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_events.dart';
import 'package:cliniq/core/socket/socket_status.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIoConsumer implements SocketConsumer {
  SocketIoConsumer({this.baseUrl = SocketConfig.baseUrl});

  final String baseUrl;

  io.Socket? _socket;
  SocketStatus _status = SocketStatus.initial;
  final StreamController<SocketStatus> _statusController =
      StreamController<SocketStatus>.broadcast();

  @override
  SocketStatus get status => _status;

  @override
  Stream<SocketStatus> get statusStream => _statusController.stream;

  @override
  bool get isConnected => _socket?.connected ?? false;

  @override
  void init({
    String? url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool autoConnect = false,
  }) {
    _socket?.dispose();

    final optionsBuilder = io.OptionBuilder()
        .setTransports(['websocket'])
        .enableReconnection()
        .disableAutoConnect();

    if (query != null && query.isNotEmpty) {
      optionsBuilder.setQuery(query);
    }

    if (headers != null && headers.isNotEmpty) {
      optionsBuilder.setExtraHeaders(headers);
    }

    _socket = io.io(url ?? baseUrl, optionsBuilder.build());
    _registerDefaultListeners();
    _setStatus(SocketStatus.initialized);

    if (autoConnect) {
      connect();
    }
  }

  @override
  Future<void> connect() async {
    final socket = _socket ?? _createDefaultSocket();

    if (socket.connected) {
      _setStatus(SocketStatus.connected);
      return;
    }

    _setStatus(SocketStatus.connecting);
    socket.connect();
  }

  @override
  Future<void> disconnect() async {
    _socket?.disconnect();
    _setStatus(SocketStatus.disconnected);
  }

  @override
  Future<void> reconnect() async {
    await disconnect();
    await connect();
  }

  @override
  void emit(String event, [dynamic data]) {
    _socket?.emit(event, data);
  }

  @override
  void on(String event, void Function(dynamic data) handler) {
    _socket?.on(event, handler);
  }

  @override
  void off(String event, [void Function(dynamic data)? handler]) {
    if (handler == null) {
      _socket?.off(event);
      return;
    }

    _socket?.off(event, handler);
  }

  @override
  void dispose() {
    _socket?.dispose();
    _socket = null;
    _setStatus(SocketStatus.disconnected);
    _statusController.close();
  }

  io.Socket _createDefaultSocket() {
    init();
    return _socket!;
  }

  void _registerDefaultListeners() {
    _socket
      ?..on(SocketEvents.connect, (_) => _setStatus(SocketStatus.connected))
      ..on(
        SocketEvents.disconnect,
        (_) => _setStatus(SocketStatus.disconnected),
      )
      ..on(
        SocketEvents.connectError,
        (_) => _setStatus(SocketStatus.disconnected),
      )
      ..on(
        SocketEvents.reconnectAttempt,
        (_) => _setStatus(SocketStatus.connecting),
      )
      ..on(SocketEvents.reconnect, (_) => _setStatus(SocketStatus.connected))
      ..on(
        SocketEvents.reconnectError,
        (_) => _setStatus(SocketStatus.disconnected),
      );
  }

  void _setStatus(SocketStatus status) {
    if (_status == status) {
      return;
    }

    _status = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }
}

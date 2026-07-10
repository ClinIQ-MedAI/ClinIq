import 'dart:async';
import 'dart:developer';

import 'package:cliniq/core/socket/socket_config.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_status.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService implements SocketConsumer {
  SignalRService({this.hubUrl = SocketConfig.signalrBaseUrl});

  final String hubUrl;
  HubConnection? _connection;
  String? _currentJwtToken;
  SocketStatus _status = SocketStatus.initial;

  final StreamController<SocketStatus> _statusController =
      StreamController<SocketStatus>.broadcast();

  @override
  SocketStatus get status => _status;

  @override
  Stream<SocketStatus> get statusStream => _statusController.stream;

  @override
  bool get isConnected => _status == SocketStatus.connected;

  @override
  Future<void> connect({String? jwtToken}) async {
    if (isConnected) {
      log('SignalR: Already connected');
      return;
    }

    _currentJwtToken = jwtToken;
    await _disconnectIfNeeded();
    _setStatus(SocketStatus.connecting);

    try {
      final options = HttpConnectionOptions(
        accessTokenFactory: () async => _currentJwtToken ?? '',
        transport: HttpTransportType.WebSockets,
        logMessageContent: true,
      );

      _connection = HubConnectionBuilder()
          .withUrl(hubUrl, options: options)
          .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 30000])
          .build();

      _connection!.onclose(({Exception? error}) {
        log('SignalR: Connection closed (error: $error)');
        _setStatus(SocketStatus.disconnected);
      });

      _connection!.onreconnecting(({Exception? error}) {
        log('SignalR: Reconnecting... (error: $error)');
        _setStatus(SocketStatus.connecting);
      });

      _connection!.onreconnected(({String? connectionId}) {
        log('SignalR: Reconnected (connectionId: $connectionId)');
        _setStatus(SocketStatus.connected);
      });

      await _connection!.start();
      log('SignalR: Connected successfully');
      _setStatus(SocketStatus.connected);
    } catch (e) {
      log('SignalR: Failed to connect: $e');
      _setStatus(SocketStatus.disconnected);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _disconnectIfNeeded();
    _setStatus(SocketStatus.disconnected);
  }

  @override
  Future<void> reconnect({String? jwtToken}) async {
    if (jwtToken != null) _currentJwtToken = jwtToken;
    await disconnect();
    await connect(jwtToken: _currentJwtToken);
  }

  @override
  Future<void> invoke(String method, List<dynamic> args) async {
    if (_connection == null) {
      log('SignalR: Cannot invoke $method — not connected');
      return;
    }
    try {
      log('SignalR: Invoking $method');
      await _connection!.invoke(method, args: List<Object>.from(args));
      log('SignalR: Invoke $method succeeded');
    } catch (e) {
      log('SignalR: invoke $method failed: $e');
      rethrow;
    }
  }

  @override
  void on(String event, void Function(List<dynamic>? arguments) handler) {
    _connection?.on(event, (List<Object?>? arguments) {
      log('SignalR: Received event: $event');
      handler(arguments?.cast<dynamic>());
    });
  }

  @override
  void dispose() {
    _connection?.stop();
    _connection = null;
    _setStatus(SocketStatus.disconnected);
    _statusController.close();
  }

  Future<void> _disconnectIfNeeded() async {
    if (_connection != null) {
      try {
        await _connection!.stop();
      } catch (_) {}
      _connection = null;
    }
  }

  void _setStatus(SocketStatus status) {
    if (_status == status) return;
    _status = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }
}

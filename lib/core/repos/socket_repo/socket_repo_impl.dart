
import 'package:cliniq/core/repos/socket_repo/socket_repo.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_events.dart';

class SocketRepoImpl implements SocketRepo {
  final SocketConsumer socket;

  SocketRepoImpl({required this.socket});

  @override
  bool get isConnected => socket.isConnected;

  @override
  void connect() =>
      socket.connect();

  @override
  void disconnect() => socket.disconnect();

  @override
  void dispose() => socket.dispose();

  @override
  void onConnect(Function(dynamic) callback) {
    socket.on("connect", callback);
  }

  @override
  void offConnect(Function(dynamic) callback) {
    socket.on("connect", callback);
  }

 
  @override
  void onReceiveMessage(Function(dynamic data) callback) {
    socket.on(SocketEvents.receiveMessage, callback);
  }
  
  @override
  void joinConversation(int conversationId) {
  }
  
  @override
  void leaveConversation(int conversationId) {
  }
}

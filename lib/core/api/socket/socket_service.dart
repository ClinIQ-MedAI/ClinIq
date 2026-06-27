import 'package:cliniq/core/api/api_urls.dart';

class SocketService {
  SocketService({this.baseUrl = ApiUrls.socketBaseUrl});

  final String baseUrl;
  bool _isInitialized = false;
  bool _isConnected = false;

  bool get isInitialized => _isInitialized;
  bool get isConnected => _isConnected;

  void init() {
    _isInitialized = true;
  }

  Future<void> connect() async {
    _isConnected = true;
  }

  Future<void> disconnect() async {
    _isConnected = false;
  }

  Future<void> reconnect() async {
    await disconnect();
    await connect();
  }

  void joinRoom(String roomId) {}

  void leaveRoom(String roomId) {}

  void sendMessage({
    required String roomId,
    required Map<String, dynamic> message,
  }) {}

  void sendTypingStatus({required String roomId, required bool isTyping}) {}

  void markMessageSeen({required String roomId, required String messageId}) {}

  void onMessage(void Function(Map<String, dynamic> message) handler) {}

  void onTypingStatus(void Function(Map<String, dynamic> status) handler) {}

  void onOnlineStatus(void Function(Map<String, dynamic> status) handler) {}
}

abstract class SocketRepo {
  bool get isConnected;

  void connect();
  void disconnect();
  void dispose();

  void onConnect(Function(dynamic) callback);
  void offConnect(Function(dynamic) callback);

  void joinConversation(int conversationId);
  void leaveConversation(int conversationId);

  void onReceiveMessage(Function(dynamic data) callback);
}

class SocketEvents {
  const SocketEvents._();

  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String connectError = 'connect_error';
  static const String reconnect = 'reconnect';
  static const String reconnectAttempt = 'reconnect_attempt';
  static const String reconnectError = 'reconnect_error';

  static const String joinConversation = 'joinConversation';
  static const String leaveConversation = 'leaveConversation';
  static const String sendMessage = 'sendMessage';
  static const String receiveMessage = 'receiveMessage';
  static const String typing = 'typing';
  static const String stopTyping = 'stopTyping';
  static const String seen = 'seen';
  static const String online = 'online';
  static const String offline = 'offline';
}

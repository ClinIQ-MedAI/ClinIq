import 'package:cliniq/core/models/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  const ServerException({required this.errModel});

  @override
  String toString() => errModel.message;
}

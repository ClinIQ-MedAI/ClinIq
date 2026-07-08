import 'dart:async';
import 'dart:developer';

import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/dummy/dummy_responses.dart';

class DummyApiConsumer extends ApiConsumer {
  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyResponses.getResponse(path, queryParameters: queryParameters);
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    log(data.toString());
    await Future.delayed(const Duration(seconds: 1));
    return DummyResponses.getResponse(path, queryParameters: queryParameters);
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyResponses.getResponse(path, queryParameters: queryParameters);
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyResponses.getResponse(path, queryParameters: queryParameters);
  }

  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyResponses.getResponse(path, queryParameters: queryParameters);
  }
}

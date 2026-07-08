import 'package:cliniq/core/api/api_keys.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor({required this.dio});
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept-language'] = "en";
    options.extra['withCredentials'] = true;

    final resetToken = await AppStorageHelper.getSecureData(
      StorageKeys.resetToken,
    );

    if (resetToken != null) {
      options.headers['Authorization'] = 'Bearer $resetToken';
      return handler.next(options);
    }

    final accessToken = await AppStorageHelper.getSecureData(
      StorageKeys.accessToken,
    );

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint("error: ApiInterceptor.onError()");
    debugPrint("status message: ${err.response?.statusMessage}");
    debugPrint("response data: ${err.response?.data}");
    debugPrint("response status code: ${err.response?.statusCode}");

    final data = err.response?.data;
    final statusMessage = err.response?.statusMessage;
    final statusCode = err.response?.statusCode;

    String? message;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString();
    } else if (data is String) {
      message = data;
    }

    // if (statusMessage == 'Unauthorized' && statusCode == 401) {
    //   try {
    //     await handleUnAuthorizedException(err, handler);
    //     return;
    //   } catch (e) {
    //     debugPrint("error in get refresh token part: ${e.toString()}");
    //     await forcesUserLogOut(handler, err);
    //     return;
    //   }
    // }

    if (message == "You are not logged in! please login to get access.") {
      await handleNoRefreshTokenFound(handler, err);
      return;
    }

    return handler.reject(err);
  }

  Future<void> handleNoRefreshTokenFound(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    debugPrint("No refreshToken found in cookie");
    await forcesUserLogOut(handler, err);
  }

  Future<void> handleUnAuthorizedException(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint("error in ApiInterceptors: Unable to verify token");
    final refreshResponse = await dio.post(EndPoints.refreshToken);
    final newAccessToken = refreshResponse.data[ApiKeys.accessToken];
    await AppStorageHelper.setSecureData(
      StorageKeys.accessToken,
      newAccessToken,
    );

    final opts = err.requestOptions;
    opts.headers['Authorization'] = 'Bearer $newAccessToken';
    await retryRequestWithNewToken(err, handler, newAccessToken);
    return;
  }

  Future<void> forcesUserLogOut(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    await AppStorageHelper.deleteSecureData(StorageKeys.accessToken);

    await AppStorageHelper.setBool(StorageKeys.isLoggedIn, false);

    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator context is null ,can`t navigate to login screen");
    } else {
      debugPrint("Navigating to login screen..");
      Navigator.of(
        navigatorKey.currentContext!,
      ).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
    }
  }

  Future<void> retryRequestWithNewToken(
    DioException err,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    final updatedOptions = Options(
      method: err.requestOptions.method,
      headers: {"Authorization": "Bearer $newToken"},
    );

    try {
      final retryResponse = await dio.request(
        err.requestOptions.path,
        options: updatedOptions,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
      handler.resolve(retryResponse);
    } catch (retryError, retryStackTrace) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: retryError,
          stackTrace: retryStackTrace,
        ),
      );
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_model.dart';
import '../auth/auth_provider.dart';
import 'dio_base.dart';

class CustomInterceptors extends InterceptorsWrapper {
  final Ref ref;
  final auth;

  CustomInterceptors({
    required this.ref,
    required this.auth,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('auth: ${auth.value}');
    if (auth.value != null) {
      options.headers['Authorization'] = '${auth.value!.accessToken}';
    }
    // data to json
    try {
      if (options.data != null) {
        options.data = options.data.toJson();
      }
      log('data: ${options.data}');
    } catch (e) {
      log('Failed to convert data to json $e');
    }
    log('[REQ] [${options.method}] ${options.uri} ${options.data} ${options.headers}');

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    log('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} ${response.data?.toString()}  ');
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    err,
    ErrorInterceptorHandler handler,
  ) async {
    log('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} ${err.response?.statusCode} ${err.requestOptions.data} ${err.response?.data}');

    final isAuthError = err.response?.statusCode == 401;
    final isAuthPath = err.requestOptions.path == '/auth/login/refresh' ||
        err.requestOptions.path == '/auth/login/kakao';
    if (isAuthError && !isAuthPath) {
      try {
        if (auth.value == null) {
          return handler.reject(err);
        }

        // refresh token이 있을 경우, 새로운 access token을 요청한다.
        Dio retryDio = Dio(dioOptions);
        final respToken = await retryDio.post('/auth/login/refresh', data: {
          'refresh_token': auth.value.refreshToken,
        });
        if (respToken.data['access_token'] == null ||
            respToken.data['refresh_token'] == null) {
          throw Exception('토큰이 없습니다.');
        }
        final freshToken = Auth.fromJson(respToken.data);
        ref.read(authControllerProvider.notifier).authorize(freshToken);
        final options = err.requestOptions;
        options.headers.addAll({'Authorization': freshToken.accessToken});

        //재요청
        final response = await retryDio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        log('Failed to refresh token $e');
        try {
          ref.read(authControllerProvider.notifier).unAuthorize();
        } catch (e) {
          log('Failed to delete all storage');
        }
        return handler.reject(err);
      }
    }

    return super.onError(err, handler);
  }
}

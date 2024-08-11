import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:watso_v2/common/storage/storage_provider.dart';

import '../dio/dio_base.dart';
import 'auth_model.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  final authDio = Dio(dioOptions);
  final interceptor = InterceptorsWrapper(
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      log('[REQ] [${options.method}] ${options.uri} ${options.data} ${options.headers}');
      return handler.next(options);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      log('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} ${response.data?.toString()}  ');

      return handler.next(response);
    },
    onError: (DioException err, ErrorInterceptorHandler handler) {
      log('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} ${err.response?.statusCode} ${err.requestOptions.data} ${err.response?.data}');

      return handler.next(err);
    },
  );
  late final storage;

  @override
  Future<Auth?> build() async {
    try {
      authDio.interceptors.add(interceptor);
      storage = ref.read(storageControllerProvider.notifier);
      Auth? auth = await storage.getToken();
      if (auth == null) {
        return null;
      }
      final freshAuth = await _getCheckAuthFromRefresh(auth);
      await authorize(freshAuth);
      return freshAuth;
    } catch (e) {
      log('토큰 로드 실패 $e');
      return null;
    }
  }

  authorize(Auth auth) async {
    storage.setToken(auth);
    state = AsyncData(auth);
  }

  unAuthorize() {
    storage.removeToken();
    state = const AsyncData(null);
  }

  loginWithKakao() async {
    OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
    log('카카오톡으로 로그인 성공 accessToken: ${token.accessToken} , idToken: ${token.idToken}');

    Auth auth = await _loginWithToken(token);
    authorize(auth);
  }

  Future<Auth> _getCheckAuthFromRefresh(Auth auth) async {
    final response = await authDio.post('/auth/login/refresh', data: {
      'refresh_token': auth.refreshToken,
    });
    final data = response.data;
    if (data['access_token'] == null || data['refresh_token'] == null) {
      throw Exception('토큰이 없습니다.');
    }
    return Auth.fromJson(data);
  }

  Future<Auth> _loginWithToken(token) async {
    final response = await authDio.get('/auth/login/kakao', queryParameters: {
      'access_token': token.accessToken,
    });
    final data = response.data;
    if (data['access_token'] == null || data['refresh_token'] == null) {
      throw Exception('토큰이 없습니다.');
    }
    log('토큰으로 로그인 성공 data: $data');
    return Auth.fromJson(data);
  }
}

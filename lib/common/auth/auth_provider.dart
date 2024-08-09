import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:watso_v2/common/storage/storage_provider.dart';

import '../dio/dio.dart';
import 'auth_model.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<Auth?> build() async {
    try {
      final storage = ref.read(storageControllerProvider.notifier);
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
    final storage = ref.read(storageControllerProvider.notifier);
    storage.setToken(auth);
    state = AsyncData(auth);
  }

  unAuthorize() {
    final storage = ref.read(storageControllerProvider.notifier);
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
    Dio dio = ref.watch(dioProvider);
    final response = await dio.post('/auth/login/refresh', data: {
      'refresh_token': auth.refreshToken,
    });
    final data = response.data;
    if (data['access_token'] == null || data['refresh_token'] == null) {
      throw Exception('토큰이 없습니다.');
    }
    return Auth.fromJson(data);
  }

  Future<Auth> _loginWithToken(token) async {
    Dio dio = ref.watch(dioProvider);
    final response = await dio.get('/auth/login/kakao', queryParameters: {
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

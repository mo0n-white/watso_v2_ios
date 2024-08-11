import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_model.dart';
import './storage_type.dart';

part 'storage_provider.g.dart';

@Riverpod(keepAlive: true)
class StorageController extends _$StorageController {
  @override
  FlutterSecureStorage build() {
    return const FlutterSecureStorage();
  }

  Future setToken(Auth auth) async {
    await state.write(key: AuthToken.accessToken.name, value: auth.accessToken);
    await state.write(
        key: AuthToken.refreshToken.name, value: auth.refreshToken);
  }

  Future removeToken() async {
    await state.delete(key: AuthToken.accessToken.name);
    await state.delete(key: AuthToken.refreshToken.name);
  }

  Future<Auth?> getToken() async {
    final accessToken = await state.read(key: AuthToken.accessToken.name);
    final refreshToken = await state.read(key: AuthToken.refreshToken.name);
    if (accessToken == null || refreshToken == null) return null;
    return Auth(accessToken: accessToken, refreshToken: refreshToken);
  }
}

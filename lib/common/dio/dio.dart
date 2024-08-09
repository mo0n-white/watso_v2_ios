import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:watso_v2/common/auth/auth_provider.dart';
import 'package:watso_v2/common/dio/dio_base.dart';

import 'dio_handling.dart';

part 'dio.g.dart';

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio(dioOptions);
  final auth = ref.watch(authControllerProvider);
  dio.interceptors.add(CustomInterceptors(ref: ref, auth: auth));
  return dio;
}

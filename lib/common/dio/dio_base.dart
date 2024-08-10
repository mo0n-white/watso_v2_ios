import 'package:dio/dio.dart';

var dioOptions = BaseOptions(
  baseUrl: 'http://138.2.117.76:8000/api',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
);

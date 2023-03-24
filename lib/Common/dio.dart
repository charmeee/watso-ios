import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:dio_cookie_manager/dio_cookie_manager.dart';
//import 'package:cookie_jar/cookie_jar.dart';

import 'dio_base.dart';
import 'dio_handling.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider =
Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(options);
  //dio.interceptors.add(CookieManager(CookieJar()));
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(ref: ref, storage: storage));
  return dio;
});


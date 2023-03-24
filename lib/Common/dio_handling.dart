import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Auth/auth_provider.dart';
import 'dio_base.dart';
import 'global.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log('[REQ] [${options.method}] ${options.uri} ${options.data}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: 'ACCESS_TOKEN');

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: 'REFRESH_TOKEN');

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} ${response.data?.toString()} ${response.headers}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    log('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} ${err
        .requestOptions.data} ${err.response?.data}');

    final refreshToken = await storage.read(key: 'REFRESH_TOKEN');

    // refreshToken 아예 없으면
    // 당연히 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/signin/refresh';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio(options);

      try {
        final resp = await dio.get('/signin/refresh', queryParameters: {
          'Authorization': storage.read(key: "accessToken")
        });

        final accessToken = resp.headers["authentication"].toString();

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: 'ACCESS_TOKEN', value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch (e) {
        // circular dependency error
        // A, B
        // A -> B의 친구
        // B -> A의 친구
        // A는 B의 친구구나
        // A -> B -> A -> B -> A -> B
        // ump -> dio -> ump -> dio
        ref.read(authStateProvider.notifier).state = AuthState.error;
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}

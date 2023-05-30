import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Auth/provider/user_provider.dart';
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
    log('[REQ] [${options.method}] ${options.uri} ${options.data} ${options.headers}');
    final token = await storage.read(key: 'accessToken');
    // log('token: $token');
    //실제 토큰으로 대체
    if (token != null) {
      options.headers.addAll({
        'Authorization': token,
      });
    }
    log('[REQ]header: ${options.headers}');

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} ${response.data?.toString()}  ');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    try {
      log('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} ${err.response?.statusCode} ${err.requestOptions.data} ${err.response?.data}');

      final refreshToken = await storage.read(key: 'refreshToken');

      // refreshToken 아예 없으면
      // 당연히 에러를 던진다
      if (refreshToken == null) {
        // 에러를 던질때는 handler.reject를 사용한다.
        return handler.reject(err);
      }

      final isStatus401 = err.response?.statusCode == 401;

      final isExpiredToken = (err.response?.data is Map) &&
          (err.response?.data['code'] == 201 ||
              err.response?.data['code'] == "201" ||
              err.response?.data['code'] == 200 ||
              err.response?.data['code'] == "200");

      final isPathAuthRefresh = err.requestOptions.path == '/auth/refresh';
      if (isStatus401 && isExpiredToken && !isPathAuthRefresh) {
        final dio = Dio(options);
        try {
          log('refresh token 발급');
          final refreshToken = await storage.read(key: 'refreshToken');
          dio.options.headers['Authorization'] = refreshToken;
          if (refreshToken == null) {
            throw DioError(
              requestOptions: err.requestOptions,
              response: err.response,
            );
          }
          final resp = await dio.get('/auth/refresh');
          final accessToken = resp.headers["authentication"]?[0];
          if (accessToken == null) {
            throw DioError(
              requestOptions: err.requestOptions,
              response: err.response,
            );
          }
          log('refresh token 성공 $accessToken');
          final options = err.requestOptions;

          // 토큰 변경하기
          options.headers.addAll({
            'Authorization': accessToken,
          });

          await storage.write(key: 'accessToken', value: accessToken);

          // 요청 재전송
          final response = await dio.fetch(options);

          return handler.resolve(response);
        } on DioError catch (e) {
          log('Dio refresh token 실패 ${e.response?.statusCode} ${e.response?.data}');
        } catch (e) {
          log('e refresh token 실패 ${e.toString()}');
        }
        showErrorDialog('다시 로그인 해 주세요');
        await ref.read(userNotifierProvider.notifier).init();
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
      }
      return handler.reject(err);
    } catch (e, s) {
      log('error: ${e.toString()}');
      log('stack: $s');
      return handler.reject(err);
    }
  }
}

void showErrorDialog(String errorMessage) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final context = navigatorState.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('에러 발생'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      ).then((value) async {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }
  });
}

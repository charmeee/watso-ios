import 'dart:developer';

import 'package:dio/dio.dart';

class ServerException implements Exception {
  //서버에러
  final DioError error;

  @override
  String toString() {
    switch (error.type) {
      case DioErrorType.badResponse:
        return _ServerBadResponseException(error).toString();
      case DioErrorType.connectionError:
        return '연결을 다시 시도해주세요.';
      default:
        return '에러가 발생하였습니다.';
    }
  }

  ServerException(this.error);
}

class _ServerBadResponseException implements Exception {
  // 연결을 다시 시도해보세요/
  final DioError error;

  @override
  String toString() {
    if (error.response?.statusCode == null) return '서버 에러가 발생하였습니다.';
    if (error.response!.statusCode! >= 400) {
      return '잘못된 접근입니다.';
    } else {
      return '서버 에러가 발생하였습니다.';
    }
  }

  _ServerBadResponseException(this.error);
}

class DataParsingException implements Exception {
  //파싱이 잘못됨.
  final String error;

  @override
  String toString() {
    return '옳지 않은 형식입니다.';
  }

  DataParsingException(this.error) {
    log('데이터 파싱 실패 : $error');
  }
}

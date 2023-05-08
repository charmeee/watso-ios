import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sangsangtalk/Auth/models/user_model.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';
import '../models/user_request_model.dart';
import 'auth_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final storage = ref.watch(secureStorageProvider);
    const staticUrl = '/user';

    return UserRepository(dio, storage, staticUrl, ref);
  },
);

class UserRepository {
  UserRepository(this._dio, this.storage, this.staticUrl, this.ref);

  final String staticUrl;
  final FlutterSecureStorage storage;
  final Dio _dio;
  final Ref ref;

  Future<void> signUp(String username, String nickname, String name,
      String password, String email, String account, String token) async {
    try {
      await _dio.post('$staticUrl/signup', data: {
        'username': username,
        'pw': password,
        'nickname': nickname,
        'name': name,
        'account_number': account,
        'email': email,
        'auth_token': token,
      });
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw Exception("알 수 없는 에러");
    }
  }

  Future<void> sendValidEmail(String email) async {
    try {
      await _dio.get('$staticUrl/signup', queryParameters: {
        'email': email,
      });
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw Exception("알 수 없는 에러");
    }
  }

  Future<String> checkValidEmail(String email, String validCode) async {
    try {
      final response = await _dio
          .get('$staticUrl/signup/validation-check', queryParameters: {
        'email': email,
        'auth-code': validCode,
      });
      return response.data['auth_token'];
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw Exception("알 수 없는 에러");
    }
  }

  Future<UserInfo> getUserProfile() async {
    try {
      final response = await _dio.get('$staticUrl/profile');
      return UserInfo.fromJson(response.data);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future<void> updateUserProfile(UserInfo userInfo) async {
    try {
      await _dio.patch('$staticUrl/profile', data: userInfo.toJson());
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future<bool> checkDuplicated(
      {required DuplicateCheckField field, required String value}) async {
    try {
      final response = await _dio.get('$staticUrl/duplicate-check',
          queryParameters: {'field': field.name, 'value': value});
      return response.data['is_duplicated'];
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future deleteAccount() async {
    try {
      await _dio.delete('$staticUrl/profile');
      await ref.read(authRepositoryProvider).initUser();
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //닉네임 계좌 비밀번호 변경
  Future<void> updateUserInfo(String field, String value) async {
    if (field == 'nickname' ||
        field == 'accountNumber' ||
        field == 'password') {
      Map data = {};
      if (field == 'accountNumber') {
        data = {
          'account_number': value,
        };
        field = 'account-number';
      } else {
        data = {
          field: value,
        };
      }
      try {
        await _dio.patch('$staticUrl/profile/$field', data: data);
      } on DioError catch (e) {
        throw ServerException(e);
      } catch (e, s) {
        throw DataParsingException(e, s);
      }
    }
  }
}

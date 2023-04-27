import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sangsangtalk/Auth/models/user_model.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final storage = ref.watch(secureStorageProvider);
    const staticUrl = '/user';

    return UserRepository(dio, storage, staticUrl);
  },
);

class UserRepository {
  UserRepository(this._dio, this.storage, this.staticUrl);

  final String staticUrl;
  final FlutterSecureStorage storage;
  final Dio _dio;

  Future<void> signUp(String username, String nickname, String password,
      String email, String account) async {
    try {
      await _dio.post('$staticUrl/signup', data: {
        'username': username.toString(),
        'pw': password.toString(),
        'nickname': nickname.toString(),
        'account_number': account.toString(),
        'email': email.toString(),
      });
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
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }

  Future<void> updateUserProfile(UserInfo userInfo) async {
    try {
      await _dio.put('$staticUrl/profile', data: userInfo.toJson());
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }
}

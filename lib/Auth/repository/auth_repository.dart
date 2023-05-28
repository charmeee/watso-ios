import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final storage = ref.watch(secureStorageProvider);
    const staticUrl = '/auth';

    return AuthRepository(dio, storage, staticUrl);
  },
);

class AuthRepository {
  AuthRepository(this._dio, this.storage, this.staticUrl);

  final String staticUrl;
  final FlutterSecureStorage storage;
  final Dio _dio;

  Future<void> login(String username, String password) async {
    try {
      //storage 읽고
      final response = await _dio.post('$staticUrl/login', data: {
        'username': username,
        'pw': password,
      });
      final token =
          response.headers["authentication"]![0].toString().split("/");
      await storage.delete(key: "accessToken");
      await storage.write(key: "accessToken", value: token[0]);
      await storage.delete(key: "refreshToken");
      await storage.write(key: "refreshToken", value: token[1]);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw TokenSetupException(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _dio.delete('$staticUrl/logout');
      await initUser();
    } on DioError catch (e) {
      await initUser();
      throw ServerException(e);
    } catch (e) {
      throw TokenSetupException(e.toString());
    }
  }

  Future<void> initUser() async {
    await storage.delete(key: "accessToken");
    await storage.delete(key: "refreshToken");
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';

final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    const staticUrl = '/api/delivery/store';

    return StoreRepository(dio, staticUrl);
  },
);

class StoreRepository {
  StoreRepository(this._dio, this.staticUrl);

  final String staticUrl;
  final Dio _dio;

  Future<List<Store>> getStoreList() async {
    try {
      final response = await _dio.get(staticUrl);
      return (response.data as List).map((e) => Store.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<StoreMenus> getStoreMenuList(storeId) async {
    try {
      final response = await _dio.get('$staticUrl/$storeId');
      return StoreMenus.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}

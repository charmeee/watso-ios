import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';

final postOrderRepositoryProvider = Provider<PostOrderRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    const staticUrl = '/api/delivery/post';

    return PostOrderRepository(dio, staticUrl);
  },
);

class PostOrderRepository {
  PostOrderRepository(this._dio, this.staticUrl);

  final String staticUrl;
  final Dio _dio;

  Future<List<ResponsePostList>> getDeliveryList(PostFilter filter) async {
    try {
      final response = await _dio.get(staticUrl, queryParameters: {
        'filter': filter.name,
      });
      return (response.data as List)
          .map((e) => ResponsePostList.fromJson(e))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}

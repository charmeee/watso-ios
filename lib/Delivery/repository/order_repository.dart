import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';
import '../models/post_response_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    const staticUrl = '/api/delivery/order';

    return OrderRepository(dio, staticUrl);
  },
);

class OrderRepository {
  OrderRepository(this._dio, this.staticUrl);

  final String staticUrl;
  final Dio _dio;

  Future<PostDetailOrder> getMyPostOrder(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId/me');
      return PostDetailOrder.fromJson(response.data['order']);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }

  Future<List<PostDetailOrder>> getPostOrder(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId');
      return (response.data['orders'] as List)
          .map((e) => PostDetailOrder.fromJson(e))
          .toList();
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }
}

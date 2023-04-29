import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';
import '../models/post_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    const staticUrl = '/delivery/order';

    return OrderRepository(dio, staticUrl);
  },
);

class OrderRepository {
  OrderRepository(this._dio, this.staticUrl);

  final String staticUrl;
  final Dio _dio;

  Future<Order> getMyPostOrder(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId/me');
      return Order.fromJson(response.data);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future<List<Order>> getPostOrder(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId');
      return (response.data['orders'] as List)
          .map((e) => Order.fromJson(e))
          .toList();
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future postOrder(String postId, Order order) async {
    try {
      await _dio.post('$staticUrl/$postId', data: order.toJson());
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }
}

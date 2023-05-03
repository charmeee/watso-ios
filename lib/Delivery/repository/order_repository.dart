import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';
import '../models/post_model.dart';

final orderRepositoryProvider =
    Provider.autoDispose.family<OrderRepository, String>(
  (ref, postId) {
    final dio = ref.watch(dioProvider);

    final staticUrl = '/delivery/post/$postId/orders';

    return OrderRepository(dio, staticUrl);
  },
);

class OrderRepository {
  OrderRepository(this._dio, this.staticUrl);

  final String staticUrl;
  final Dio _dio;

  Future<Order> getMyPostOrder() async {
    try {
      final response = await _dio.get('$staticUrl/me');
      return Order.fromJson(response.data['order']);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future<List<Order>> getPostOrder() async {
    try {
      final response = await _dio.get(staticUrl);
      return (response.data['orders'] as List)
          .map((e) => Order.fromJson(e))
          .toList();
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future postOrder(Order order) async {
    try {
      await _dio.post(staticUrl, data: order.toJson());
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }
}

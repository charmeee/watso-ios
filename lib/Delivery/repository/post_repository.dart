import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';
import '../models/post_model.dart';
import '../models/post_request_model.dart';
import '../models/post_response_model.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    const staticUrl = '/api/delivery/post';

    return PostRepository(dio, staticUrl);
  },
);

class PostRepository {
  PostRepository(this._dio, this.staticUrl);

  final String staticUrl;
  final Dio _dio;

  Future<List<ResponsePost>> getDeliveryList(PostFilter filter) async {
    try {
      final response = await _dio.get(staticUrl, queryParameters: {
        'option': filter.name,
      });
      return (response.data as List)
          .map((e) => ResponsePost.fromJson(e))
          .toList();
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }

  Future postDelivery(PostOrder postOrder) async {
    try {
      final response =
          await _dio.post(staticUrl, data: postOrder.newPostToJson());
      return response.data;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }

  Future<ResponsePost> getPostDetail(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId');
      return ResponsePost.fromJson(response.data);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }

  Future updatePostStatus(String postId, bool recruitment, bool orderCompleted,
      bool orderConfirmed) async {
    try {
      await _dio.patch('$staticUrl/$postId/status', data: {
        'recruitment': recruitment,
        'order_completed': orderCompleted,
        'order_confirmed': orderConfirmed,
      });
      return true;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e) {
      throw DataParsingException(e.toString());
    }
  }
}

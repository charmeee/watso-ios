import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../../Common/failures.dart';
import '../models/comment_model.dart';
import '../models/post_filter_model.dart';
import '../models/post_model.dart';
import '../models/post_request_model.dart';
import '../models/post_response_model.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    const staticUrl = '/delivery/post';

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
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future postDelivery(PostOrder postOrder) async {
    try {
      final response =
          await _dio.post(staticUrl, data: postOrder.newPostToJson());
      return response.data;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future<ResponsePost> getPostDetail(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId');
      return ResponsePost.fromJson(response.data);
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //게시글 수정
  Future updatePost(String postId, Map editableData) async {
    try {
      await _dio.patch('$staticUrl/$postId', data: editableData);
      return true;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  Future updatePostStatus(String postId, PostStatus status) async {
    try {
      await _dio.patch('$staticUrl/$postId/status', data: {
        'status': status.name,
      });
      return true;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //게시글 삭제
  Future deletePost(String postId) async {
    try {
      await _dio.delete('$staticUrl/$postId');
      return;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //게시글 댓글 가져오기
  Future<List<Comment>> getCommentList(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId/comments');
      return (response.data['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList();
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //게시글 댓글 작성
  Future postComment(String postId, String comment) async {
    try {
      await _dio.post('$staticUrl/$postId/comments', data: {
        'content': comment,
      });
      return;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //게시글 대댓글 작성
  Future postChildComment(
      String postId, String parentId, String comment) async {
    try {
      await _dio.post('$staticUrl/$postId/comments/$parentId', data: {
        'content': comment,
      });
      return;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //댓글 수정
  Future updateComment(String postId, String commentId, String comment) async {
    try {
      await _dio.patch('$staticUrl/$postId/comments/$commentId', data: {
        'content': comment,
      });
      return;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //댓글 삭제
  Future deleteComment(String postId, String commentId) async {
    try {
      await _dio.delete('$staticUrl/$postId/comments/$commentId');
      return;
    } on DioError catch (e) {
      throw ServerException(e);
    } catch (e, s) {
      throw DataParsingException(e, s);
    }
  }

  //게시글 배달비 수정
  Future updateDeliveryFee(String postId, int deliveryFee) async {
    try {
      await _dio.patch('$staticUrl/$postId/fee', data: {
        'fee': deliveryFee,
      });
      return;
    } on DioError catch (e) {
      throw ServerException(e);
    }
  }

  //대표 계좌번호 확인
  Future<String> getAccountNumber(String postId) async {
    try {
      final response = await _dio.get('$staticUrl/$postId/account-number');
      return response.data['account_number'];
    } on DioError catch (e) {
      throw ServerException(e);
    }
  }
}

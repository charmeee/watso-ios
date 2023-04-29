import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Delivery/models/comment_model.dart';
import 'package:sangsangtalk/Delivery/repository/post_repository.dart';

import '../models/post_model.dart';
import '../models/post_response_model.dart';

final myPostListProvider = FutureProvider<List<ResponsePost>>((ref) async {
  return await ref
      .read(postRepositoryProvider)
      .getDeliveryList(PostFilter.joined);
});

final postDetailProvider = FutureProvider.autoDispose
    .family<ResponsePost, String>((ref, postId) async {
  return await ref.read(postRepositoryProvider).getPostDetail(postId);
});

final postCommentListProvider = FutureProvider.autoDispose
    .family<List<ParentComment>, String>((ref, postId) async {
  return await ref.read(postRepositoryProvider).getCommentList(postId);
});

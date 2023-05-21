import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Delivery/models/comment_model.dart';
import 'package:watso/Delivery/repository/post_repository.dart';

import '../models/post_filter_model.dart';
import '../models/post_response_model.dart';

const List<String> filterPlace = <String>['모두', '생자대', '기숙사'];

final myPostListProvider = FutureProvider<List<ResponsePost>>((ref) async {
  return await ref
      .read(postRepositoryProvider)
      .getDeliveryList(PostFilter.joined);
});

final joinablePostListProvider =
    FutureProvider<List<ResponsePost>>((ref) async {
  PostPlaceFilter filter = ref.watch(joinablePostFilterProvider);
  List<ResponsePost> list = await ref
      .read(postRepositoryProvider)
      .getDeliveryList(PostFilter.joinable);
  if (filter == PostPlaceFilter.all) {
    return list;
  }
  return list.where((element) => element.place == filter.korName).toList();
});

final joinablePostFilterProvider = StateProvider<PostPlaceFilter>((ref) {
  return PostPlaceFilter.all;
});

final postDetailProvider = FutureProvider.autoDispose
    .family<ResponsePost, String>((ref, postId) async {
  return await ref.read(postRepositoryProvider).getPostDetail(postId);
});

final postCommentListProvider = FutureProvider.autoDispose
    .family<List<Comment>, String>((ref, postId) async {
  return await ref.read(postRepositoryProvider).getCommentList(postId);
});

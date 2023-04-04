import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Delivery/repository/postOrder_repository.dart';

import 'models/post_model.dart';
import 'models/post_response_model.dart';

final myPostListProvider = FutureProvider<List<ResponsePostList>>((ref) async {
  return await ref
      .read(postOrderRepositoryProvider)
      .getDeliveryList(PostFilter.joined);
});

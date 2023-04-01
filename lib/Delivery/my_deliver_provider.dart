import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/post_request_model.dart';

final postOrderNotifierProvider =
StateNotifierProvider<PostOrderNotifier, PostOrder>((ref) {
  return PostOrderNotifier(ref);
});

class PostOrderNotifier extends StateNotifier<PostOrder> {
  PostOrderNotifier(this.ref) : super(PostOrder.init());

  final Ref ref;

  deleteMyDeliver() {
    state = PostOrder.init();
  }

  setMyDeliverOption(
      {String? place, DateTime? orderTime, int? minMember, int? maxMember}) {
    state = PostOrder(
        orders: state.orders,
        storeId: state.storeId,
        place: place ?? state.place,
        orderTime: orderTime ?? state.orderTime,
        minMember: minMember ?? state.minMember,
        maxMember: maxMember ?? state.maxMember);
  }

  setMyDeliverStore(storeId) {
    state = PostOrder(
      orders: state.orders,
      storeId: storeId,
      place: state.place,
      orderTime: state.orderTime,
      minMember: state.minMember,
      maxMember: state.maxMember,
    );
  }
}


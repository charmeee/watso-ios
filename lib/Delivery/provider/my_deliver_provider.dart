import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../models/post_request_model.dart';

final myDeliveryNotifierProvider =
StateNotifierProvider<MyDeliveryNotifier, PostOrder>((ref) {
  return MyDeliveryNotifier(ref);
});

class MyDeliveryNotifier extends StateNotifier<PostOrder> {
  MyDeliveryNotifier(this.ref) : super(PostOrder.init());

  final Ref ref;

  deleteMyDeliver() {
    state = PostOrder.init();
  }

  setMyDeliverOption({String? place,
    DateTime? orderTime,
    int? minMember,
    int? maxMember,
    String? postId}) {
    state = PostOrder(
        orders: state.orders,
        store: state.store,
        place: place ?? state.place,
        orderTime: orderTime ?? state.orderTime,
        minMember: minMember ?? state.minMember,
        maxMember: maxMember ?? state.maxMember,
        postId: postId);
  }

  setMyDeliverStore(Store store) {
    state = PostOrder(
      orders: state.orders,
      store: store,
      place: state.place,
      orderTime: state.orderTime,
      minMember: state.minMember,
      maxMember: state.maxMember,
      postId: state.postId,
    );
  }

  addMyDeliverOrder(OrderMenu order) {
    state = PostOrder(
      orders: [...state.orders, order],
      store: state.store,
      place: state.place,
      orderTime: state.orderTime,
      minMember: state.minMember,
      maxMember: state.maxMember,
      postId: state.postId,
    );

    log('addMyDeliverOrder: ${state.orders.length}');
  }

  deleteMyDeliverOrder(int index) {
    state = PostOrder(
      orders: [...state.orders]..removeAt(index),
      store: state.store,
      place: state.place,
      orderTime: state.orderTime,
      minMember: state.minMember,
      maxMember: state.maxMember,
      postId: state.postId,
    );
    log('deleteMyDeliverOrder: ${state.orders.length}');
  }

  void decreaseQuantity(int index) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.orders[index].quantity--;
    state = tmp;
  }

  void increaseQuantity(index) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.orders[index].quantity++;
    state = tmp;
  }
}

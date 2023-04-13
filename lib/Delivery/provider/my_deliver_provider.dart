import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../models/post_request_model.dart';

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
        store: state.store,
        place: place ?? state.place,
        orderTime: orderTime ?? state.orderTime,
        minMember: minMember ?? state.minMember,
        maxMember: maxMember ?? state.maxMember);
  }

  setMyDeliverStore(Store store) {
    state = PostOrder(
      orders: state.orders,
      store: store,
      place: state.place,
      orderTime: state.orderTime,
      minMember: state.minMember,
      maxMember: state.maxMember,
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

final sumPriceByOrderProvider = Provider<List<int>>((ref) {
  final orderMenus = ref.watch(postOrderNotifierProvider).orders;
  List<int> sum = [];
  for (var orderMenu in orderMenus) {
    var orderSum = orderMenu.menu.price * orderMenu.quantity;
    if (orderMenu.menu.groups == null) {
      continue;
    }
    for (var group in orderMenu.menu.groups!) {
      for (var option in group.options) {
        orderSum += option.price * orderMenu.quantity;
      }
    }
    sum.add(orderSum);
  }
  return sum;
});

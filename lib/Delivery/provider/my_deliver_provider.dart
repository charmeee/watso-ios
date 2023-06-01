import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Auth/models/user_model.dart';

import '../../Auth/provider/user_provider.dart';
import '../models/post_model.dart';
import '../models/post_request_model.dart';
import 'order_option_provider.dart';

//order stateprovider과
//PostOption stateprovider을 합친것.
final myDeliveryNotifierProvider =
    StateNotifierProvider.autoDispose<MyDeliveryNotifier, PostOrder>((ref) {
  UserInfo? user = ref.watch(userNotifierProvider);
  OrderOption option = ref.watch(orderOptionNotifierProvider);
  if (user == null) {
    throw Exception('user is null');
  }
  return MyDeliveryNotifier(ref, user: user, option: option);
});

class MyDeliveryNotifier extends StateNotifier<PostOrder> {
  MyDeliveryNotifier(this.ref, {required this.user, required this.option})
      : super(PostOrder(
          order: Order.init(user),
          orderOption: option,
        ));
  final OrderOption option;
  final UserInfo user;
  final Ref ref;

  addMyDeliverOrder(OrderMenu order) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.order.orderLines.add(order);
    state = tmp;

    log('addMyDeliverOrder: ${state.order.orderLines.length}');
  }

  deleteMyDeliverOrder(int index) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.order.orderLines.removeAt(index);
    state = tmp;
    log('deleteMyDeliverOrder: ${state.order.orderLines.length}');
  }

  void decreaseQuantity(int index) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.order.orderLines[index].quantity--;
    state = tmp;
  }

  void increaseQuantity(index) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.order.orderLines[index].quantity++;
    state = tmp;
  }

  setRequest(String request) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.order.requestComment = request;
    state = tmp;
  }
}

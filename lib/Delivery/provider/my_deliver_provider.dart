import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Auth/models/user_model.dart';

import '../../Auth/provider/user_provider.dart';
import '../models/post_model.dart';
import '../models/post_request_model.dart';
import '../models/post_response_model.dart';

//order stateprovider과
//PostOption stateprovider을 합친것.
final myDeliveryNotifierProvider =
    StateNotifierProvider.autoDispose<MyDeliveryNotifier, PostOrder>((ref) {
  UserInfo? user = ref.watch(userNotifierProvider);
  if (user == null) {
    throw Exception('user is null');
  }
  return MyDeliveryNotifier(ref, user: user);
});

class MyDeliveryNotifier extends StateNotifier<PostOrder> {
  MyDeliveryNotifier(this.ref, {required this.user})
      : super(PostOrder.init(user));
  final UserInfo user;
  final Ref ref;

  deleteMyDeliver() {
    state = PostOrder.init(user);
  }

  setMyDeliverOption({
    String? place,
    DateTime? orderTime,
    int? minMember,
    int? maxMember,
    String? postId,
  }) {
    state = PostOrder(
        order: state.order,
        store: state.store,
        place: place ?? state.place,
        orderTime: orderTime ?? state.orderTime,
        minMember: minMember ?? state.minMember,
        maxMember: maxMember ?? state.maxMember,
        postId: postId ?? state.postId);

    log('setMyDeliverOption: ${state.newPostToJson()}');
  }

  setMyDeliverStore(Store store) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.store = store;
    state = tmp;
  }

  setMyDeliverByPost(ResponsePost data) {
    PostOrder tmp = PostOrder.clone(state);
    tmp.place = data.place;
    tmp.orderTime = data.orderTime;
    tmp.minMember = data.minMember;
    tmp.maxMember = data.maxMember;
    tmp.postId = data.id;
    tmp.store = data.store;
    state = tmp;
  }

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

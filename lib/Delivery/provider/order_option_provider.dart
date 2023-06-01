import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Delivery/models/post_model.dart';

final orderOptionNotifierProvider =
    StateNotifierProvider.autoDispose<OrderOptionNotifier, OrderOption>((ref) {
  return OrderOptionNotifier(ref);
});

class OrderOptionNotifier extends StateNotifier<OrderOption> {
  OrderOptionNotifier(this.ref) : super(OrderOption.init());
  final Ref ref;

  setPartOfOption({
    String? place,
    DateTime? orderTime,
    int? minMember,
    int? maxMember,
    String? postId,
    Store? store,
  }) {
    state = OrderOption(
        place: place ?? state.place,
        orderTime: orderTime ?? state.orderTime,
        minMember: minMember ?? state.minMember,
        maxMember: maxMember ?? state.maxMember,
        postId: postId ?? state.postId,
        store: store ?? state.store);
  }

  setOption(OrderOption option) {
    state = option;
  }
}

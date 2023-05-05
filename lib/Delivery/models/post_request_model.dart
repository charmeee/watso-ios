import 'package:intl/intl.dart';
import 'package:sangsangtalk/Delivery/models/post_model.dart';

import '../../Auth/models/user_model.dart';

//post /post
class PostOrder extends PostOption {
  Order order;
  Store store;
  String? postId;

  PostOrder(
      {required this.order,
      required this.store,
      required String place,
      required DateTime orderTime,
      required int minMember,
      required int maxMember,
      this.postId})
      : super(
            place: place,
            orderTime: orderTime,
            minMember: minMember,
            maxMember: maxMember);

  PostOrder.fromJson(Map<String, dynamic> json)
      : order = Order.fromJson(json['order']),
        store = Store.fromJson(json['store']),
        super.fromJson(json);

  factory PostOrder.init(User user) {
    return PostOrder(
        order: Order.init(user),
        store: Store.init(),
        place: '생자대',
        orderTime: DateTime.now(),
        minMember: 1,
        maxMember: 999);
  }

  PostOrder.clone(PostOrder postOrder)
      : order = Order.clone(postOrder.order),
        store = Store.clone(postOrder.store),
        postId = postOrder.postId,
        super.clone(postOrder);

  Map newPostToJson() => {
        'order': order.toJson(),
        'store_id': store.id,
        'place': place,
        'order_time': DateFormat('YY-mm-ddTHH:MM:SS').format(orderTime),
        'min_member': minMember,
        'max_member': maxMember,
        if (postId != null) 'post_id': postId
      };

  bool get isStoreSelected => store.id.isNotEmpty;

  bool get isMemberLogical => minMember <= maxMember;

  bool get isOrderTimeLogical =>
      orderTime.isAfter(DateTime.now().add(Duration(minutes: 10)));

  bool get disableToPost =>
      order.orderLines.isEmpty ||
      store.id.isEmpty ||
      place.isEmpty ||
      orderTime.isBefore(DateTime.now()) ||
      minMember > maxMember;

  bool get checkOrderTime => orderTime.isAfter(DateTime.now());
}

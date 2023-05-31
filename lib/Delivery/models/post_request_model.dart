import 'package:intl/intl.dart';
import 'package:watso/Delivery/models/post_model.dart';
import 'package:watso/Delivery/models/post_response_model.dart';

import '../../Auth/models/user_model.dart';

//post /post
class PostOrder extends OrderOption {
  Order order;

  PostOrder({
    required this.order,
    required String place,
    required DateTime orderTime,
    required int minMember,
    required int maxMember,
    required Store store,
    String? postId,
  }) : super(
          place: place,
          orderTime: orderTime,
          minMember: minMember,
          maxMember: maxMember,
          store: store,
          postId: postId,
        );

  PostOrder.fromJson(Map<String, dynamic> json)
      : order = Order.fromJson(json['order']),
        super.fromJson(json);

  factory PostOrder.init(User user) {
    DateTime nowDate = DateTime.now();
    DateTime dateTime = DateTime(nowDate.year, nowDate.month, nowDate.day,
        nowDate.hour, nowDate.minute - nowDate.minute % 10 + 30);

    return PostOrder(
        order: Order.init(user),
        store: Store.init(),
        place: '생자대',
        orderTime: dateTime,
        minMember: 2,
        maxMember: 4);
  }

  PostOrder.clone(PostOrder postOrder)
      : order = Order.clone(postOrder.order),
        super.clone(postOrder);

  Map newPostToJson() => {
        'order': order.toJson(),
        'store_id': store.id,
        'place': place,
        'order_time': DateFormat('yyyy-MM-ddTHH:mm:ss').format(orderTime),
        'min_member': minMember,
        'max_member': maxMember,
        if (postId != null) 'post_id': postId
      };

  factory PostOrder.fromResponsePost(ResponsePost responsePost) {
    return PostOrder(
        order: Order.init(
            User(id: responsePost.userId, nickname: responsePost.nickname)),
        store: Store.clone(responsePost.store),
        place: responsePost.place,
        orderTime: responsePost.orderTime,
        minMember: responsePost.minMember,
        maxMember: responsePost.maxMember,
        postId: responsePost.id);
  }

  get editableInfo => {
        'order_time': DateFormat('yyyy-MM-ddTHH:mm:ss').format(orderTime),
        'place': place,
        'min_member': minMember,
        'max_member': maxMember,
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

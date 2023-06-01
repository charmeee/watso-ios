import 'package:intl/intl.dart';
import 'package:watso/Delivery/models/post_model.dart';

//post /post
class PostOrder {
  Order order;
  OrderOption orderOption;

  PostOrder({required this.order, required this.orderOption}) : super();

  PostOrder.fromJson(Map<String, dynamic> json)
      : order = Order.fromJson(json['order']),
        orderOption = OrderOption.fromJson(json);

  PostOrder.clone(PostOrder postOrder)
      : order = Order.clone(postOrder.order),
        orderOption = OrderOption.clone(postOrder.orderOption);

  Map newPostToJson() => {
        'order': order.toJson(),
        'store_id': orderOption.store.id,
        'place': orderOption.place,
        'order_time':
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(orderOption.orderTime),
        'min_member': orderOption.minMember,
        'max_member': orderOption.maxMember,
        if (orderOption.postId != null) 'post_id': orderOption.postId,
      };

  bool get isAbleToPost =>
      order.orderLines.isNotEmpty &&
      orderOption.isMemberLogical &&
      orderOption.isStoreSelected &&
      orderOption.isOrderTimeLogical &&
      orderOption.isPlaceSelected;
}

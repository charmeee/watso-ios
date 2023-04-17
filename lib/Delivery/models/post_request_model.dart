import 'package:sangsangtalk/Delivery/models/post_model.dart';

//post /post
class PostOrder extends PostOption {
  List<OrderMenu> orders;
  Store store;
  String? postId;

  PostOrder(
      {required this.orders,
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
      : orders = List<OrderMenu>.from(
            json['orders'].map((x) => OrderMenu.fromJson(x))),
        store = Store.fromJson(json['store']),
        super.fromJson(json);

  factory PostOrder.init() {
    return PostOrder(
        orders: [],
        store: Store.init(),
        place: '생자대',
        orderTime: DateTime.now(),
        minMember: 1,
        maxMember: 999);
  }

  factory PostOrder.clone(PostOrder postOrder) {
    return PostOrder(
        orders: postOrder.orders.map((e) => OrderMenu.clone(e)).toList(),
        store: postOrder.store,
        place: postOrder.place,
        orderTime: postOrder.orderTime,
        minMember: postOrder.minMember,
        maxMember: postOrder.maxMember,
        postId: postOrder.postId);
  }

  Map newPostToJson() => {
        'order_lines': orders.map((e) => e.toJson()).toList(),
        'store_id': store.id,
        'place': place,
        'order_time': orderTime.toIso8601String(),
        'min_member': minMember,
        'max_member': maxMember,
      };

  bool get isStoreSelected => store.id.isNotEmpty;

  bool get isMemberLogical => minMember <= maxMember;

  bool get isOrderTimeLogical =>
      orderTime.isAfter(DateTime.now().add(Duration(minutes: 10)));

  bool get disableToPost =>
      orders.isEmpty ||
      store.id.isEmpty ||
      place.isEmpty ||
      orderTime.isBefore(DateTime.now()) ||
      minMember > maxMember;

  bool get checkOrderTime => orderTime.isBefore(DateTime.now());
}

import 'package:sangsangtalk/Delivery/models/post_model.dart';

//post /post
class PostOrder extends PostOption {
  List<OrderMenu> orders;
  String storeId;

  PostOrder(
      {required this.orders,
      required this.storeId,
      required String place,
      required DateTime orderTime,
      required int minMember,
      required int maxMember})
      : super(
            place: place,
            orderTime: orderTime,
            minMember: minMember,
            maxMember: maxMember);

  PostOrder.fromJson(Map<String, dynamic> json)
      : orders = List<OrderMenu>.from(
            json['orders'].map((x) => OrderMenu.fromJson(x))),
        storeId = json['store_id'],
        super.fromJson(json);

  factory PostOrder.init() {
    return PostOrder(
        orders: [],
        storeId: '',
        place: '생자대',
        orderTime: DateTime.now(),
        minMember: 0,
        maxMember: 999);
  }

  bool get isStoreSelected => storeId.isNotEmpty;

  bool get isMemberLogical => minMember <= maxMember;

  bool get isOrderTimeLogical =>
      orderTime.isAfter(DateTime.now().add(Duration(minutes: 10)));

  bool get canNotOrder =>
      orders.isEmpty ||
      storeId.isEmpty ||
      place.isEmpty ||
      orderTime.isBefore(DateTime.now()) ||
      minMember > maxMember;
}

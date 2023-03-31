import 'package:sangsangtalk/Delivery/models/post_model.dart';

import '../../Auth/models/user_model.dart';

//get /post
class ResponsePostList extends PostOption {
  String id;
  String title;
  String userId;
  String nickname;
  Store store;
  bool open;
  bool orderCompleted;
  List<User> userOrders;

  ResponsePostList(
      {required this.id,
      required this.title,
      required this.userId,
      required this.nickname,
      required place,
      required minMember,
      required maxMember,
      required orderTime,
      required this.store,
      required this.open,
      required this.orderCompleted,
      required this.userOrders})
      : super(
          place: place,
          minMember: minMember,
          maxMember: maxMember,
          orderTime: orderTime,
        );

  ResponsePostList.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        userId = json['user_id'].toString(),
        nickname = json['nickname'],
        store = Store.fromJson(json['store']),
        open = json['open'],
        orderCompleted = json['order_completed'],
        userOrders =
            List<User>.from(json['user_orders'].map((x) => User.fromJson(x))),
        super.fromJson(json);
}

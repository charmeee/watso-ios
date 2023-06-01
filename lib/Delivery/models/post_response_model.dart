import 'package:watso/Delivery/models/post_model.dart';

//get /post
class ResponsePost {
  String id;
  String userId;
  String nickname;
  int fee;
  PostStatus status;
  List<String> users;
  OrderOption orderOption;

  ResponsePost(
      {required this.id,
      required this.userId,
      required this.nickname,
      required this.fee,
      required this.orderOption,
      required this.status,
      required this.users})
      : super();

  ResponsePost.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        userId = json['user_id'].toString(),
        nickname = json['nickname'],
        fee = json['fee'],
        status = PostStatus.values.byName(json['status']),
        users = List<String>.from(json['users'].map((x) => x.toString())),
        orderOption = OrderOption.fromJson(json);

  toMap() => {
        'id': id,
        'userId': userId,
        'nickname': nickname,
        'fee': fee,
        'status': status,
        'users': users,
        'orderOption': orderOption.toMap(),
      };
}

class StoreMenus extends Store {
  List<MenuSection> menuSection;

  StoreMenus(
      {required String id,
      required String name,
      required int minOrder,
      required int fee,
      required String phoneNumber,
      required String logoImgUrl,
      required List<String> note,
      required this.menuSection})
      : super(
            id: id,
            name: name,
            minOrder: minOrder,
            fee: fee,
            phoneNumber: phoneNumber,
            logoImgUrl: logoImgUrl,
            note: note);

  StoreMenus.fromJson(Map<String, dynamic> json)
      : menuSection = List<MenuSection>.from(
            json['sections'].map((x) => MenuSection.fromJson(x))),
        super.fromJson(json);
}

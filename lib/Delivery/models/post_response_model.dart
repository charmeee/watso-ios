import 'package:watso/Delivery/models/post_model.dart';

//get /post
class ResponsePost extends OrderOption {
  String id;
  String userId;
  String nickname;
  int fee;
  PostStatus status;
  List<String> users;

  ResponsePost(
      {required this.id,
      required this.userId,
      required this.nickname,
      required this.fee,
      required place,
      required minMember,
      required maxMember,
      required orderTime,
      required store,
      required this.status,
      required this.users})
      : super(
            place: place,
            minMember: minMember,
            maxMember: maxMember,
            orderTime: orderTime,
            store: store);

  ResponsePost.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        userId = json['user_id'].toString(),
        nickname = json['nickname'],
        fee = json['fee'],
        status = PostStatus.values.byName(json['status']),
        users = List<String>.from(json['users'].map((x) => x.toString())),
        super.fromJson(json);
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

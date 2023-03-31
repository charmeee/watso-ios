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

// {
// "_id": "6345a45f1c32cd7c4b64d895",
// "name": "맘스터치",
// "min_order": 12000,
// "fee": 3000,
// "menus": [
// {
// "section": "세트메뉴",
// "name": "딥치즈버거",
// "price": 6800
// }
// ]
// }

class StoreMenuList extends Store {
  List<MenuSection> menuSection;

  StoreMenuList(
      {required String id,
      required String name,
      required int minOrder,
      required int fee,
      required this.menuSection})
      : super(id: id, name: name, minOrder: minOrder, fee: fee);

  StoreMenuList.fromJson(Map<String, dynamic> json)
      : menuSection = List<MenuSection>.from(
            json['menus'].map((x) => MenuSection.fromJson(x))),
        super.fromJson(json);

  //get menu by section
  List<Menu> getMenuBySection(String section) {
    List<Menu> menuList = [];
    for (MenuSection menuSection in this.menuSection) {
      if (menuSection.section == section) {
        menuList.add(Menu(name: menuSection.name, price: menuSection.price));
      }
    }
    return menuList;
  }

  List<String> get sections {
    List<String> sections = [];
    for (MenuSection menuSection in this.menuSection) {
      if (!sections.contains(menuSection.section)) {
        sections.add(menuSection.section);
      }
    }
    return sections;
  }
}

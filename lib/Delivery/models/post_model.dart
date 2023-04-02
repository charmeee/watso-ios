enum PostFilter { all, joinable, joined }

class Store {
  String id;
  String name;
  int minOrder;
  int fee;

  Store({required this.id,
    required this.name,
    required this.minOrder,
    required this.fee});

  Store.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        minOrder = json['min_order'],
        fee = json['fee'];
}

class PostOption {
  String place;
  DateTime orderTime;
  int minMember;
  int maxMember;

  PostOption({required this.place,
    required this.orderTime,
    required this.minMember,
    required this.maxMember});

  PostOption.fromJson(Map<String, dynamic> json)
      : place = json['place'],
        orderTime = DateTime.parse(json['order_time']),
        minMember = json['min_member'],
        maxMember = json['max_member'];
}

class Order {
  String id;
  int quantity;
  int price;
  Menu menu;

  Order({required this.id,
    required this.quantity,
    required this.price,
    required this.menu});

  Order.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        quantity = json['quantity'],
        price = json['price'],
        menu = Menu.fromJson(json['menu']);
}

class Menu {
  String name;
  int price;
  List<MenuOptionGroup>? groups;

  Menu({required this.name, required this.price, this.groups});

  Menu.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        groups = json['groups'] != null
            ? List<MenuOptionGroup>.from(
            json['groups'].map((x) => MenuOptionGroup.fromJson(x)))
            : null;
}

class MenuSection extends Menu {
  String section;

  MenuSection({required this.section,
    required String name,
    required int price,
    List<MenuOptionGroup>? groups})
      : super(name: name, price: price);

  MenuSection.fromJson(Map<String, dynamic> json)
      : section = json['section'],
        super.fromJson(json);
}

class MenuOptionGroup {
  String id;
  String name;
  int minOptionNum;
  int maxOptionNum;
  List<MenuOption> options;

  MenuOptionGroup({required this.id,
    required this.name,
    required this.options,
    required this.minOptionNum,
    required this.maxOptionNum});

  MenuOptionGroup.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        minOptionNum = json['min_order_quantity'],
        maxOptionNum = json['max_order_quantity'],
        options = List<MenuOption>.from(
            json['options'].map((x) => MenuOption.fromJson(x)));

}

class MenuOption {
  String id;
  String name;
  int price;

  MenuOption({
    required this.id,
    required this.name,
    required this.price,
  });

  MenuOption.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        price = json['price'];
}

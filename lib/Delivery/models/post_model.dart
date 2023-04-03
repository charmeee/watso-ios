enum PostFilter { all, joinable, joined }

class Store {
  String id;
  String name;
  int minOrder;
  int fee;

  Store(
      {required this.id,
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

  PostOption(
      {required this.place,
      required this.orderTime,
      required this.minMember,
      required this.maxMember});

  PostOption.fromJson(Map<String, dynamic> json)
      : place = json['place'],
        orderTime = DateTime.parse(json['order_time']),
        minMember = json['min_member'],
        maxMember = json['max_member'];
}

class OrderMenu {
  int quantity;
  Menu menu;

  OrderMenu({required this.quantity, required this.menu});

  OrderMenu.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        menu = Menu.fromJson(json['menu']);

  OrderMenu.fromMenu({required this.quantity, required this.menu});

  factory OrderMenu.clone(OrderMenu orderMenu) {
    return OrderMenu(
      quantity: orderMenu.quantity,
      menu: Menu.clone(orderMenu.menu),
    );
  }

  Map toJson() => {
        'quantity': quantity,
        'menu': menu.toJson(),
      };
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

  factory Menu.clone(Menu menu) {
    return Menu(
      name: menu.name,
      price: menu.price,
      groups: menu.groups != null
          ? menu.groups!.map((e) => MenuOptionGroup.clone(e)).toList()
          : null,
    );
  }

  Map toJson() => {
        'name': name,
        'price': price,
        'groups':
            groups != null ? groups!.map((e) => e.toJson()).toList() : null,
      };
}

class MenuSection extends Menu {
  String section;

  MenuSection({
    required this.section,
    required String name,
    required int price,
  }) : super(name: name, price: price);

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

  MenuOptionGroup(
      {required this.id,
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

  factory MenuOptionGroup.clone(MenuOptionGroup menuOptionGroup) {
    return MenuOptionGroup(
      id: menuOptionGroup.id,
      name: menuOptionGroup.name,
      minOptionNum: menuOptionGroup.minOptionNum,
      maxOptionNum: menuOptionGroup.maxOptionNum,
      options: menuOptionGroup.options.map((e) => MenuOption.clone(e)).toList(),
    );
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'minOptionNum': minOptionNum,
        'maxOptionNum': maxOptionNum,
        'options': options.map((e) => e.toJson()).toList(),
      };
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

  factory MenuOption.clone(MenuOption menuOption) {
    return MenuOption(
      id: menuOption.id,
      name: menuOption.name,
      price: menuOption.price,
    );
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'price': price,
      };
}

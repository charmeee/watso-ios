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

  Store.init()
      : id = '',
        name = '',
        minOrder = 1,
        fee = 0;

  Store.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        minOrder = int.tryParse(json['min_order'].toString()) ?? 0,
        fee = int.tryParse(json['fee'].toString()) ?? 0;
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
  String id;
  String name;
  int price;
  List<MenuOptionGroup>? groups;

  Menu(
      {required this.id, required this.name, required this.price, this.groups});

  Menu.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        price = int.tryParse(json['price'].toString()) ?? 0,
        groups = json['groups'] != null
            ? List<MenuOptionGroup>.from(
                json['groups'].map((x) => MenuOptionGroup.fromJson(x)))
            : null;

  factory Menu.clone(Menu menu) {
    return Menu(
      id: menu.id,
      name: menu.name,
      price: menu.price,
      groups: menu.groups != null
          ? menu.groups!.map((e) => MenuOptionGroup.clone(e)).toList()
          : [],
    );
  }

  Map toJson() => {
        '_id': id,
        'price': price,
        'name': name,
        'groups':
            groups != null ? groups!.map((e) => e.toJson()).toList() : null,
      };
}

class MenuSection {
  String section;
  List<Menu> menus;

  MenuSection({required this.section, required this.menus});

  MenuSection.fromJson(Map<String, dynamic> json)
      : section = json['section_name'].toString(),
        menus = List<Menu>.from(json['menus'].map((x) => Menu.fromJson(x)));
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
        '_id': id,
        'name': name,
        'min_order_quantity': minOptionNum,
        'max_order_quantity': maxOptionNum,
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
        '_id': id,
        'name': name,
        'price': price,
      };
}

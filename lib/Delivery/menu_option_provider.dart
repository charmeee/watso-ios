import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/post_model.dart';
import 'my_deliver_provider.dart';
import 'repository/store_repository.dart';

final menuOptionNotifierProvider =
    StateNotifierProvider<MenuOptionNotifier, OrderMenu?>((ref) {
  return MenuOptionNotifier(ref);
});

class MenuOptionNotifier extends StateNotifier<OrderMenu?> {
  MenuOptionNotifier(this.ref) : super(null);

  final Ref ref;

  Future<Menu> setMenu(storeId, menuName) async {
    try {
      final Menu value = await ref
          .read(storeRepositoryProvider)
          .getDetailMenu(storeId, menuName);

      state = OrderMenu.fromMenu(quantity: 1, menu: Menu.clone(value));
      if (state!.menu.groups != null && state!.menu.groups!.isNotEmpty) {
        setLeastOneOption();
      }
      return value;
    } catch (e) {
      log("setMenu" + e.toString());
      throw Exception(e);
    }
  }

  setLeastOneOption() {
    final tmp = OrderMenu.clone(state!);
    for (var element in tmp.menu.groups!) {
      if (element.minOptionNum > 0) {
        final option = element.options[0];
        element.options = [option];
      } else {
        element.options = [];
      }
    }
    log('state: ${state!.menu.groups![0].options[0].name}');
    state = tmp;
  }

  void decreaseQuantity() {
    final tmp = OrderMenu.clone(state!);
    if (tmp.quantity == 1) return;
    tmp.quantity--;
    state = tmp;
  }

  void increaseQuantity() {
    final tmp = OrderMenu.clone(state!);
    tmp.quantity++;
    state = tmp;
  }

  setOption(bool isRadio, String optionGroupId, MenuOption option) {
    final tmp = OrderMenu.clone(state!);
    if (isRadio) {
      tmp.menu.groups!
          .firstWhere((element) => element.id == optionGroupId)
          .options = [option];
    } else {
      for (var i = 0; i < tmp.menu.groups!.length; i++) {
        if (tmp.menu.groups![i].id == optionGroupId) {
          for (var j = 0; j < tmp.menu.groups![i].options.length; j++) {
            if (tmp.menu.groups![i].options[j].id == option.id) {
              tmp.menu.groups![i].options.removeAt(j);
              state = tmp;
              return;
            }
          }
          tmp.menu.groups![i].options.add(option);
          state = tmp;
          return;
        }
      }
    }
    state = tmp;
  }

  addInMyOrder() {
    final tmp = OrderMenu.clone(state!);
    ref.read(postOrderNotifierProvider.notifier).addMyDeliverOrder(tmp);
    state = null;
  }
}

final sumPriceProvider = Provider<int>((ref) {
  final orderMenu = ref.watch(menuOptionNotifierProvider);
  if (orderMenu == null) {
    return 0;
  }
  var sum = 0;
  sum += orderMenu.menu.price * orderMenu.quantity;
  for (var element in orderMenu.menu.groups!) {
    for (var option in element.options) {
      sum += option.price;
    }
  }
  return sum;
});

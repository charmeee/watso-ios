import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import 'my_deliver_provider.dart';

final menuOptionNotifierProvider =
    StateNotifierProvider<MenuOptionNotifier, OrderMenu?>((ref) {
  return MenuOptionNotifier(ref);
});

class MenuOptionNotifier extends StateNotifier<OrderMenu?> {
  MenuOptionNotifier(this.ref) : super(null);

  final Ref ref;

  setMenu(Menu menu) async {
    state = OrderMenu.fromMenu(quantity: 1, menu: Menu.clone(menu));
    if (state!.menu.optionGroups != null &&
        state!.menu.optionGroups!.isNotEmpty) {
      setLeastOneOption();
    }
  }

  setLeastOneOption() {
    final tmp = OrderMenu.clone(state!);
    for (var element in tmp.menu.optionGroups!) {
      if (element.minOptionNum > 0) {
        final option = element.options[0];
        element.options = [option];
      } else {
        element.options = [];
      }
    }
    log('state: ${state!.menu.optionGroups![0].options[0].name}');
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
      tmp.menu.optionGroups!
          .firstWhere((element) => element.id == optionGroupId)
          .options = [option];
    } else {
      for (var i = 0; i < tmp.menu.optionGroups!.length; i++) {
        if (tmp.menu.optionGroups![i].id == optionGroupId) {
          for (var j = 0; j < tmp.menu.optionGroups![i].options.length; j++) {
            if (tmp.menu.optionGroups![i].options[j].id == option.id) {
              tmp.menu.optionGroups![i].options.removeAt(j);
              state = tmp;
              return;
            }
          }
          tmp.menu.optionGroups![i].options.add(option);
          state = tmp;
          return;
        }
      }
    }
    state = tmp;
  }

  addInMyOrder() {
    final tmp = OrderMenu.clone(state!);
    ref.read(myDeliveryNotifierProvider.notifier).addMyDeliverOrder(tmp);
    state = null;
  }
}

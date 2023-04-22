import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/floating_bottom_button.dart';
import '../models/post_model.dart';
import '../provider/menu_option_provider.dart';

class MenuOptionAddBtn extends ConsumerWidget {
  const MenuOptionAddBtn({
    Key? key,
    required this.orderMenu,
  }) : super(key: key);
  final OrderMenu orderMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: customFloatingBottomButton(context,
          child: Text('${orderMenu.totalPrice}원 담기'), onPressed: () {
        ref.read(menuOptionNotifierProvider.notifier).addInMyOrder();
        Navigator.pop(context);
      }),
    );
  }
}

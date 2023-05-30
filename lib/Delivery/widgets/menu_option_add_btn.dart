import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/primary_button.dart';

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
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: primaryButton(
          text: '${orderMenu.totalPrice}원 담기',
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          onPressed: () {
            ref.read(menuOptionNotifierProvider.notifier).addInMyOrder();
            Navigator.pop(context);
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../provider/menu_option_provider.dart';

class MenuCountBtn extends ConsumerWidget {
  const MenuCountBtn({
    Key? key,
    required this.orderMenu,
  }) : super(key: key);
  final OrderMenu orderMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('개수', style: const TextStyle(fontSize: 20)),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    ref
                        .read(menuOptionNotifierProvider.notifier)
                        .decreaseQuantity();
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('${orderMenu.quantity}개'),
                IconButton(
                  onPressed: () {
                    ref
                        .read(menuOptionNotifierProvider.notifier)
                        .increaseQuantity();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

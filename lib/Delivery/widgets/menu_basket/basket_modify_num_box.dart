import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/post_model.dart';
import '../../provider/my_deliver_provider.dart';

class ModifyNumBox extends ConsumerWidget {
  const ModifyNumBox({
    Key? key,
    required this.orderMenu,
    required this.index,
  }) : super(key: key);
  final OrderMenu orderMenu;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          '${orderMenu.totalPrice}원',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              if (orderMenu.quantity > 1) {
                ref
                    .read(myDeliveryNotifierProvider.notifier)
                    .decreaseQuantity(index);
              }
            },
            icon: Icon(Icons.remove_circle)),
        Text('${orderMenu.quantity}'),
        IconButton(
            onPressed: () {
              ref
                  .read(myDeliveryNotifierProvider.notifier)
                  .increaseQuantity(index);
            },
            icon: Icon(Icons.add_circle)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/post_model.dart';
import '../../provider/my_deliver_provider.dart';

class DeleteMenu extends ConsumerWidget {
  const DeleteMenu({
    Key? key,
    required this.orderMenu,
    required this.index,
    required this.isLast,
  }) : super(key: key);
  final OrderMenu orderMenu;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderMenu.menu.name,
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
            onPressed: () {
              if (isLast) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('주문하기 위해 최소 하나의 메뉴가 필요합니다.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('취소')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  ref
                                      .read(myDeliveryNotifierProvider.notifier)
                                      .deleteMyDeliverOrder(index);
                                },
                                child: Text('삭제')),
                          ],
                        )).then((value) {
                  if (value == true) {
                    Navigator.pop(context);
                  }
                });
              } else {
                ref
                    .read(myDeliveryNotifierProvider.notifier)
                    .deleteMyDeliverOrder(index);
              }
            },
            icon: Icon(Icons.close))
      ],
    );
  }
}

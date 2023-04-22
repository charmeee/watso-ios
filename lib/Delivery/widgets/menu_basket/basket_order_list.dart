import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import 'basket_delete_box.dart';
import 'basket_modify_num_box.dart';
import 'basket_option_desc.dart';

class BasketList extends StatelessWidget {
  const BasketList({Key? key, required this.orderLines}) : super(key: key);
  final List<OrderMenu> orderLines;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            OrderMenu orderMenu = orderLines[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DeleteMenu(
                      orderMenu: orderMenu,
                      index: index,
                      isLast: orderLines.length == 1,
                    ),
                    if (orderMenu.menu.optionGroups != null &&
                        orderMenu.menu.optionGroups!.isNotEmpty)
                      OptionDesc(
                        optionGroups: orderMenu.menu.optionGroups!,
                      ),
                    ModifyNumBox(
                      orderMenu: orderMenu,
                      index: index,
                    ),
                  ],
                ),
              ],
            );
          },
          childCount: orderLines.length,
        ),
      ),
    );
  }
}

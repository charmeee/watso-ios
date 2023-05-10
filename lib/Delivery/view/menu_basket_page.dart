import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';

import '../models/post_request_model.dart';
import '../provider/my_deliver_provider.dart';
//주요 위젯
import '../widgets/menu_basket/basket_addMore_btn.dart';
import '../widgets/menu_basket/basket_calculate_box.dart';
import '../widgets/menu_basket/basket_order_list.dart';
import '../widgets/menu_basket/basket_submit_button.dart';

class MenuBasketPage extends ConsumerWidget {
  const MenuBasketPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostOrder postOrder = ref.watch(myDeliveryNotifierProvider);
    int totalSumPrice = postOrder.order.orderLines
        .fold(0, (pre, element) => pre + element.totalPrice);
    int expectDeliverFee = postOrder.store.fee ~/ postOrder.minMember;
    return Scaffold(
      appBar: customAppBar(context, title: '장바구니', isCenter: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                postOrder.store.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          BasketList(
            orderLines: postOrder.order.orderLines,
          ),
          const AddMoreBtn(),
          CalculateBox(
            totalSumPrice: totalSumPrice,
            expectDeliverFee: expectDeliverFee,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BasketSubmitButton(
          postOrder: postOrder,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';
import 'package:watso/Common/widget/outline_textformfield.dart';

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
    this.recuitNum,
  }) : super(key: key);
  final int? recuitNum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostOrder postOrder = ref.watch(myDeliveryNotifierProvider);
    int totalSumPrice = postOrder.order.orderLines
        .fold(0, (pre, element) => pre + element.totalPrice);
    int expectDeliverFee = postOrder.orderOption.store.fee ~/
        (recuitNum ?? postOrder.orderOption.minMember);
    return Scaffold(
      appBar: customAppBar(context, title: '장바구니', isCenter: true),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  postOrder.orderOption.store.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            BasketList(
              orderLines: postOrder.order.orderLines,
            ),
            const AddMoreBtn(),
            SliverToBoxAdapter(
              child: CalculateBox(
                totalSumPrice: totalSumPrice,
                expectDeliverFee: expectDeliverFee,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '요청사항',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    outlineTextFromField(
                      hintText: '요청사항을 입력해주세요',
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (value) {
                        ref
                            .read(myDeliveryNotifierProvider.notifier)
                            .setRequest(value);
                      },
                    )
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.bottomCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: BasketSubmitButton(
                  postOrder: postOrder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

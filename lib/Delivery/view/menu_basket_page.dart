import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';
import 'package:sangsangtalk/Common/widget/floating_bottom_button.dart';

import '../models/post_model.dart';
import '../models/post_request_model.dart';
import '../my_deliver_provider.dart';

class MenuBasketPage extends ConsumerStatefulWidget {
  const MenuBasketPage({
    Key? key,
    required this.storeName,
  }) : super(key: key);
  final String storeName;

  @override
  ConsumerState createState() => _MenuBasketPageState();
}

class _MenuBasketPageState extends ConsumerState<MenuBasketPage> {
  @override
  Widget build(BuildContext context) {
    PostOrder postOrder = ref.watch(postOrderNotifierProvider);
    List<int> sumPrice = ref.watch(sumPriceByOrderProvider);
    int totalSumPrice =
        sumPrice.fold(0, (previousValue, element) => previousValue + element);
    int expectDeliverFee = postOrder.store.fee ~/ postOrder.minMember;
    return Scaffold(
      appBar: customAppBar(context, title: '장바구니', isCenter: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.storeName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  OrderMenu orderMenu = postOrder.orders[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  orderMenu.menu.name,
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.close))
                              ],
                            ),
                            if (orderMenu.menu.groups != null &&
                                orderMenu.menu.groups!.isNotEmpty)
                              Column(mainAxisSize: MainAxisSize.min, children: [
                                for (var group in orderMenu.menu.groups!)
                                  if (group.options.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' · ${group.name} : ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          text: TextSpan(
                                            text: group.options.fold(
                                                '',
                                                (previousValue, element) =>
                                                    previousValue! +
                                                    element.name),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                              ]),
                            Row(
                              children: [
                                Text(
                                  '${sumPrice[index]}원',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.remove_circle)),
                                Text('${orderMenu.quantity}'),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.add_circle)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
                childCount: postOrder.orders.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('+ 더 담으러 가기',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총 주문 금액',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        '${totalSumPrice}원',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1인당 예상 배달비(최소 인원 달성 시)',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        '${expectDeliverFee}원',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '예상 본인 부담 금액',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        '${totalSumPrice + expectDeliverFee}원',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: customFloatingBottomButton(context,
          child: Text("배달톡 등록"), onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

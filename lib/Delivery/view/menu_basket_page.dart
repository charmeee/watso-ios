import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';
import 'package:sangsangtalk/Common/widget/floating_bottom_button.dart';

import '../models/post_model.dart';
import '../models/post_request_model.dart';
import '../my_deliver_provider.dart';
import '../post_list_provider.dart';
import '../repository/postOrder_repository.dart';

class MenuBasketPage extends ConsumerWidget {
  const MenuBasketPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                postOrder.store.name,
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
                      Column(
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
                                  onPressed: () {
                                    if (postOrder.orders.length == 1) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                    '주문하기 위해 최소 하나의 메뉴가 필요합니다.'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('취소')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                        ref
                                                            .read(
                                                                postOrderNotifierProvider
                                                                    .notifier)
                                                            .deleteMyDeliverOrder(
                                                                index);
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
                                          .read(postOrderNotifierProvider
                                              .notifier)
                                          .deleteMyDeliverOrder(index);
                                    }
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          if (orderMenu.menu.groups != null &&
                              orderMenu.menu.groups!.isNotEmpty)
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              for (var group in orderMenu.menu.groups!)
                                if (group.options.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                              color: Colors.grey, fontSize: 12),
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
                                  onPressed: () {
                                    if (orderMenu.quantity > 1) {
                                      ref
                                          .read(postOrderNotifierProvider
                                              .notifier)
                                          .decreaseQuantity(index);
                                    }
                                  },
                                  icon: Icon(Icons.remove_circle)),
                              Text('${orderMenu.quantity}'),
                              IconButton(
                                  onPressed: () {
                                    ref
                                        .read(
                                            postOrderNotifierProvider.notifier)
                                        .increaseQuantity(index);
                                  },
                                  icon: Icon(Icons.add_circle)),
                            ],
                          )
                        ],
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
                        '$expectDeliverFee원',
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
          child: Text("배달톡 등록"), onPressed: () {
        if (postOrder.canNotOrder) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('문제가 발생하였습니다.'),
          ));
        } else {
          ref
              .read(postOrderRepositoryProvider)
              .postDelivery(postOrder)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('배달톡이 등록되었습니다.'),
            ));
            ref.invalidate(myPostListProvider);
            ref.read(postOrderNotifierProvider.notifier).deleteMyDeliver();
            Navigator.of(context).popUntil((route) => route.isFirst);
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('문제가 발생하였습니다.'),
            ));
          });

          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

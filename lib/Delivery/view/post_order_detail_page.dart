import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/appbar.dart';
import '../models/post_model.dart';
import '../repository/order_repository.dart';

class PostOrderDetailPage extends ConsumerWidget {
  final String postId;

  const PostOrderDetailPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: customAppBar(
          context,
          title: '팀원 주문 내역',
          isCenter: true,
        ),
        body: FutureBuilder<List<Order>>(
          future: ref.watch(orderRepositoryProvider(postId)).getPostOrder(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Order> orderDataList = snapshot.data!;
              return ListView.separated(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final Order postDetailOrder = orderDataList[index];
                  final int sum = postDetailOrder.orderLines.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + element.totalPrice);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(postDetailOrder.nickname,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('총합: $sum원',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      ListView.separated(
                        itemBuilder: (context, index) {
                          OrderMenu orderMenu =
                              postDetailOrder.orderLines[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  orderMenu.menu.name +
                                      ' × ${orderMenu.quantity}개',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  ' · 기본 : ${orderMenu.menu.price}원',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                if (orderMenu.menu.optionGroups != null &&
                                    orderMenu.menu.optionGroups!.isNotEmpty)
                                  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var group
                                            in orderMenu.menu.optionGroups!)
                                          if (group.options.isNotEmpty)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' · ${group.name} : ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    group.options.fold(
                                                        '',
                                                        (previousValue,
                                                                element) =>
                                                            '$previousValue, ${element.name} [${element.price}원] '),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                )
                                              ],
                                            ),
                                      ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${orderMenu.totalPrice}원',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: postDetailOrder.orderLines.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 8,
                          );
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 12,
                    thickness: 4,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('에러'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

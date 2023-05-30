import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/theme/text.dart';
import 'package:watso/Common/view/error_page.dart';

import '../../Common/widget/appbar.dart';
import '../models/post_model.dart';
import '../repository/order_repository.dart';
import '../widgets/common/optionDescBox.dart';
import '../widgets/menu_basket/basket_calculate_box.dart';

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
              int totalSumPrice = orderDataList.fold(
                  0,
                  (previousValue, element) =>
                      previousValue +
                      element.orderLines.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.totalPrice));
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.separated(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final Order postDetailOrder = orderDataList[index];
                        final int sum = postDetailOrder.orderLines.fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.totalPrice);
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(postDetailOrder.nickname,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text('총합: $sum원',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                              ),
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  OrderMenu orderMenu =
                                      postDetailOrder.orderLines[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
                                        if (orderMenu.menu.optionGroups !=
                                                null &&
                                            orderMenu
                                                .menu.optionGroups!.isNotEmpty)
                                          Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (var group in orderMenu
                                                    .menu.optionGroups!)
                                                  if (group.options.isNotEmpty)
                                                    OptionBoxDesc(
                                                      group: group,
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
                                  return SizedBox(height: 24);
                                },
                              ),
                              if (postDetailOrder.requestComment.isNotEmpty)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      height: 2,
                                      thickness: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16),
                                      child: Row(
                                        children: [
                                          Text(
                                            '요청사항 :  ',
                                            style: WatsoText.bold
                                                .copyWith(fontSize: 16),
                                          ),
                                          Text(postDetailOrder.requestComment)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 4,
                          thickness: 4,
                          color: Colors.transparent,
                        );
                      },
                    ),
                    CalculateBox(
                        totalSumPrice: totalSumPrice,
                        expectDeliverFee: 0,
                        isTotal: true),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return ErrorPage(error: Exception(snapshot.error));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/appbar.dart';
import '../models/post_model.dart';
import '../provider/post_list_provider.dart';
import '../repository/order_repository.dart';
import '../repository/post_repository.dart';
import '../widgets/common/optionDescBox.dart';

class MyPostOrderDetailPage extends ConsumerWidget {
  final String postId;
  final Store store;
  final int orderNum;
  final bool isOwner;
  final PostStatus status;

  const MyPostOrderDetailPage(
      {Key? key,
      required this.postId,
      required this.store,
      required this.orderNum,
      required this.isOwner,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: '내 주문 상세 내역',
        isCenter: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (isOwner &&
                          (status == PostStatus.recruiting ||
                              status == PostStatus.closed)) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('게시글 삭제'),
                                  content: Text('게시글을 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('삭제')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('취소')),
                                  ],
                                )).then((value) async {
                          if (value) {
                            await ref
                                .read(postRepositoryProvider)
                                .deletePost(postId);
                            ref.invalidate(myPostListProvider);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        });
                        return;
                      }
                      if (status == PostStatus.recruiting) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('게시글 탈퇴'),
                                  content:
                                      Text('해당 주문 내역을 모두 취소하고 게시글을 탈퇴하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('네')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('아니요')),
                                  ],
                                )).then((value) async {
                          if (value) {
                            await ref
                                .read(postRepositoryProvider)
                                .leavePost(postId);
                            ref.invalidate(myPostListProvider);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        });
                        return;
                      }
                      final errorText = status == PostStatus.closed
                          ? '모집 마감 상태에서는 주문을 삭제할 수 없습니다. 게시글 대표에게 문의해보세요'
                          : '${status.korName}상테어서는 주문을 삭제할 수 없습니다.';
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('에러'),
                                content: Text(errorText),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('확인')),
                                ],
                              ));
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[300],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 12,
              thickness: 4,
            ),
            SizedBox(
              height: 8,
            ),
            FutureBuilder<Order>(
                future:
                    ref.watch(orderRepositoryProvider(postId)).getMyPostOrder(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final Order myOrderData = snapshot.data!;
                    int totalSumPrice = myOrderData.orderLines
                        .fold(0, (pre, element) => pre + element.totalPrice);
                    int expectDeliverFee = store.fee ~/ orderNum;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              final orderMenu = myOrderData.orderLines[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
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
                                    if (orderMenu.menu.optionGroups != null &&
                                        orderMenu.menu.optionGroups!.isNotEmpty)
                                      Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var group
                                                in orderMenu.menu.optionGroups!)
                                              OptionBoxDesc(group: group),
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                            itemCount: snapshot.data!.orderLines.length),
                        Divider(
                          height: 12,
                          thickness: 4,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '총 주문 금액',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    '${totalSumPrice}원',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '현재 기준 1인당 예상 배달비',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    '$expectDeliverFee원',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 20,
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('에러'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:watso/Delivery/view/post_page.dart';

import '../../Common/widget/appbar.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';
import '../repository/post_repository.dart';
import 'post_order_me_detail_page.dart';

class DeliverHistoryPage extends ConsumerWidget {
  const DeliverHistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(context, title: '배달왔소 참가 내역'),
      body: FutureBuilder<List<ResponsePost>>(
        future:
        ref.read(postRepositoryProvider).getDeliveryList(PostFilter.all),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<ResponsePost> data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                ResponsePost nowData = data[index];
                String orderDate =
                DateFormat("M.d(E)", 'ko').format(nowData.orderTime);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(orderDate),
                            Text('﹒'),
                            Text(nowData.status.korName),
                            Spacer(),
                            OutlinedButton(
                              onPressed: () {
                                //MyPostOrderDetailPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyPostOrderDetailPage(
                                            postId: nowData.id,
                                            store: nowData.store,
                                            orderNum: nowData.users.length,
                                            status: nowData.status,
                                          )),
                                );
                              },
                              child: Text(
                                '내 배달 보기',
                                style:
                                TextStyle(height: 1, color: Colors.black),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                textStyle: TextStyle(height: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                nowData.store.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PostPage(
                                        postId: nowData.id,
                                      )),
                            );
                          },
                          child: Text(
                            '게시글 보러가기',
                            style: TextStyle(color: Colors.indigo),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // backgroundColor: Colors.indigo
                          ),
                        )
                        // icon: Icon(Icons.arrow_forward_ios),
                        // label: Text('주문 내역 보기'))
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('에러'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

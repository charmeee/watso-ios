import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:watso/Delivery/view/post_page.dart';

import '../../Common/widget/appbar.dart';
import '../../Common/widget/secondary_button.dart';
import '../models/post_filter_model.dart';
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
            if (data.length == 0) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('배달왔소 이전 참가 내역이 없습니다.')));
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                ResponsePost nowData = data[index];
                String orderDate =
                    DateFormat("M.d(E)", 'ko').format(nowData.orderTime);
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(orderDate),
                                    Text('﹒'),
                                    Text(nowData.status.korName),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        nowData.store.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
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
                                )
                              ],
                            ),
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
                                            fee: nowData.fee,
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

                        SizedBox(
                          height: 40,
                          child: secondaryButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostPage(
                                          postId: nowData.id,
                                        )),
                              );
                            },
                            text: '게시글 보러가기',
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

import '../../Auth/auth_provider.dart';
import '../models/post_response_model.dart';
import '../provider/post_list_provider.dart';
import 'post_order_detail_page.dart';
import 'post_order_me_detail_page.dart';

class PostPage extends ConsumerWidget {
  const PostPage({
    Key? key,
    required this.postId,
    required this.postTitle,
  }) : super(key: key);
  final String postId;
  final String postTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ResponsePost> postData = ref.watch(postDetailProvider(postId));
    String userId = ref.watch(userNotifierProvider)!.id;

    return Scaffold(
      appBar: customAppBar(context, title: postTitle),
      body: postData.when(
          data: (data) {
            bool joined = data.users.any((element) => element == userId);
            return CustomScrollView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Text(
                              "모집정보",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          _informationTile(
                              icon: Icons.store,
                              title: "주문가게",
                              content: data.store.name),
                          _informationTile(
                              icon: Icons.access_time_rounded,
                              title: "주문시간",
                              content: DateFormat("M월 d일(E) HH시 mm분")
                                  .format(data.orderTime)),
                          //"3월 19일(일) 10시 30분"
                          _informationTile(
                              icon: Icons.people,
                              title: "현재 모인 인원",
                              content:
                                  "${data.users.length} 명 (최소 ${data.minMember}명 필요)"),
                          _informationTile(
                              icon: Icons.attach_money,
                              title: "예상 배달비",
                              content:
                                  "${data.store.fee ~/ data.users.length}원"),
                          if (joined)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyPostOrderDetailPage(
                                                      postId: widget.postId,
                                                      store: data.store,
                                                      orderNum:
                                                          data.users.length,
                                                    )));
                                      },
                                      child: Text("내 배달 상세"),
                                      style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          fixedSize: const Size.fromHeight(40),
                                          backgroundColor: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostOrderDetailPage(
                                                        postId:
                                                            widget.postId)));
                                      },
                                      child: Text("전체 배달"),
                                      style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          fixedSize: const Size.fromHeight(40),
                                          backgroundColor: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(joined ? "배달 확정" : "배달 참가"),
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    minimumSize: const Size.fromHeight(40),
                                    backgroundColor: Colors.indigo),
                              ),
                            ),
                          ),
                        ]),
                  ),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "댓글",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "해당 배달관련 문의사항은 댓글로 적어주세요",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("닉네임무언가 · 오늘 10:30 ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                        text:
                                            "대충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.comment,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text("답글달기",
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("닉네임무언가 · 오늘 10:30 ",
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        RichText(
                                            text: TextSpan(
                                          text:
                                              "충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("닉네임무언가 · 오늘 10:30 ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                        text:
                                            "충댓글내용 댓글내용대충댓글내용 댓글내용대충댓글내용 댓글내용",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.comment,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text("답글달기",
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: '댓글을 입력해주세요',
                                  contentPadding: EdgeInsets.all(10),
                                  suffixIcon: Icon(
                                    Icons.send_rounded,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))),
                const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 20)),
              ],
            );
          },
          error: (error, track) => Center(child: Text('에러')),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }

  // Padding(
  // padding: const EdgeInsets.symmetric(horizontal: 8.0),
  // child: ListTile(
  // tileColor: Colors.white,
  // leading: Icon(Icons.store),
  // title: Text('맘스터치'),
  // ),
  // ),
  Widget _informationTile(
      {required IconData icon,
      required String title,
      required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Icon(
              icon,
              // Icons.store,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  )),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

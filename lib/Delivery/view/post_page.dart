import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';
import 'package:sangsangtalk/Delivery/models/post_model.dart';

import '../../Auth/provider/user_provider.dart';
import '../models/post_response_model.dart';
import '../provider/my_deliver_provider.dart';
import '../provider/post_list_provider.dart';
import '../repository/post_repository.dart';
import '../widgets/post_page/post_comment_list.dart';
import 'menu_list_page.dart';
import 'post_order_detail_page.dart';
import 'post_order_me_detail_page.dart';

class PostPage extends ConsumerWidget {
  const PostPage({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ResponsePost> postData = ref.watch(postDetailProvider(postId));
    String userId = ref.watch(userNotifierProvider)!.id;

    return postData.when(
        data: (data) {
          bool isJoined = data.users.any((element) => element == userId);
          bool isOwner = data.userId == userId;
          return Scaffold(
            appBar: customAppBar(context,
                title: data.store.name,
                action: _postDeleteButton(context, ref,
                    isOwner: isOwner, status: data.status)),
            body: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(postDetailProvider(postId));
              },
              child: CustomScrollView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                                content: DateFormat("M월 d일(E) HH시 mm분", 'ko')
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
                            _informationTile(
                                icon: data.status == PostStatus.recruiting
                                    ? Icons.person
                                    : Icons.person_off,
                                title: "모집 여부",
                                widget: ToggleButtons(
                                  children: [
                                    Text("모집중"),
                                    Text("모집완료"),
                                  ],
                                  isSelected: [
                                    data.status == PostStatus.recruiting,
                                    data.status != PostStatus.recruiting
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  selectedBorderColor: Colors.green[700],
                                  selectedColor: Colors.white,
                                  fillColor: Colors.green[200],
                                  color: Colors.green[400],
                                  constraints: const BoxConstraints(
                                    minHeight: 30.0,
                                    minWidth: 80.0,
                                  ),
                                  onPressed: (index) async {
                                    if (!isOwner) return;
                                    if (data.status == PostStatus.ordered ||
                                        data.status == PostStatus.delivered) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "주문/배달 완료된 글은 모집 상태를 변경할 수 없습니다."),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("확인"))
                                              ],
                                            );
                                          });
                                      return;
                                    }
                                    try {
                                      if (index == 0) {
                                        await ref
                                            .read(postRepositoryProvider)
                                            .updatePostStatus(
                                                postId, PostStatus.recruiting);
                                      } else {
                                        await ref
                                            .read(postRepositoryProvider)
                                            .updatePostStatus(
                                                postId, PostStatus.closed);
                                      }
                                      ref.invalidate(
                                          postDetailProvider(postId));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("모집 상태 변경 실패")));
                                    }
                                  },
                                )),
                            if (isJoined)
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
                                                        postId: postId,
                                                        store: data.store,
                                                        orderNum:
                                                            data.users.length,
                                                        status: data.status,
                                                      )));
                                        },
                                        child: Text("내 배달 상세"),
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            fixedSize:
                                                const Size.fromHeight(40),
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
                                                          postId: postId)));
                                        },
                                        child: Text("전체 배달"),
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            fixedSize:
                                                const Size.fromHeight(40),
                                            backgroundColor: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (isJoined && isOwner)
                              _statusButton(data, ref, context),
                            if (!isJoined &&
                                !isOwner &&
                                data.status == PostStatus.recruiting)
                              _joinButton(data, context, ref),
                            if (isJoined && !isOwner)
                              _quitButton(context, ref, status: data.status),
                            SizedBox(
                              height: 4,
                            )
                          ]),
                    ),
                  )),
                  CommentList(
                    postId: postId,
                    isOwner: isOwner,
                    isJoined: isJoined,
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20)),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, track) => Scaffold(body: Center(child: Text('에러'))),
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())));
  }

  List<Widget>? _postDeleteButton(context, ref,
      {required bool isOwner, required PostStatus status}) {
    if (isOwner) {
      return [
        IconButton(
          onPressed: () async {
            if (status == PostStatus.recruiting ||
                status == PostStatus.closed) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('게시글 삭제'),
                        content: Text('게시글을 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('취소')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text('삭제')),
                        ],
                      )).then((value) async {
                if (value) {
                  await ref.read(postRepositoryProvider).deletePost(postId);
                  ref.invalidate(myPostListProvider);
                  Navigator.popUntil(context, (route) => route.isFirst);
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
      ];
    }
    return null;
  }

  Widget _informationTile(
      {required IconData icon,
      required String title,
      String? content,
      Widget? widget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  )),
              if (widget != null) widget,
              if (content != null)
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

  Widget _statusButton(ResponsePost data, WidgetRef ref, context) {
    if (data.status == PostStatus.delivered ||
        data.status == PostStatus.recruiting ||
        data.status == PostStatus.canceled) {
      return const SizedBox(
        height: 0,
      );
    }

    final int index = data.status.index;
    onButtonClick() {
      if (index == PostStatus.values.length - 1) {
        return;
      }
      ref
          .read(postRepositoryProvider)
          .updatePostStatus(data.id, PostStatus.values[index + 1])
          .then((value) {
        if (index + 1 == PostStatus.values.length - 1) {
          ref.invalidate(myPostListProvider);
          Navigator.pop(context);
          return;
        } //배달완료 누른거
        ref.invalidate(postDetailProvider(postId));
      }).onError((error, stackTrace) {
        //snackbar
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('에러')));
      });
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: ElevatedButton(
            onPressed: onButtonClick,
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                minimumSize: const Size.fromHeight(40),
                backgroundColor: Colors.indigo),
            child: Text(PostStatus.values[index + 1].korName),
          ),
        ));
  }

  Widget _joinButton(ResponsePost data, context, WidgetRef ref) {
    onButtonClick() {
      ref.read(myDeliveryNotifierProvider.notifier).setMyDeliverOption(
            place: data.place,
            orderTime: data.orderTime,
            minMember: data.minMember,
            maxMember: data.maxMember,
            postId: data.id,
          );
      ref
          .read(myDeliveryNotifierProvider.notifier)
          .setMyDeliverStore(data.store);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuListPage(
                  storeId: data.store.id,
                )),
      );
    }

    return (Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: ElevatedButton(
          onPressed: onButtonClick,
          child: Text("배달 참가"),
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              minimumSize: const Size.fromHeight(40),
              backgroundColor: Colors.indigo),
        ),
      ),
    ));
  }

  Widget _quitButton(context, ref, {required PostStatus status}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: ElevatedButton(
            onPressed: () async {
              if (status == PostStatus.recruiting) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('게시글 탈퇴'),
                          content: Text('해당 주문 내역을 모두 취소하고 게시글을 탈퇴하시겠습니까?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('아니요')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text('네')),
                          ],
                        )).then((value) async {
                  if (value) {
                    await ref.read(postRepositoryProvider).leavePost(postId);
                    ref.invalidate(myPostListProvider);
                    Navigator.popUntil(context, (route) => route.isFirst);
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
            child: Text('배달 탈퇴하기'),
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                minimumSize: const Size.fromHeight(40),
                backgroundColor: Colors.indigo),
          ),
        ));
  }
}

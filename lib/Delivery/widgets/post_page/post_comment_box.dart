import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:watso/Delivery/models/comment_model.dart';

import '../../../Auth/provider/user_provider.dart';
import '../../provider/post_list_provider.dart';
import '../../repository/post_repository.dart';

class CommentBox extends ConsumerWidget {
  const CommentBox(
      {Key? key,
      required this.isOwner,
      required this.isJoined,
      required this.comment,
      required this.isParent,
      required this.selectedCommentId,
      required this.selectComment,
      required this.commentFocusNode})
      : super(key: key);
  final bool isJoined;
  final bool isOwner;
  final Comment comment;
  final bool isParent;
  final String selectedCommentId;
  final Function(String commentId) selectComment;
  final FocusNode commentFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String createdAt = DateFormat("M.d h:m", 'ko').format(comment.createdAt);
    final user = ref.watch(userNotifierProvider);
    return Padding(
      padding: isParent
          ? const EdgeInsets.only()
          : const EdgeInsets.only(left: 24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: selectedCommentId == comment.id
                ? Colors.indigo[50]
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(10),
          child: comment.status == CommentStatus.deleted
              ? Text("삭제된 댓글입니다.")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${comment.nickname} · $createdAt ",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        if (user?.id == comment.userId)
                          InkWell(
                            child: Icon(
                              Icons.close,
                              size: 14,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("댓글 삭제"),
                                      content: Text("댓글을 삭제하시겠습니까?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("취소")),
                                        TextButton(
                                            onPressed: () {
                                              ref
                                                  .read(postRepositoryProvider)
                                                  .deleteComment(comment.postId,
                                                      comment.id)
                                                  .then((value) => ref.invalidate(
                                                      postCommentListProvider(
                                                          comment.postId)))
                                                  .onError((error, stackTrace) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "댓글 삭제에 실패했습니다.")));
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("삭제")),
                                      ],
                                    );
                                  });
                            },
                          )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Flexible(
                        child: Text(
                      comment.content,
                      style: TextStyle(color: Colors.black),
                    )),
                    SizedBox(
                      height: 4,
                    ),
                    if (isParent)
                      InkWell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.comment,
                              size: 16,
                            ),
                            Text(
                              "답글달기",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (selectedCommentId == comment.id) {
                            selectComment('');
                            commentFocusNode.unfocus();
                          } else {
                            selectComment(comment.id);
                            commentFocusNode.requestFocus();
                          }
                        },
                        highlightColor: Colors.red,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

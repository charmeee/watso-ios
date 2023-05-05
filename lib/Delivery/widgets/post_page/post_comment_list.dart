import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/comment_model.dart';
import '../../provider/post_list_provider.dart';
import '../../repository/post_repository.dart';
import 'post_comment_box.dart';

class CommentList extends ConsumerStatefulWidget {
  const CommentList({
    Key? key,
    required this.isJoined,
    required this.isOwner,
    required this.postId,
  }) : super(key: key);
  final bool isJoined;
  final bool isOwner;
  final String postId;

  @override
  ConsumerState createState() => _CommentBoxState();
}

class _CommentBoxState extends ConsumerState<CommentList> {
  //textcontroller
  final TextEditingController _commentController = TextEditingController();
  String selectedCommentId = '';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  selectComment(String commentId) {
    setState(() {
      selectedCommentId = commentId;
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Comment>> commentsList =
        ref.watch(postCommentListProvider(widget.postId));

    return SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "댓글",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                  commentsList.when(
                      data: (data) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < data.length; i++)
                              CommentBox(
                                isJoined: widget.isJoined,
                                isOwner: widget.isOwner,
                                comment: data[i],
                                isParent: data[i].superCommentId == null,
                                selectedCommentId: selectedCommentId,
                                selectComment: selectComment,
                              ),
                          ],
                        );
                      },
                      error: (error, track) => Text('Error: $error'),
                      loading: () => CircularProgressIndicator()),
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (selectedCommentId.isEmpty) {
                            ref
                                .read(postRepositoryProvider)
                                .postComment(
                                    widget.postId, _commentController.text)
                                .then((value) {
                              _commentController.clear();
                              ref.invalidate(
                                  postCommentListProvider(widget.postId));
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('댓글을 작성할 수 없습니다.'),
                                ),
                              );
                            });
                          } else {
                            ref
                                .read(postRepositoryProvider)
                                .postChildComment(widget.postId,
                                    selectedCommentId, _commentController.text)
                                .then((value) {
                              _commentController.clear();
                              selectComment('');
                              ref.invalidate(
                                  postCommentListProvider(widget.postId));
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('댓글을 작성할 수 없습니다.'),
                                ),
                              );
                            });
                          }
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    controller: _commentController,
                  ),
                ],
              ),
            ))));
  }
}

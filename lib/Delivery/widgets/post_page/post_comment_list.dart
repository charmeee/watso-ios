import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/theme/color.dart';

import '../../../Common/theme/text.dart';
import '../../../Common/widget/outline_textformfield.dart';
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
  final FocusNode _commentFocusNode = FocusNode();

  String selectedCommentId = '';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  selectCommentId(String commentId) {
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
                        style: WatsoText.title,
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
                        log('data: ${data.map((e) => e.toJson())}');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < data.length; i++)
                              CommentBox(
                                isJoined: widget.isJoined,
                                isOwner: widget.isOwner,
                                comment: data[i],
                                isParent: data[i].parentId == null ||
                                    data[i].parentId == 'null',
                                selectedCommentId: selectedCommentId,
                                selectComment: selectCommentId,
                                commentFocusNode: _commentFocusNode,
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Focus(
                              onFocusChange: (hasFocus) {
                                if (!hasFocus) {
                                  selectCommentId('');
                                }
                              },
                              child: outlineTextFromField(
                                focusNode: _commentFocusNode,
                                hintText: '댓글을 입력해주세요',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (_commentController.text.isEmpty) return;
                                    if (selectedCommentId.isEmpty) {
                                      ref
                                          .read(postRepositoryProvider)
                                          .postComment(widget.postId,
                                              _commentController.text)
                                          .then((value) {
                                        _commentController.clear();
                                        ref.invalidate(postCommentListProvider(
                                            widget.postId));
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('댓글을 작성할 수 없습니다.'),
                                          ),
                                        );
                                      });
                                    } else {
                                      ref
                                          .read(postRepositoryProvider)
                                          .postChildComment(
                                              widget.postId,
                                              selectedCommentId,
                                              _commentController.text)
                                          .then((value) {
                                        _commentController.clear();

                                        selectCommentId('');
                                        ref.invalidate(postCommentListProvider(
                                            widget.postId));
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('댓글을 작성할 수 없습니다.'),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: WatsoColor.primary,
                                  ),
                                ),
                                controller: _commentController,
                              ),
                            ),
                          ],
                        );
                      },
                      error: (error, track) => Text('Error: $error'),
                      loading: () => CircularProgressIndicator()),
                ],
              ),
            ))));
  }
}

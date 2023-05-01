enum CommentStatus { created, modified, deleted }

class Comment {
  String id;
  String postId;
  String userId;
  String nickname;
  CommentStatus status;
  String content;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.nickname,
    required this.status,
    required this.content,
    required this.createdAt,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        postId = json['post_id'].toString(),
        userId = json['user_id'].toString(),
        nickname = json['nickname'],
        status = CommentStatus.values.byName(json['status']),
        content = json['content'],
        createdAt = DateTime.parse(json['create_at']);
}

class ParentComment extends Comment {
  List<Comment> subComments;

  ParentComment(
      {required id,
      required postId,
      required userId,
      required nickname,
      required status,
      required content,
      required createdAt,
      required this.subComments})
      : super(
          id: id,
          postId: postId,
          userId: userId,
          nickname: nickname,
          status: status,
          content: content,
          createdAt: createdAt,
        );

  ParentComment.fromJson(Map<String, dynamic> json)
      : subComments = List<Comment>.from(
            json['sub_comments'].map((x) => Comment.fromJson(x))),
        super.fromJson(json);
}

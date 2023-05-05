enum CommentStatus { created, modified, deleted }

class Comment {
  String id;
  String postId;
  String userId;
  String nickname;
  CommentStatus status;
  String content;
  DateTime createdAt;
  String? parentId;

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
        createdAt = DateTime.parse(json['create_at']),
        parentId = json['parent_id']?.toString();

  Map<String, dynamic> toJson() => {
        'post_id': postId,
        'user_id': userId,
        'nickname': nickname,
        'status': status.name,
        'content': content,
        'create_at': createdAt.toIso8601String(),
        if (parentId != null) 'parent_id': parentId,
      };
}

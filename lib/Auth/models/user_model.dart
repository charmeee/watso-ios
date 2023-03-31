class UserInfo {
  String id;
  String nickname;

  User({required this.id, required this.nickname});

  User.fromJson(Map<String, dynamic> json)
      : id = (json['id'] ?? json['user_id']).toString(),
        nickname = json['nickname'];
}

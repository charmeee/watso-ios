class UserInfo {
  String id;
  String nickname;

  UserInfo(
      {required this.id,
        required this.nickname});

  UserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'];


}


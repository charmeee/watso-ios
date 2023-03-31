class UserInfo extends User {
  String username;
  String accountNumber;
  String email;

  UserInfo(
      {required id,
      required nickname,
      required this.username,
      required this.accountNumber,
      required this.email})
      : super(id: id, nickname: nickname);

  UserInfo.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        accountNumber = json['account_number'],
        email = json['email'],
        super.fromJson(json);
}

class User {
  String id;
  String nickname;

  User({required this.id, required this.nickname});

  User.fromJson(Map<String, dynamic> json)
      : id = (json['id'] ?? json['user_id']).toString(),
        nickname = json['nickname'];
}

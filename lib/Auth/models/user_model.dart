class UserInfo extends User {
  String name;
  String username;
  String accountNumber;
  String email;

  UserInfo(
      {required id,
      required nickname,
      required this.name,
      required this.username,
      required this.accountNumber,
      required this.email})
      : super(id: id, nickname: nickname);

  UserInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        username = json['username'],
        accountNumber = json['account_number'],
        email = json['email'],
        super.fromJson(json);

  UserInfo.clone(UserInfo userInfo)
      : name = userInfo.name,
        username = userInfo.username,
        accountNumber = userInfo.accountNumber,
        email = userInfo.email,
        super.clone(userInfo);
}

class User {
  String id;
  String nickname;

  User({required this.id, required this.nickname});

  User.fromJson(Map<String, dynamic> json)
      : id = (json['_id'] ?? json['user_id']).toString(),
        nickname = json['nickname'];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'nickname': nickname,
      };

  User.clone(User user)
      : id = user.id,
        nickname = user.nickname;
}

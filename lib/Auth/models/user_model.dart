class UserInfo {
  String? id;
  String? username;
  String? nickname;
  String? userEmail;
  String? ageRange;
  String? gender;
  String? weight;
  UserInfo(
      {this.id,
        this.username,
        this.nickname,
        this.userEmail,
        this.ageRange,
        this.gender,
        this.weight});
  UserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        nickname = json['nickname'],
        userEmail = json['userEmail'],
        ageRange = json['ageRange'],
        weight = json['weight'],
        gender = json['gender'];

  UserInfo.init() {
    id = null;
    username = null;
    nickname = null;
    userEmail = null;
    ageRange = null;
    weight = null;
    gender = null;
  }
}
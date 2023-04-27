enum DuplicateCheckField {
  email,
  username,
  nickname,
}

extension DuplicateCheckFieldExtension on DuplicateCheckField {
  String get korName {
    switch (this) {
      case DuplicateCheckField.email:
        return '이메일';
      case DuplicateCheckField.username:
        return '아이디';
      case DuplicateCheckField.nickname:
        return '닉네임';
      default:
        return '';
    }
  }
}

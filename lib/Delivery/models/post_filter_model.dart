enum PostFilter { all, joinable, joined }

enum PostPlaceFilter { all, dorm, school }

extension PostPlaceFilterExtension on PostPlaceFilter {
  String get korName {
    switch (this) {
      case PostPlaceFilter.all:
        return '모두';
      case PostPlaceFilter.dorm:
        return '기숙사';
      case PostPlaceFilter.school:
        return '생자대';
      default:
        return '';
    }
  }
}

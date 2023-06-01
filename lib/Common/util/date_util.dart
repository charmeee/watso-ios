//date utils

import 'package:intl/intl.dart';

String getStringDate(DateTime dateTime) {
  DateTime nowDate = DateTime.now();
  //check today
  if (dateTime.year == nowDate.year &&
      dateTime.month == nowDate.month &&
      dateTime.day == nowDate.day) {
    return "오늘";
  }
  if (dateTime.year == nowDate.year &&
      dateTime.month == nowDate.month &&
      dateTime.day + 1 == nowDate.day) {
    return "내일";
  }

  return DateFormat("M월 d일 E요일", 'ko').format(dateTime);
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

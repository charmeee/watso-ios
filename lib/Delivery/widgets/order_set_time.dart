import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSelector extends ConsumerStatefulWidget {
  const TimeSelector({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends ConsumerState<TimeSelector> {
  DateTime nowDate = DateTime.now();
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime(nowDate.year, nowDate.month, nowDate.day, nowDate.hour,
        nowDate.minute - nowDate.minute % 10 + 10);
  }

  void _showTimePicker() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) =>
            Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: CupertinoDatePicker(
                  initialDateTime: _dateTime,
                  minuteInterval: 10,
                  minimumDate: nowDate,
                  //maxdate nowDate + 1 day
                  maximumDate: nowDate.add(Duration(days: 1)),
                  use24hFormat: false,
                  // This is called when the user changes the dateTime.
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() => _dateTime = newDateTime);
                  },
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "주문 예정 시간",
          style: TextStyle(fontSize: 15),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            _showTimePicker();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("5월 19일 5시 30분", style: TextStyle(fontSize: 20)),
              Icon(Icons.timer),
            ],
          ),
        ),
      ],
    );
  }
}

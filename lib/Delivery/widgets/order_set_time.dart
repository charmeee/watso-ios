import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/order_option_provider.dart';

class TimeSelector extends ConsumerStatefulWidget {
  const TimeSelector({
    Key? key,
    required this.orderTime,
    this.setOrderTime,
  }) : super(key: key);
  final DateTime orderTime;
  final Function(DateTime time)? setOrderTime;

  @override
  ConsumerState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends ConsumerState<TimeSelector> {
  DateTime nowDate = DateTime.now();

  void _showTimePicker() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: CupertinoDatePicker(
                  initialDateTime: widget.orderTime,
                  minuteInterval: 10,
                  minimumDate: nowDate,
                  maximumDate: nowDate.add(Duration(days: 7)),
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    if (widget.setOrderTime != null) {
                      widget.setOrderTime!(newDateTime);
                    } else {
                      ref
                          .read(orderOptionNotifierProvider.notifier)
                          .setPartOfOption(orderTime: newDateTime);
                    }
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
              Text(DateFormat('MM월 dd일 HH시 mm분').format(widget.orderTime),
                  style: TextStyle(fontSize: 20)),
              Icon(Icons.timer),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/theme/color.dart';

import '../provider/order_option_provider.dart';

class PlaceSelector extends ConsumerWidget {
  const PlaceSelector({
    Key? key,
    required this.place,
    this.setPlace,
  }) : super(key: key);
  final String place;
  final Function(String place)? setPlace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool editMode = setPlace != null;
    String nowPlace = place;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "수령 장소",
            style: TextStyle(fontSize: 15),
          ),
          Row(
            children: [
              Radio(
                value: '생자대',
                groupValue: nowPlace,
                onChanged: (value) {
                  if (editMode) {
                    setPlace!(value.toString());
                    return;
                  }
                  ref
                      .read(orderOptionNotifierProvider.notifier)
                      .setPartOfOption(place: value.toString());
                },
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return WatsoColor.primary;
                  }
                  return Colors.grey;
                }),
              ),
              Expanded(child: Text("생자대")),
              Radio(
                value: '기숙사',
                groupValue: nowPlace,
                onChanged: (value) {
                  if (editMode) {
                    setPlace!(value.toString());
                    return;
                  }
                  ref
                      .read(orderOptionNotifierProvider.notifier)
                      .setPartOfOption(place: value.toString());
                },
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return WatsoColor.primary;
                  }
                  return Colors.grey;
                }),
              ),
              Expanded(child: Text("기숙사")),
            ],
          )
        ]);
  }
}

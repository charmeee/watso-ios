import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/my_deliver_provider.dart';

class PlaceSelector extends ConsumerWidget {
  const PlaceSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String place = ref.watch(postOrderNotifierProvider).place;
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
                groupValue: place,
                onChanged: (value) {
                  ref
                      .read(postOrderNotifierProvider.notifier)
                      .setMyDeliverOption(place: value.toString());
                },
              ),
              Expanded(child: Text("생자대")),
              Radio(
                value: '기숙사',
                groupValue: place,
                onChanged: (value) {
                  ref
                      .read(postOrderNotifierProvider.notifier)
                      .setMyDeliverOption(place: value.toString());
                },
              ),
              Expanded(child: Text("기숙사")),
            ],
          )
        ]);
  }
}

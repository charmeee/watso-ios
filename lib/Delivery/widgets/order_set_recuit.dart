import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/my_deliver_provider.dart';

class RecuitNumSelector extends ConsumerStatefulWidget {
  final GlobalKey<FormState> recruitFormKey;

  const RecuitNumSelector({
    Key? key,
    required this.recruitFormKey,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RecuitNumSelectorState();
}

class _RecuitNumSelectorState extends ConsumerState<RecuitNumSelector> {
  bool minChecked = false;
  bool maxChecked = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.recruitFormKey,
      child: Row(
        children: [
          Checkbox(
              value: minChecked,
              onChanged: (value) {
                setState(() {
                  minChecked = value!;
                });
              }),
          Expanded(
              child: TextFormField(
            decoration: InputDecoration(
              label: Text('최소 인원'),
            ),
            initialValue: '2',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSaved: (value) {
              if (minChecked && value!.isNotEmpty) {
                ref
                    .read(postOrderNotifierProvider.notifier)
                    .setMyDeliverOption(minMember: int.parse(value));
              } else if (!minChecked) {
                ref
                    .read(postOrderNotifierProvider.notifier)
                    .setMyDeliverOption(minMember: 1);
              }
            },
          )),
          Checkbox(
              value: maxChecked,
              onChanged: (value) {
                setState(() {
                  maxChecked = value!;
                });
              }),
          Expanded(
              child: TextFormField(
                  initialValue: '4',
                  decoration: InputDecoration(
                    label: Text('최대 인원'),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSaved: (value) {
                    if (maxChecked && value!.isNotEmpty) {
                      ref
                          .read(postOrderNotifierProvider.notifier)
                          .setMyDeliverOption(maxMember: int.parse(value));
                    } else if (!maxChecked) {
                      ref
                          .read(postOrderNotifierProvider.notifier)
                          .setMyDeliverOption(maxMember: 999);
                    }
                  })),
        ],
      ),
    );
  }
}

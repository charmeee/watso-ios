import 'package:flutter/material.dart';

import '../../models/post_model.dart';

class OptionDesc extends StatelessWidget {
  const OptionDesc({Key? key, required this.optionGroups}) : super(key: key);
  final List<MenuOptionGroup> optionGroups;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      for (var group in optionGroups)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' · ${group.name} : ',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Flexible(
              child: Text(
                group.options.fold(
                    '',
                    (previousValue, element) =>
                        '$previousValue, ${element.name} [${element.price}원] '),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            )
          ],
        ),
    ]);
  }
}

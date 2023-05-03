import 'package:flutter/material.dart';

import '../../models/post_model.dart';

class OptionBoxDesc extends StatelessWidget {
  const OptionBoxDesc({Key? key, required this.group}) : super(key: key);
  final MenuOptionGroup group;

  @override
  Widget build(BuildContext context) {
    List<String> options =
        group.options.map((e) => '${e.name} [${e.price}원] ').toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' · ${group.name} : ',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Flexible(
          child: Text(
            options.join(', '),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        )
      ],
    );
  }
}

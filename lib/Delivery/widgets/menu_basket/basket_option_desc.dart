import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../common/optionDescBox.dart';

class OptionDesc extends StatelessWidget {
  const OptionDesc({Key? key, required this.optionGroups}) : super(key: key);
  final List<MenuOptionGroup> optionGroups;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      for (var group in optionGroups)
        if (group.options.isNotEmpty)
          OptionBoxDesc(
            group: group,
          ),
    ]);
  }
}

import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'menu_option_select_box.dart';

class MenuOptionGroupBox extends StatelessWidget {
  const MenuOptionGroupBox(
      {Key? key, required this.optionGroup, required this.selectedOptions})
      : super(key: key);
  final MenuOptionGroup optionGroup;
  final List<MenuOption> selectedOptions;

  @override
  Widget build(BuildContext context) {
    final bool isRadio =
        optionGroup.minOptionNum == 1 && optionGroup.maxOptionNum == 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(optionGroup.name, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(isRadio ? '필수' : '최대 ${optionGroup.maxOptionNum} 선택 가능'),
            ],
          ),
        ),
        if (optionGroup.options.isNotEmpty)
          for (var i = 0; i < optionGroup.options.length; i++)
            MenuOptionSelectBox(
              isRadio: isRadio,
              selectedOptions: selectedOptions,
              optionGroup: optionGroup,
              index: i,
            ),
      ],
    );
  }
}

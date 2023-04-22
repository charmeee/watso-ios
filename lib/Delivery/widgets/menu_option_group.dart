import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'menu_option_select_box.dart';

class MenuOptionGroupBox extends StatelessWidget {
  const MenuOptionGroupBox({Key? key, required this.optionGroup})
      : super(key: key);
  final MenuOptionGroup optionGroup;

  @override
  Widget build(BuildContext context) {
    final List<MenuOption> selectedOptions = optionGroup.options;
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
        if (selectedOptions.isNotEmpty)
          for (var i = 0; i < selectedOptions.length; i++)
            MenuOptionSelectBox(
              isRadio: isRadio,
              selectedOptions: selectedOptions,
              optionGroupId: optionGroup.id,
              index: i,
            ),
      ],
    );
  }
}

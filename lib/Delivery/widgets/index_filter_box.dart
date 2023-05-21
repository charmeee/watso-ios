import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/theme/text.dart';
import '../models/post_filter_model.dart';
import '../provider/post_list_provider.dart';

class FilterBox extends ConsumerWidget {
  const FilterBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _postHeader(),
          DropdownButton<PostPlaceFilter>(
            value: ref.watch(joinablePostFilterProvider),
            icon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: const Icon(
                Icons.arrow_drop_down,
              ),
            ),
            elevation: 16,
            style: const TextStyle(color: Colors.black87),
            underline: SizedBox(),
            onChanged: (value) =>
                ref.read(joinablePostFilterProvider.notifier).state = value!,
            items: PostPlaceFilter.values
                .map<DropdownMenuItem<PostPlaceFilter>>(
                    (PostPlaceFilter value) {
              return DropdownMenuItem<PostPlaceFilter>(
                value: value,
                child: Text(value.korName),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _postHeader() {
    return Text(
      '참여 가능한 배달',
      style: WatsoText.title,
    );
  }
}

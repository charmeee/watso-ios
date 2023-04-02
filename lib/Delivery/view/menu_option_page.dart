import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';
import 'package:sangsangtalk/Common/widget/floating_bottom_button.dart';

import '../../Common/commonType.dart';
import '../models/post_model.dart';
import '../repository/store_repository.dart';

class MenuOptionPage extends ConsumerStatefulWidget {
  const MenuOptionPage({
    Key? key,
    required this.storeId,
    required this.menuName,
  }) : super(key: key);
  final String storeId;
  final String menuName;

  @override
  ConsumerState createState() => _MenuOptionPageState();
}

class _MenuOptionPageState extends ConsumerState<MenuOptionPage> {
  LoadState loadState = LoadState.loading;
  Menu? menu;
  Map<String, List> selectedOptionsIdByGroupId = {};

  @override
  void initState() {
    super.initState();
    getDetailMenu();
  }

  getDetailMenu() {
    ref
        .read(storeRepositoryProvider)
        .getDetailMenu(widget.storeId, widget.menuName)
        .then((value) {
      setLeastOneOption(value);
      setState(() {
        menu = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loadState = LoadState.error;
      });
    });
  }

  setLeastOneOption(Menu value) {
    for (var element in value.groups!) {
      if (element.minOptionNum > 0) {
        selectedOptionsIdByGroupId[element.id] = [element.options[0].id];
      } else {
        selectedOptionsIdByGroupId[element.id] = [];
      }
    }
  }

  //MenuOptionGroup 로 해서
  @override
  Widget build(BuildContext context) {
    if (loadState == LoadState.loading && menu == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (menu == null || loadState == LoadState.error) {
      return Scaffold(
        body: const Center(child: Text('에러')),
      );
    }
    return Scaffold(
      appBar: customAppBar(
        context,
        title: menu!.name,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: menu!.groups!.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final MenuOptionGroup optionGroup = menu!.groups![index];
            final bool isRadio =
                optionGroup.minOptionNum == 1 && optionGroup.maxOptionNum == 1;
            //minOptionNum==maxOptionNum이면 radio
            //minOptionNum<maxOptionNum이면 checkbox
            final selectIcon =
                isRadio ? Icons.radio_button_checked : Icons.check_box_outlined;
            final unSelectIcon = isRadio
                ? Icons.radio_button_unchecked
                : Icons.check_box_outline_blank;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(optionGroup.name, style: const TextStyle(fontSize: 20)),
                Row(
                  children: [
                    Text('최소: ${optionGroup.minOptionNum}'),
                    const SizedBox(width: 10),
                    Text('최대: ${optionGroup.maxOptionNum}'),
                  ],
                ),
                if (optionGroup.options.isNotEmpty)
                  for (var i = 0; i < optionGroup.options.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isRadio) {
                                      selectedOptionsIdByGroupId[optionGroup
                                          .id] = [optionGroup.options[i].id];
                                    } else {
                                      selectedOptionsIdByGroupId[
                                              optionGroup.id]!
                                          .add(optionGroup.options[i].id);
                                    }
                                  });
                                },
                                icon: Icon(
                                    selectedOptionsIdByGroupId[optionGroup.id]!
                                            .contains(optionGroup.options[i].id)
                                        ? selectIcon
                                        : unSelectIcon)),
                            Text(optionGroup.options[i].name),
                          ],
                        ),
                        Text('${optionGroup.options[i].price}개'),
                      ],
                    ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 2,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customFloatingBottomButton(context,
          child: Text('메뉴 담기'), onPressed: () {}),
    );
  }
}

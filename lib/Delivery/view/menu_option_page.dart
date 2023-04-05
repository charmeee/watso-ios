import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';
import 'package:sangsangtalk/Common/widget/floating_bottom_button.dart';

import '../../Common/commonType.dart';
import '../models/post_model.dart';
import '../provider/menu_option_provider.dart';

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
        .read(menuOptionNotifierProvider.notifier)
        .setMenu(widget.storeId, widget.menuName)
        .then((value) {
      setState(() {
        menu = value;
      });
    }).onError((error, stackTrace) {
      log('getDetailMenu: $error');
      setState(() {
        loadState = LoadState.error;
      });
    });
  }

  //MenuOptionGroup 로 해서
  @override
  Widget build(BuildContext context) {
    OrderMenu? orderMenu = ref.watch(menuOptionNotifierProvider);
    int sumPrice = ref.watch(sumPriceProvider);
    // //orderMenu logging
    // if (orderMenu != null) {
    //   log('orderMenu: ${jsonEncode(orderMenu.toJson())}');
    // }
    if (loadState == LoadState.loading && menu == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (menu == null || loadState == LoadState.error || orderMenu == null) {
      return Scaffold(
        appBar: customAppBar(context, title: '메뉴 옵션'),
        body: const Center(child: Text('에러')),
      );
    }
    return Scaffold(
      appBar: customAppBar(
        context,
        title: menu!.name + ' : ' + menu!.price.toString() + '원',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: menu!.groups!.length + 1,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == menu!.groups!.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('개수', style: const TextStyle(fontSize: 20)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(menuOptionNotifierProvider.notifier)
                                .decreaseQuantity();
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text('${orderMenu.quantity}개'),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(menuOptionNotifierProvider.notifier)
                                .increaseQuantity();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            final MenuOptionGroup optionGroup = menu!.groups![index];
            List<MenuOption> selectedOptions =
                orderMenu.menu.groups![index].options;
            final bool isRadio =
                optionGroup.minOptionNum == 1 && optionGroup.maxOptionNum == 1;
            final selectIcon =
                isRadio ? Icons.radio_button_checked : Icons.check_box_outlined;
            final unSelectIcon = isRadio
                ? Icons.radio_button_unchecked
                : Icons.check_box_outline_blank;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(optionGroup.name,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(isRadio
                          ? '필수'
                          : '최대 ${optionGroup.maxOptionNum} 선택 가능'),
                    ],
                  ),
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
                                    ref
                                        .read(
                                            menuOptionNotifierProvider.notifier)
                                        .setOption(isRadio, optionGroup.id,
                                            optionGroup.options[i]);
                                  });
                                },
                                icon: Icon(selectedOptions.any((element) =>
                                        element.id == optionGroup.options[i].id)
                                    ? selectIcon
                                    : unSelectIcon)),
                            Text(optionGroup.options[i].name),
                          ],
                        ),
                        Text('${optionGroup.options[i].price}원'),
                      ],
                    ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 3,
            thickness: 2,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customFloatingBottomButton(context,
          child: Text('$sumPrice원 담기'), onPressed: () {
        ref.read(menuOptionNotifierProvider.notifier).addInMyOrder();
        Navigator.pop(context);
      }),
    );
  }
}
//todo: 메뉴 담기 기능
//todo: 개수 조절 마지막에 추가

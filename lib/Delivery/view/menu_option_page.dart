import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';

import '../../Common/commonType.dart';
import '../models/post_model.dart';
import '../provider/menu_option_provider.dart';
import '../repository/store_repository.dart';
import '../widgets/menu_option_add_btn.dart';
import '../widgets/menu_option_count_btn.dart';
import '../widgets/menu_option_group.dart';

class MenuOptionPage extends ConsumerStatefulWidget {
  const MenuOptionPage({
    Key? key,
    required this.storeId,
    required this.menuId,
    required this.menuName,
  }) : super(key: key);
  final String storeId;
  final String menuId;
  final String menuName;

  @override
  ConsumerState createState() => _MenuOptionPageState();
}

class _MenuOptionPageState extends ConsumerState<MenuOptionPage> {
  LoadState loadState = LoadState.loading;
  Menu? loadMenu;

  @override
  void initState() {
    super.initState();
    getDetailMenu();
  }

  getDetailMenu() {
    ref
        .read(storeRepositoryProvider)
        .getDetailMenu(widget.storeId, widget.menuId)
        .then((value) {
      setState(() {
        loadMenu = value;
        loadState = LoadState.success;
      });
      ref.read(menuOptionNotifierProvider.notifier).setMenu(value);
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
    if (loadState == LoadState.loading && loadMenu == null) {
      return Scaffold(
        appBar: customAppBar(
          context,
          title: widget.menuName,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (loadMenu == null || loadState == LoadState.error || orderMenu == null) {
      return Scaffold(
        appBar: customAppBar(context, title: '메뉴 옵션'),
        body: const Center(child: Text('에러')),
      );
    }
    Menu menu = loadMenu!;
    return Scaffold(
      appBar: customAppBar(
        context,
        title: menu.name,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: Text(
                        '기본 가격 : ${menu.price}원',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (menu.optionGroups != null)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MenuOptionGroupBox(
                                optionGroup: menu.optionGroups![index],
                                selectedOptions:
                                    orderMenu.menu.optionGroups![index].options,
                              ),
                              const Divider(
                                height: 3,
                                thickness: 2,
                              ),
                            ],
                          );
                        },
                        childCount: menu.optionGroups!.length,
                      ),
                    ),
                  MenuCountBtn(
                    orderMenu: orderMenu,
                  ),
                ],
              ),
            ),
          ),
          MenuOptionAddBtn(
            orderMenu: orderMenu,
          ),
        ],
      ),
    );
  }
}

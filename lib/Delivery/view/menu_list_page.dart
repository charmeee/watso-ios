import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/commonType.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

import '../../Common/widget/floating_bottom_button.dart';
import '../models/post_model.dart';
import '../models/post_request_model.dart';
import '../models/post_response_model.dart';
import '../provider/my_deliver_provider.dart';
import '../repository/store_repository.dart';
import 'menu_basket_page.dart';
import 'menu_option_page.dart';

class MenuListPage extends ConsumerStatefulWidget {
  const MenuListPage({
    Key? key,
    required this.storeId,
  }) : super(key: key);
  final String storeId;

  @override
  ConsumerState createState() => _MenuListPageState();
}

class _MenuListPageState extends ConsumerState<MenuListPage> {
  LoadState loadState = LoadState.loading;
  StoreMenus? storeMenus;

  @override
  void initState() {
    super.initState();
    getStoreMenuList();
  }

  getStoreMenuList() {
    ref
        .read(storeRepositoryProvider)
        .getStoreMenuList(widget.storeId)
        .then((value) {
      setState(() {
        storeMenus = value;
        loadState = LoadState.success;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loadState = LoadState.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    PostOrder myOrder = ref.watch(myDeliveryNotifierProvider);
    if (loadState == LoadState.loading && storeMenus == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (storeMenus == null ||
        loadState == LoadState.error ||
        (loadState != LoadState.loading &&
            myOrder.store.id != widget.storeId)) {
      return Scaffold(
        body: const Center(child: Text('에러')),
      );
    }
    List<OrderMenu> orderMenus = myOrder.order.orderLines;
    return Scaffold(
      appBar: customAppBar(context, title: storeMenus!.name),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('예상 배달비 : ${storeMenus!.fee}원',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54)),
                        Text('최소 배달 금액 : ${storeMenus!.minOrder}원',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, indexOfSection) {
                      List<MenuSection> menuSection = storeMenus!.menuSection;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            color: Colors.grey[200],
                            child: Text(menuSection[indexOfSection].section),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: menuSection[indexOfSection].menus.length,
                            itemBuilder: (context, indexOfMenu) {
                              Menu menu = menuSection[indexOfSection]
                                  .menus[indexOfMenu];
                              return ListTile(
                                title: Text(
                                  menu.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: Text(
                                  '${menu.price}원',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  //navigate to menu option page
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MenuOptionPage(
                                        storeId: widget.storeId,
                                        menuId: menu.id,
                                        menuName: menu.name,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(height: 2);
                            },
                          ),
                        ],
                      );
                    },
                    childCount: storeMenus!.menuSection.length,
                  ),
                ),
              ],
            ),
          ),
          orderMenus.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: customFloatingBottomButton(
                    context,
                    child: floatingButtonLabel((orderMenus.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.quantity)).toString()),
                    onPressed: navigateToBasket,
                  ),
                )
              : const SizedBox(height: 32),
        ],
      ),
    );
  }

  navigateToBasket() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MenuBasketPage()),
    );
  }

  Widget floatingButtonLabel(badgeContent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Badge(
            badgeContent: Text(badgeContent),
            child: const Icon(Icons.shopping_cart)),
        const SizedBox(width: 16),
        Text(
          '장바구니',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

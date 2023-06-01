import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';
import 'package:watso/Common/widget/primary_button.dart';

import '../models/post_model.dart';
import '../provider/order_option_provider.dart';
import '../widgets/common/store_detail_box.dart';
import '../widgets/order_set_place.dart';
import '../widgets/order_set_recuit.dart';
import '../widgets/order_set_store.dart';
import '../widgets/order_set_time.dart';
import 'menu_list_page.dart';

final _recruitFormKey = GlobalKey<FormState>();

class OrderSetPage extends ConsumerStatefulWidget {
  const OrderSetPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _OrderSetPageState();
}

class _OrderSetPageState extends ConsumerState<OrderSetPage> {
  @override
  Widget build(BuildContext context) {
    final OrderOption myOrderOption = ref.watch(orderOptionNotifierProvider);
    return Scaffold(
        appBar: customAppBar(
          context,
          title: '배달왔소 생성',
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TimeSelector(
                          orderTime: myOrderOption.orderTime,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        StoreSelector(
                          myStore: myOrderOption.store,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        PlaceSelector(
                          place: myOrderOption.place,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RecuitNumSelector(
                          recruitFormKey: _recruitFormKey,
                          minMember: myOrderOption.minMember,
                          maxMember: myOrderOption.maxMember,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (myOrderOption.store.id.isNotEmpty) ...{
                          StoreDetailBox(
                            store: myOrderOption.store,
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: primaryButton(
                    padding: EdgeInsets.all(18),
                    onPressed: () {
                      if (!_recruitFormKey.currentState!.validate()) return;
                      _recruitFormKey.currentState!.save();
                      log(myOrderOption.minMember.toString());
                      log(myOrderOption.maxMember.toString());
                      log(myOrderOption.store.fee.toString());
                      log(myOrderOption.store.id.toString());
                      log(myOrderOption.place.toString());
                      if (!myOrderOption.isStoreSelected ||
                          !myOrderOption.isMemberLogical ||
                          !myOrderOption.isOrderTimeLogical) {
                        String? storeError =
                            !myOrderOption.isStoreSelected ? '가게를 선택하세요' : null;
                        String? memberError = !myOrderOption.isMemberLogical
                            ? '최소인원이 최대인원보다 클 수 없습니다.'
                            : null;
                        String? timeError = !myOrderOption.isOrderTimeLogical
                            ? '주문시간은 최소 10분 뒤 부터 가능합니다.'
                            : null;
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text('에러'),
                              content: Text(
                                  storeError ?? memberError ?? timeError ?? ''),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MenuListPage(storeId: myOrderOption.store.id)),
                      );
                    },
                    text: '주문하기',
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

import '../provider/my_deliver_provider.dart';
import '../widgets/order_set_place.dart';
import '../widgets/order_set_recuit.dart';
import '../widgets/order_set_store.dart';
import '../widgets/order_set_time.dart';
import 'menu_list_page.dart';

final _recruitFormKey = GlobalKey<FormState>();

class OrderSetPage extends ConsumerWidget {
  const OrderSetPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: '배달왔소 생성',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TimeSelector(),
                SizedBox(
                  height: 15,
                ),
                StoreSelector(),
                SizedBox(
                  height: 15,
                ),
                PlaceSelector(),
                SizedBox(
                  height: 15,
                ),
                RecuitNumSelector(
                  recruitFormKey: _recruitFormKey,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  _recruitFormKey.currentState!.save();
                  final postState = ref.read(myDeliveryNotifierProvider);
                  log(postState.minMember.toString());
                  log(postState.maxMember.toString());
                  log(postState.store.fee.toString());
                  log(postState.store.id.toString());
                  log(postState.place.toString());

                  if (!postState.isStoreSelected ||
                      !postState.isMemberLogical ||
                      !postState.isOrderTimeLogical) {
                    String? storeError =
                        !postState.isStoreSelected ? '가게를 선택하세요' : null;
                    String? memberError = !postState.isMemberLogical
                        ? '최소인원이 최대인원보다 클 수 없습니다.'
                        : null;
                    String? timeError = !postState.isOrderTimeLogical
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
                            MenuListPage(storeId: postState.store.id)),
                  );
                },
                child: Text("주문하기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

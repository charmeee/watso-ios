import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';
import 'package:watso/Common/widget/primary_button.dart';

import '../models/post_request_model.dart';
import '../provider/my_deliver_provider.dart';
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
    final PostOrder myPostState = ref.watch(myDeliveryNotifierProvider);
    return Scaffold(
        appBar: customAppBar(
          context,
          title: '배달왔소 생성',
        ),
        body: Padding(
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
                        orderTime: myPostState.orderTime,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      StoreSelector(
                        myStore: myPostState.store,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      PlaceSelector(
                        place: myPostState.place,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RecuitNumSelector(
                        recruitFormKey: _recruitFormKey,
                        minMember: myPostState.minMember,
                        maxMember: myPostState.maxMember,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (myPostState.store.id.isNotEmpty) ...{
                        StoreDetailBox(
                          store: myPostState.store,
                        ),
                      },
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: primaryButton(
                  padding: EdgeInsets.all(18),
                  onPressed: () {
                    if (!_recruitFormKey.currentState!.validate()) return;
                    _recruitFormKey.currentState!.save();
                    log(myPostState.minMember.toString());
                    log(myPostState.maxMember.toString());
                    log(myPostState.store.fee.toString());
                    log(myPostState.store.id.toString());
                    log(myPostState.place.toString());
                    if (!myPostState.isStoreSelected ||
                        !myPostState.isMemberLogical ||
                        !myPostState.isOrderTimeLogical) {
                      String? storeError =
                          !myPostState.isStoreSelected ? '가게를 선택하세요' : null;
                      String? memberError = !myPostState.isMemberLogical
                          ? '최소인원이 최대인원보다 클 수 없습니다.'
                          : null;
                      String? timeError = !myPostState.isOrderTimeLogical
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
                              MenuListPage(storeId: myPostState.store.id)),
                    );
                  },
                  text: '주문하기',
                ),
              )
            ],
          ),
        ));
  }
}

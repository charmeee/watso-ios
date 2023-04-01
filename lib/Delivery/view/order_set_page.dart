import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

import '../widgets/order_set_place.dart';
import '../widgets/order_set_store.dart';
import '../widgets/order_set_time.dart';
import 'menu_list_page.dart';

class OrderSetPage extends StatefulWidget {
  @override
  _OrderSetPageState createState() => _OrderSetPageState();
}

class _OrderSetPageState extends State<OrderSetPage> {
  final _recruitFormKey = GlobalKey<FormState>();

  String minRecruit = '';
  String maxRecruit = '';
  bool minChecked = false;
  bool maxChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: '배달톡 생성',
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
                Row(
                  children: [
                    Text(
                      "모집 인원 선택 ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "(선택 사항)",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Form(
                  key: _recruitFormKey,
                  child: Row(
                    children: [
                      Checkbox(
                          value: minChecked,
                          onChanged: (value) {
                            setState(() {
                              minChecked = value!;
                            });
                          }),
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                          label: Text('최소 인원'),
                        ),
                        initialValue: '2',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSaved: (value) => minRecruit = value!,
                      )),
                      Checkbox(
                          value: maxChecked,
                          onChanged: (value) {
                            setState(() {
                              maxChecked = value!;
                            });
                          }),
                      Expanded(
                          child: TextFormField(
                        initialValue: '4',
                        decoration: InputDecoration(
                          label: Text('최대 인원'),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSaved: (value) => maxRecruit = value!,
                      )),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  _recruitFormKey.currentState!.save();
                  var minRecruitNum = int.tryParse(minRecruit) ?? 1;
                  var maxRecruitNum = int.tryParse(maxRecruit) ?? 999;
                  if (minChecked &&
                      maxChecked &&
                      minRecruitNum > maxRecruitNum) {
                    //alert error
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      // false = user must tap button, true = tap outside dialog
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('에러'),
                          content: Text('최소인원이 최대인원보다 클 수 없습니다.'),
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
                  if (minChecked) {
                    log("minRecruitNum: $minRecruitNum");
                  }
                  if (maxChecked) {
                    log("maxRecruitNum: $maxRecruitNum");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuListPage()),
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

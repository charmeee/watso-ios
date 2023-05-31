import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';
import 'package:watso/Common/widget/primary_button.dart';

import '../../Common/theme/text.dart';
import '../models/post_request_model.dart';
import '../provider/post_list_provider.dart';
import '../repository/post_repository.dart';
import '../widgets/common/store_detail_box.dart';
import '../widgets/order_set_place.dart';
import '../widgets/order_set_recuit.dart';
import '../widgets/order_set_time.dart';

final _recruitEditFormKey = GlobalKey<FormState>();

class OptionEditPage extends ConsumerStatefulWidget {
  const OptionEditPage({
    Key? key,
    required this.postData,
  }) : super(key: key);
  final PostOrder postData;

  @override
  ConsumerState<OptionEditPage> createState() => _OptionEditPageState();
}

class _OptionEditPageState extends ConsumerState<OptionEditPage> {
  late PostOrder postData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postData = widget.postData;
  }

  setPlace(String place) {
    setState(() {
      postData.place = place;
    });
  }

  setMinMaxMember({int? min, int? max}) {
    if (min != null) {
      setState(() {
        postData.minMember = min;
      });
    }
    if (max != null) {
      setState(() {
        postData.maxMember = max;
      });
    }
  }

  setOrderTime(DateTime time) {
    if (time.isBefore(nowDate)) {
      return;
    }
    setState(() {
      postData.orderTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
          context,
          title: '배달왔소 수정',
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
                          orderTime: postData.orderTime,
                          setOrderTime: setOrderTime,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "가게 선택",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(postData.store.name,
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        SizedBox(
                          height: 15,
                        ),
                        PlaceSelector(
                          place: postData.place,
                          setPlace: setPlace,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RecuitNumSelector(
                          recruitFormKey: _recruitEditFormKey,
                          minMember: postData.minMember,
                          maxMember: postData.maxMember,
                          setMinMaxMember: setMinMaxMember,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (postData.store.id.isNotEmpty) ...{
                          StoreDetailBox(
                            store: postData.store,
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: primaryButton(
                    padding: EdgeInsets.all(18),
                    onPressed: () {
                      _recruitEditFormKey.currentState!.save();

                      if (!postData.isMemberLogical) {
                        String memberError = '최소인원이 최대인원보다 클 수 없습니다.';

                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text('에러'),
                              content: Text(memberError),
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
                      ref
                          .read(postRepositoryProvider)
                          .updatePost(postData.postId!, postData.editableInfo)
                          .then((value) {
                        ref.invalidate(postDetailProvider(postData.postId!));
                        Navigator.of(context).pop();
                      }).onError((error, stackTrace) => showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: Text('에러'),
                                  content: Text(error.toString()),
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
                              }));
                    },
                    text: '수정하기',
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

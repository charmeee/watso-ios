import 'package:flutter/material.dart';
import 'package:watso/Common/theme/color.dart';
import 'package:watso/Common/theme/text.dart';

import '../../models/post_model.dart';
import '../post_page/modify_fee_dialog.dart';
import 'information_tile.dart';

class StoreDetailBox extends StatelessWidget {
  const StoreDetailBox(
      {Key? key,
      required this.store,
      required this.peopleNum,
      this.fee,
      this.postId,
      this.isOwner = false})
      : super(key: key);
  final Store store;
  final int peopleNum;
  final int? fee;
  final bool isOwner;
  final String? postId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text(
              "가게정보",
              style: WatsoText.title,
            ),
          ),
          InformationTile(
              icon: Icons.store, title: "가게이름", content: store.name),
          InformationTile(
            icon: Icons.phone,
            title: "가게번호",
            content: store.phoneNumber,
          ),
          InformationTile(
              icon: Icons.attach_money,
              title: "배달비",
              widget: Row(
                children: [
                  Text("${fee ?? store.fee}원"),
                  SizedBox(
                    width: 10,
                  ),
                  if (isOwner && postId != null)
                    InkWell(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          '수정',
                          style: TextStyle(
                            color: WatsoColor.primary,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => ModifyFeeDialog(
                                  postId: postId!,
                                  storeFee: fee ?? store.fee,
                                ));
                      },
                    )
                ],
              )),
          InformationTile(
            icon: Icons.info,
            title: "배달비 상세 정보",
            content: store.note.isNotEmpty
                ? store.note.map((x) => '﹒$x').join('\n')
                : '없음',
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

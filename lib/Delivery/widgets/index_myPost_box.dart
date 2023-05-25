import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:watso/Common/theme/text.dart';

import '../models/post_response_model.dart';
import '../provider/post_list_provider.dart';
import 'index_common_listTile.dart';

class MyPostBox extends ConsumerWidget {
  const MyPostBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ResponsePost>> myPostList = ref.watch(myPostListProvider);
    return SliverToBoxAdapter(
      child: myPostList.when(
          data: (data) {
            if (data.isEmpty) {
              return SizedBox(height: 0);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  //참여한 배닱톡
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _myPostHeader(),
                    _myPostList(data),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
          error: (err, track) => Center(child: Text('에러')),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }

  Widget _myPostHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
      child: Text(
        '참여한 배달',
        style: WatsoText.title,
      ),
    );
  }

  Widget _myPostList(List<ResponsePost> data) {
    DateTime beforeTime = DateTime(2000, 1, 1);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final nowDataDate = data[index].orderTime;
        final bool diffDate =
            nowDataDate.difference(beforeTime).inDays != 0; //이전 데이터와 날짜가 다른지
        beforeTime = nowDataDate;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (diffDate) ...{
              Divider(height: 1),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  DateFormat("M월 d일 E요일", 'ko').format(nowDataDate),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Divider(height: 1),
            },
            indexCommonListTile(data[index], context),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
        );
      },
    );
  }
}

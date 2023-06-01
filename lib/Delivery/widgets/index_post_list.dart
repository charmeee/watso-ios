import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/util/date_util.dart';
import '../models/post_response_model.dart';
import '../provider/post_list_provider.dart';
import 'index_common_listTile.dart';

class PostList extends ConsumerWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ResponsePost>> joinablePostList =
        ref.watch(joinablePostListProvider);
    AsyncValue<List<ResponsePost>> myPostList = ref.watch(myPostListProvider);
    DateTime beforeTime = DateTime(2000, 1, 1);
    return SizedBox(
      child: joinablePostList.when(data: (data) {
        if (data.isEmpty &&
            !myPostList.isLoading &&
            myPostList.value!.isEmpty) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                //Center(child: Text('참여 가능한 배달이 없어요 ㅠ.ㅠ\n같이 배달할 사람을 직접 모아보는건 어때요?')))
                children: [
                  Text('참여 가능한 배달이 없어요 ㅠ.ㅠ'),
                  Text('같이 배달할 사람을 직접 모아보는건 어때요?')
                ],
              ));
        }
        return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final nowData = data[index];
              final nowDataDate = nowData.orderOption.orderTime;
              final bool diffDate =
                  !isSameDate(nowDataDate, beforeTime); //이전 데이터와 날짜가 다른지
              beforeTime = nowDataDate;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (diffDate) ...{
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Text(
                        getStringDate(nowDataDate),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                    Divider(height: 1),
                  },
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: indexCommonListTile(nowData, context),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 1);
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: data.length);
      }, error: (error, stackTrace) {
        return SizedBox(
            child: Center(
                child: Text(
              '에러',
              style: TextStyle(fontSize: 20),
            )),
            height: 300);
      }, loading: () {
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}

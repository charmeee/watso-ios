import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_response_model.dart';
import '../provider/post_list_provider.dart';
import 'index_common_listTile.dart';

class MyPostBox extends ConsumerWidget {
  const MyPostBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ResponsePostList>> myPostList =
        ref.watch(myPostListProvider);
    return myPostList.when(
        data: (data) {
          if (data.isEmpty) {
            return const SliverToBoxAdapter(child: SizedBox(height: 0));
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
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
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(
        '참여한 배달톡',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _myPostList(List<ResponsePost> data) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return indexCommonListTile(data[index], context);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}

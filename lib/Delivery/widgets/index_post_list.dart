import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_response_model.dart';
import '../provider/post_list_provider.dart';
import 'index_common_listTile.dart';

class PostList extends ConsumerWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ResponsePost>> joinablePostList = ref.watch(
        joinablePostListProvider);
    return SizedBox(
      child: joinablePostList.when(data: (data) {
        return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final nowData = data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: indexCommonListTile(nowData, context),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
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

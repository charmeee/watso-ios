import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/commonType.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';
import '../repository/post_repository.dart';
import 'index_common_listTile.dart';

class PostList extends ConsumerStatefulWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
  List<ResponsePost> postData = [];
  LoadState loadState = LoadState.loading;

  @override
  void initState() {
    super.initState();
    getPostData();
  }

  getPostData() {
    ref
        .read(postRepositoryProvider)
        .getDeliveryList(PostFilter.joinable)
        .then((value) {
      setState(() {
        postData = value;
        loadState = LoadState.success;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loadState = LoadState.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadState == LoadState.loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (loadState == LoadState.error) {
      return SizedBox(
          child: Center(
              child: Text(
            '에러',
            style: TextStyle(fontSize: 20),
          )),
          height: 300);
    }
    if (postData.isEmpty) {
      return SizedBox(
          child: Center(
              child: Text(
            '직접 배달톡을 추가해 보세요',
            style: TextStyle(fontSize: 20),
          )),
          height: 300);
    }

    //to ListView
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final data = postData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: indexCommonListTile(data, context),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: postData.length);
  }
}

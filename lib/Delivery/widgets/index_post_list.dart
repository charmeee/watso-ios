import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/commonType.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';
import '../repository/postOrder_repository.dart';

class PostList extends ConsumerStatefulWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
  List<ResponsePostList> postData = [];
  LoadState loadState = LoadState.loading;

  @override
  void initState() {
    super.initState();
    getPostData();
  }

  getPostData() {
    ref
        .read(postOrderRepositoryProvider)
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
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    }
    if (loadState == LoadState.error) {
      return const SliverToBoxAdapter(
          child: SizedBox(
              child: Center(
                  child: Text(
                '에러',
                style: TextStyle(fontSize: 20),
              )),
              height: 300));
    }
    if (postData.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
            child: Center(
                child: Text(
              '직접 배달톡을 추가해 보세요',
              style: TextStyle(fontSize: 20),
            )),
            height: 300),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final data = postData[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Card(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.network(
                          'http://www.ikbc.co.kr/data/kbc/cache/2022/08/02/kbc202208020053.800x.9.png',
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              data.title.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(data.place.toString()),
                            Text(data.orderTime.toString()),
                            Text(data.nickname.toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: postData.length,
        ),
      ),
    );
  }
}

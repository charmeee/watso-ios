import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/post_response_model.dart';
import '../post_list_provider.dart';

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
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text(
                        '참여한 배달톡',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover)),
                          title: Text(data[index].title),
                          subtitle: Text(data[index].nickname),
                          trailing: Text(DateFormat('MM/dd HH:mm')
                              .format(data[index].orderTime)),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
        error: (err, track) =>
            SliverToBoxAdapter(child: Center(child: Text('에러'))),
        loading: () => SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())));
  }
}

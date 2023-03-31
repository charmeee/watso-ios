import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../Common/commonType.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';
import '../repository/postOrder_repository.dart';

class MyPostBox extends ConsumerStatefulWidget {
  const MyPostBox({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPostBox> createState() => _MyPostBoxState();
}

class _MyPostBoxState extends ConsumerState<MyPostBox> {
  List<ResponsePostList> myPostData = [];
  LoadState loadState = LoadState.loading;

  @override
  void initState() {
    super.initState();
    getMyPostData();
  }

  getMyPostData() {
    //는 provider로 따로 관리해야 할지도?
    ref
        .read(postOrderRepositoryProvider)
        .getDeliveryList(PostFilter.joined)
        .then((value) {
      setState(() {
        myPostData = value;
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
    //case 를 loading, success&&myPostData.length==0, success&&myPostData.length>0, error 로 나눠서 처리해야 함
    if (loadState == LoadState.loading) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    }
    if (loadState == LoadState.error) {
      return const SliverToBoxAdapter(child: Center(child: Text('에러')));
    }
    if (myPostData.isEmpty) {
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myPostData.length,
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
                    title: Text(myPostData[index].title),
                    subtitle: Text(myPostData[index].nickname),
                    trailing: Text(DateFormat('MM/dd HH:mm')
                        .format(myPostData[index].orderTime)),
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
  }
}

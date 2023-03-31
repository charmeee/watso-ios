//Main delivery page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/commonType.dart';

import '../../Common/widget/appbar.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';
import '../repository/postOrder_repository.dart';
import 'order_set_page.dart';

const List<String> list = <String>['최근 등록', '가까운 시간', 'Three', 'Four'];

class DeliveryMainPage extends ConsumerStatefulWidget {
  const DeliveryMainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DeliveryMainPageState();
}

class _DeliveryMainPageState extends ConsumerState<DeliveryMainPage> {
  List<ResponsePostList> postData = [];
  LoadState loadState = LoadState.loading;

  @override
  void initState() {
    super.initState();
    //postData = test.map((data) => ResponsePostList.fromJson(data)).toList();
    getPostData();
  }

  getPostData() {
    ref.read(postOrderRepositoryProvider).getDeliveryList().then((value) {
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
    String dropdownValue = list.first;
    return Scaffold(
      appBar: customAppBar(context,
          title: '배달톡', action: actionButtons(), titleSize: 30),
      body: CustomScrollView(
        slivers: [
          //구분생각을 해보겟습니다.
          SliverToBoxAdapter(
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
                      itemCount: 2,
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
                          title: Text('제목들'),
                          subtitle: Text('가게이름'),
                          trailing: Text('15:30'),
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    DropdownButton(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: SizedBox(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        // setState(() {
                        //   dropdownValue = value!;
                        // });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 8),
                    DropdownButton(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: SizedBox(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        // setState(() {
                        //   dropdownValue = value!;
                        // });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )),
            ),
          ),
          SliverPadding(
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderSetPage(),
            ),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}

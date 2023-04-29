//Main delivery page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Auth/view/setting_page.dart';

import '../../Common/widget/appbar.dart';
import '../widgets/index_filter_box.dart';
import '../widgets/index_myPost_box.dart';
import '../widgets/index_post_list.dart';
import 'history_page.dart';
import 'order_set_page.dart';

class DeliveryMainPage extends ConsumerStatefulWidget {
  const DeliveryMainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DeliveryMainPageState();
}

class _DeliveryMainPageState extends ConsumerState<DeliveryMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: '배달톡', action: actionButtons(), titleSize: 30),
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          //구분생각을 해보겟습니다.
          const MyPostBox(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilterBox(),
                    Divider(height: 1),
                    PostList(),
                  ],
                ),
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
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  List<Widget> actionButtons() {
    return [
      IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliverHistoryPage(),
              ),
            );
          },
          icon: Icon(Icons.timelapse_outlined)),
      IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingPage(),
              ),
            );
          },
          icon: Icon(Icons.settings)),
    ];
  }
}

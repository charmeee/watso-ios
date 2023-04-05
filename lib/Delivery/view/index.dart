//Main delivery page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/appbar.dart';
import '../widgets/index_filter_box.dart';
import '../widgets/index_myPost_box.dart';
import '../widgets/index_post_list.dart';
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
          FilterBox(),
          PostList(),
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
      IconButton(onPressed: () {}, icon: Icon(Icons.timelapse_outlined)),
      IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
    ];
  }
}

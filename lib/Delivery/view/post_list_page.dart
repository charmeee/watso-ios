//Main delivery page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Auth/view/setting_page.dart';

import '../../Common/widget/appbar.dart';
import '../provider/post_list_provider.dart';
import '../widgets/index_filter_box.dart';
import '../widgets/index_myPost_box.dart';
import '../widgets/index_post_list.dart';
import 'history_page.dart';
import 'order_set_page.dart';

class DeliveryMainPage extends ConsumerWidget {
  const DeliveryMainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(context,
          title: '배달왔소', action: actionButtons(context), titleSize: 30),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(joinablePostListProvider);
          ref.invalidate(myPostListProvider);
        },
        child: CustomScrollView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            ),
          ],
        ),
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

  List<Widget> actionButtons(context) {
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

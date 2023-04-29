import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/appbar.dart';

class DeliverHistoryPage extends ConsumerWidget {
  const DeliverHistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(context, title: '배달톡 참가 내역'),
      body: Center(
        child: Text('배달톡 참가 내역'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: '설정'),
      body: Center(
        child: Text('설정'),
      ),
    );
  }
}

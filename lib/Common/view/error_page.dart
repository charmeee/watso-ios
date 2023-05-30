//errorpage

import 'package:flutter/material.dart';
import 'package:watso/Common/widget/appbar.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.error}) : super(key: key);
  final Exception error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: '에러', isCenter: true),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('에러'),
            Text('잠시 후 다시 시도해주세요.'),
            Text(error.toString()),
          ],
        )));
  }
}

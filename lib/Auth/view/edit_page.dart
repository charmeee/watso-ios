import 'package:flutter/material.dart';
import 'package:watso/Common/widget/appbar.dart';

import '../widgets/accountNumberEditBox.dart';
import '../widgets/nickname_edit_box.dart';

class UserEditPage extends StatelessWidget {
  const UserEditPage({
    Key? key,
    required this.title,
    required this.field,
  }) : super(key: key);
  final String title;
  final String field;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: title),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (field == 'nickname') NickNameEditBox(),
            if (field == 'accountNumber') AccountEditBox(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:watso/Common/widget/appbar.dart';

import '../widgets/account_edit_box.dart';
import '../widgets/nickname_edit_box.dart';
import '../widgets/password_edit_box.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: _buildEditBox(field),
          ),
        ),
      ),
    );
  }

  Widget _buildEditBox(String field) {
    switch (field) {
      case 'nickname':
        return NickNameEditBox();
      case 'accountNumber':
        return AccountEditBox();
      case 'password':
        return PasswordEditBox();
      default:
        return SizedBox(
          height: 10,
        );
    }
  }
}

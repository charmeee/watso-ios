import 'package:flutter/material.dart';

import '../../Common/widget/appbar.dart';
import '../widgets/signUpForm.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: '회원가입'),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SignUpForm(),
      )),
    );
  }
}

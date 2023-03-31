import 'package:flutter/material.dart';

import '../../Common/widget/appbar.dart';
import '../widgets/signUpForm.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SignUpForm(),
      )),
    );
  }
}

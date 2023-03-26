import 'package:flutter/material.dart';

import '../widgets/signUpForm.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
            child: SignUpForm(),
          )
      ),

    );
  }
}
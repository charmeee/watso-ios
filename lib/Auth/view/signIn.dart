//signIn page 로그인

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/signInForm.dart';

class SignInPage extends ConsumerWidget {
  SignInPage({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2)),
              Center(
                child: SizedBox(
                  height: 100,
                  child:Column(
                    children: [
                      Text(
                        '생자대 생활 정보톡',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                )

              ),

              Padding(padding: EdgeInsets.only(top: 10)),

              SignInForm(),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
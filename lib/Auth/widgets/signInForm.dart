import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth_provider.dart';
import '../view/signUp.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInForm> createState() => _EmailSignInState();
}

class _EmailSignInState extends ConsumerState<SignInForm> {
  final _signInFormKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primaryColor: Colors.indigo,
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: Colors.indigo,
                fontSize: 15,
              ))),
      child: Form(
        key: _signInFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '아이디를 입력해주세요'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) => username = value!,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호를 입력해주세요'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }

                return null;
              },
              onSaved: (value) => password = value!,
              keyboardType: TextInputType.text,
              inputFormatters: [//include ! ~ @ ?
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@~?]')),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed:() async {
                  if(_signInFormKey.currentState!.validate()){
                    _signInFormKey.currentState!.save();
                     await ref.read(userNotifierProvider.notifier).signIn( username,password)
                         .onError((error, stackTrace) {
                           var message = (error is FormatException) ?error.message:error.toString();
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                     }

                     );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.all(20),
                ),
                child: Text("로그인하기", style: TextStyle(color: Colors.white))),
            SizedBox(
                height: 10
            ),
            TextButton(
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.all(20),
                ),
                child: Text("회원가입", style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
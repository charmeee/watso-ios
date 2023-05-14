import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/primary_button.dart';
import '../../Common/widget/secondary_button.dart';
import '../../Common/widget/underline_textformfield.dart';
import '../provider/user_provider.dart';
import '../view/find_account_page.dart';
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
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          underlineTextFromField(
            label: '아이디',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '아이디를 입력해주세요';
              }
              return null;
            },
            onSaved: (value) => username = value!,
          ),
          SizedBox(
            height: 10,
          ),
          underlineTextFromField(
            label: '비밀번호',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }

              return null;
            },
            onSaved: (value) => password = value!,
            keyboardType: TextInputType.text,
            inputFormatters: [
              //include ! ~ @ ?
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@~?]')),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          primaryButton(
              onPressed: () async {
                if (_signInFormKey.currentState!.validate()) {
                  _signInFormKey.currentState!.save();
                  await ref
                      .read(userNotifierProvider.notifier)
                      .signIn(username, password)
                      .onError((error, stackTrace) {
                    var message = (error is FormatException)
                        ? error.message
                        : error.toString();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  });
                }
              },
              padding: EdgeInsets.all(20),
              text: "로그인"),
          SizedBox(height: 10),
          secondaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpPage(),
                ),
              );
            },
            padding: EdgeInsets.all(20),
            borderWidth: 2,
            text: "회원가입",
          ),
          TextButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FindAccountPage(),
                  ),
                );
              },
              child: Text("아이디 / 비밀번호 찾기",
                  style: TextStyle(
                    color: Colors.black54,
                  )))
        ],
      ),
    );
  }
}

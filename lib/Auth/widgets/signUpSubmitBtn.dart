import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Auth/models/user_request_model.dart';

import '../../Common/widget/primary_button.dart';
import '../repository/user_repository.dart';

class SignUpSubmitButton extends ConsumerWidget {
  const SignUpSubmitButton({
    Key? key,
    required this.signUpFormKey,
    required this.username,
    required this.nickname,
    required this.name,
    required this.email,
    required this.password,
    required this.account,
    required this.token,
  }) : super(key: key);
  final GlobalKey<FormState> signUpFormKey;
  final String username;
  final String nickname;
  final String name;
  final String email;
  final String password;
  final String account;
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return primaryButton(
      padding: const EdgeInsets.symmetric(vertical: 15),
      onPressed: () {
        if (signUpFormKey.currentState!.validate()) {
          log('username: $username, nickname: $nickname,name: $name, email: $email, password: $password, account: $account, token: $token');
          //api 호출

          ref
              .read(userRepositoryProvider)
              .signUp(username, nickname, name, password, email + rootEmail,
                  account, token)
              .then((value) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('회원가입이 완료되었습니다'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('확인'))
                    ],
                  );
                }).then((value) => Navigator.pop(context));
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          });
        }
      },
      child: Text('회원가입'),
    );
  }
}

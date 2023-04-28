import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Auth/models/user_request_model.dart';

import '../repository/user_repository.dart';

class ValidCheckButton extends ConsumerWidget {
  const ValidCheckButton(
      {Key? key,
      required this.emailValidationCode,
      required this.checkEmailValid,
      required this.setValidFlag,
      required this.email})
      : super(key: key);

  final String emailValidationCode;
  final String email;
  final bool checkEmailValid;
  final Function(bool, String) setValidFlag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[300],
      ),
      onPressed: () {
        ref
            .read(userRepositoryProvider)
            .checkValidEmail(email + rootEmail, emailValidationCode)
            .then((value) {
          setValidFlag(true, value);
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('인증번호가 일치하지 않습니다.')));
        });
      },
      child: Text(checkEmailValid ? '인증완료' : '인증'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_request_model.dart';
import 'duplicateCheckBtn.dart';
import 'signUpSubmitBtn.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _signUpFormKey = GlobalKey<FormState>();

  String username = '';
  String nickname = '';
  String password = '';
  String email = '';
  String account = '';

  setValid(DuplicateCheckField field, bool value) {
    setState(() {
      switch (field) {
        case DuplicateCheckField.username:
          checkUsername = value;
          break;
        case DuplicateCheckField.nickname:
          checkNickname = value;
          break;
        case DuplicateCheckField.email:
          checkEmail = value;
          break;
      }
    });
  }

  bool checkUsername = false;
  bool checkNickname = false;
  bool checkEmail = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("회원가입",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '아이디'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디 입력해주세요';
                    }
                    if (!checkUsername) {
                      return '아이디 중복검사를 해주세요';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9!@~?]')),
                  ],
                ),
              ),
              SizedBox(width: 15),
              DuplicateCheckButton(
                field: DuplicateCheckField.username,
                setValid: setValid,
                value: username,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '닉네임'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요';
                    }
                    if (!checkNickname) {
                      return '닉네임 중복검사를 해주세요';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      nickname = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 15),
              DuplicateCheckButton(
                field: DuplicateCheckField.nickname,
                setValid: setValid,
                value: nickname,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: '이메일',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    if (!checkEmail) {
                      return '이메일 중복검사를 해주세요';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Text(rootEmail),
              SizedBox(width: 25),
              DuplicateCheckButton(
                field: DuplicateCheckField.email,
                setValid: setValid,
                value: email,
              ),
            ],
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(labelText: '비밀번호'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '숫자,영대소문자,특수문자를 사용할 수 있습니다';
              }
              if (value.length < 6) {
                return '비밀번호는 6자 이상이어야 합니다';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            inputFormatters: [
              //include ! ~ @ ?
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@~?]')),
            ],
          ),
          TextFormField(
            //account
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: '계좌번호',
              hintText: '농협 12341111111',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '계좌번호를 입력해주세요';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                account = value;
              });
            },
            keyboardType: TextInputType.text,
            inputFormatters: [
              //number and korean and space
              FilteringTextInputFormatter.allow(RegExp(r'[0-9ㄱ-ㅎㅏ-ㅣ가-힣 ]')),
            ],
          ),
          SizedBox(height: 20),
          SignUpSubmitButton(
            signUpFormKey: _signUpFormKey,
            username: username,
            nickname: nickname,
            password: password,
            email: email,
            account: account,
          )
        ],
      ),
    );
  }
}

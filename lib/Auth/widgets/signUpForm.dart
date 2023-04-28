import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_request_model.dart';
import 'duplicateCheckBtn.dart';
import 'signUpSubmitBtn.dart';
import 'validCheckBtn.dart';

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
  String emailValidationCode = '';
  String account = '';
  String token = '';

  bool checkUsernameDuplicate = false;
  bool checkNicknameDuplicate = false;
  bool checkEmailDuplicate = false;
  bool checkEmailValid = false;

  setDuplicationFlag(DuplicateCheckField field, bool value) {
    setState(() {
      switch (field) {
        case DuplicateCheckField.username:
          checkUsernameDuplicate = value;
          break;
        case DuplicateCheckField.nickname:
          checkNicknameDuplicate = value;
          break;
        case DuplicateCheckField.email:
          checkEmailDuplicate = value;
          break;
      }
    });
  }

  setValidFlag(bool value, String token) {
    setState(() {
      checkEmailValid = value;
      this.token = token;
    });
  }

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
                    if (!checkUsernameDuplicate) {
                      return '아이디 중복검사를 해주세요';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      username = value;
                      checkUsernameDuplicate = false;
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
                setValid: setDuplicationFlag,
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
                    if (!checkNicknameDuplicate) {
                      return '닉네임 중복검사를 해주세요';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      nickname = value;
                      checkNicknameDuplicate = false;
                    });
                  },
                ),
              ),
              SizedBox(width: 15),
              DuplicateCheckButton(
                field: DuplicateCheckField.nickname,
                setValid: setDuplicationFlag,
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
                    if (!checkEmailDuplicate) {
                      return '인증코드를 발송 해주세요';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      checkEmailDuplicate = false;
                      checkEmailValid = false;
                      emailValidationCode = '';
                      token = '';
                    });
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              Text(rootEmail),
              SizedBox(width: 25),
              DuplicateCheckButton(
                field: DuplicateCheckField.email,
                setValid: setDuplicationFlag,
                value: email,
              ),
            ],
          ),
          if (checkEmailDuplicate)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: '인증코드',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '인증코드를 입력해주세요';
                      }
                      if (!checkEmailValid) {
                        return '인증코드를 확인해주세요';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        emailValidationCode = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 25),
                ValidCheckButton(
                  setValidFlag: setValidFlag,
                  checkEmailValid: checkEmailValid,
                  emailValidationCode: emailValidationCode,
                  email: email,
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
            token: token,
          )
        ],
      ),
    );
  }
}

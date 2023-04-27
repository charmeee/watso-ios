import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';

class SignUpForm extends ConsumerStatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _signUpFormKey = GlobalKey<FormState>();
  String username = '';
  String nickname = '';
  String password = '';
  String email = '';
  String account = '';

  bool checkUsername = false;
  bool checkNickname = false;

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
                    username = value;
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                ),
                onPressed: () async {
                  //validator check
                  log("중복검사");
                  if (username.isNotEmpty) {
                    //api 호출
                    await ref
                        .read(userNotifierProvider.notifier)
                        .signUpCheckDuplicate(
                            field: 'username', value: username)
                        .then((value) {
                      if (!value) {
                        setState(() {
                          checkUsername = !value;
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('이미 존재하는 아이디입니다'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('확인'))
                                ],
                              );
                            });
                      }
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  }
                },
                child: Text('중복검사'),
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
                      return '아이디 중복검사를 해주세요';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    nickname = value;
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                ),
                onPressed: () async {
                  log("중복검사");
                  if (nickname.isNotEmpty) {
                    await ref
                        .read(userNotifierProvider.notifier)
                        .signUpCheckDuplicate(
                            field: 'nickname', value: nickname)
                        .then((value) {
                      if (!value) {
                        setState(() {
                          checkNickname = !value;
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('이미 존재하는 닉네임입니다'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('확인'))
                                ],
                              );
                            });
                      }
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                    //api 호출
                  }
                },
                child: Text('중복검사'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '이메일'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
                  ],
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                ),
                onPressed: () {
                  //api 호출
                },
                child: Text('인증'),
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
            onSaved: (value) {
              password = value!;
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
            onSaved: (value) {
              {
                account = value!;
              }
            },
            keyboardType: TextInputType.text,
            inputFormatters: [
              //number and korean
              FilteringTextInputFormatter.allow(RegExp(r'[0-9ㄱ-ㅎㅏ-ㅣ가-힣]')),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: () {
              if (_signUpFormKey.currentState!.validate()) {
                _signUpFormKey.currentState!.save();
                log('username: $username, nickname: $nickname, email: $email, password: $password, account: $account');
                //api 호출
                ref
                    .read(userNotifierProvider.notifier)
                    .signUp(username, nickname, password, email, account)
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
          ),
        ],
      ),
    );
  }
}

// TextFormField(
// decoration: InputDecoration(labelText: '비밀번호 확인'),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return '비밀번호를 입력해주세요';
// }
// if (value != passwordForCheck) {
// return '비밀번호가 일치하지 않습니다';
// }
// return null;
// },
// inputFormatters: [//include ! ~ @ ?
// FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@~?]')),
// ],
// ),

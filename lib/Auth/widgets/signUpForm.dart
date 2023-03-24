import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _signUpFormKey = GlobalKey<FormState>();
  String username = '';
  String nickname = '';
  String password = '';
  String email = '';
  String account = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("회원가입", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '성함'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '성함 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
                ),
                onPressed: () {//validator check
                  log("중복검사");
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
                    return null;
                  },
                  onSaved: (value) {
                    nickname = value!;
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
                ),
                onPressed: () {
                  log("중복검사");
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
                  onSaved: (value) {
                    email = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),

              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
                ),
                onPressed: () {},
                child: Text('인증'),
              ),
            ],
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(labelText: '비밀번호'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              if(value.length < 6){
                return '비밀번호는 6자 이상이어야 합니다';
              }
              return null;
            },
            onSaved: (value) {
              password = value!;
            },
            inputFormatters: [//include ! ~ @ ?
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@~?]')),
            ],
          ),
          TextFormField(//account
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(labelText: '계좌번호'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '계좌번호를 입력해주세요';
              }
              return null;
            },onSaved: (value) {{
              account = value!;
            }}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ,
            keyboardType: TextInputType.number,
            inputFormatters: [//only number
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],

          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.indigo,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: () {
              if (_signUpFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
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
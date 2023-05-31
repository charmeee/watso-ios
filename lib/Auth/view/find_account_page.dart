import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';

import '../../Common/theme/color.dart';
import '../../Common/theme/text.dart';
import '../../Common/widget/outline_textformfield.dart';
import '../../Common/widget/primary_button.dart';
import '../repository/user_repository.dart';

class FindAccountPage extends ConsumerStatefulWidget {
  const FindAccountPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FindAccountPageState();
}

class _FindAccountPageState extends ConsumerState<FindAccountPage> {
  bool isFindId = true;

  String username = '';
  String email1 = '';
  String email2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: '아이디/비밀번호 찾기', isCenter: false),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 12,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFindId = true;
                    });
                  },
                  child: Text('아이디 찾기',
                      style: WatsoText.readable.copyWith(
                          color: isFindId ? WatsoColor.primary : Colors.grey)),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFindId = false;
                    });
                  },
                  child: Text('비밀번호 찾기',
                      style: WatsoText.readable.copyWith(
                          color: isFindId ? Colors.grey : WatsoColor.primary)),
                )
              ]),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isFindId) ...{
                        Text(
                          '가입하신 이메일을 입력해주세요.',
                          style: WatsoText.lightBold,
                        ),
                        const SizedBox(height: 20),
                        outlineTextFromField(
                          key: const ValueKey('findID_email'),
                          hintText: '이메일',
                          onChanged: (value) {
                            setState(() {
                              email1 = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        primaryButton(
                          text: '아이디 찾기',
                          onPressed: () {
                            ref
                                .read(userRepositoryProvider)
                                .findUsername(email1)
                                .then((value) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('이메일 발송'),
                                          content: Text('이메일로 아이디를 발송했습니다.'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('확인'))
                                          ],
                                        )))
                                .onError((error, stackTrace) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('에러'),
                                          content: Text(error.toString()),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('확인'))
                                          ],
                                        )));
                          },
                        ),
                      } else ...{
                        Text(
                          '아이디를 입력해주세요',
                          style: WatsoText.lightBold,
                        ),
                        const SizedBox(height: 20),
                        outlineTextFromField(
                          key: const ValueKey('findPassword_username'),
                          hintText: '아이디',
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '가입하신 이메일을 입력해주세요.',
                          style: WatsoText.lightBold,
                        ),
                        const SizedBox(height: 20),
                        outlineTextFromField(
                          key: const ValueKey('findPassword_email'),
                          hintText: '이메일',
                          onChanged: (value) {
                            setState(() {
                              email2 = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        primaryButton(
                          text: '임시 비밀번호 발급',
                          onPressed: () {
                            ref
                                .read(userRepositoryProvider)
                                .findPassword(email2, username)
                                .then((value) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('이메일 발송'),
                                          content: Text('이메일로 임시비밀번호를 발송했습니다.'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('확인'))
                                          ],
                                        )))
                                .onError((error, stackTrace) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('에러'),
                                          content: Text(error.toString()),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('확인'))
                                          ],
                                        )));
                          },
                        ),
                      }
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

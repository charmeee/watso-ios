import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/theme/text.dart';
import '../../Common/widget/outline_textformfield.dart';
import '../../Common/widget/primary_button.dart';
import '../repository/user_repository.dart';

class PasswordEditBox extends ConsumerStatefulWidget {
  const PasswordEditBox({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PasswordEditBoxState();
}

class _PasswordEditBoxState extends ConsumerState<PasswordEditBox> {
  String beforePassword = '';
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '기존 비밀번호를 입력해주세요',
          style: WatsoText.lightBold,
        ),
        const SizedBox(height: 20),
        outlineTextFromField(
          hintText: '기존 비밀번호',
          onChanged: (value) {
            setState(() {
              beforePassword = value;
            });
          },
        ),
        const SizedBox(height: 20),
        Text(
          '새로운 비밀번호를 입력해주세요',
          style: WatsoText.lightBold,
        ),
        const SizedBox(height: 20),
        outlineTextFromField(
          hintText: '새로운 비밀번호',
          onChanged: (value) {
            setState(() {
              newPassword = value;
            });
          },
        ),
        const SizedBox(height: 20),
        primaryButton(
          text: '비밀번호 변경',
          onPressed: () {
            ref
                .read(userRepositoryProvider)
                .updatePassword(beforePassword, newPassword)
                .then((value) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('변경 완료'),
                          content: Text('비밀번호가 변경되었습니다.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
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
                                onPressed: () => Navigator.pop(context),
                                child: Text('확인'))
                          ],
                        )));
          },
        ),
      ],
    );
  }
}

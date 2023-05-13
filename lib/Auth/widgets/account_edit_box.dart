import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/outline_textformfield.dart';
import '../provider/user_provider.dart';
import '../repository/user_repository.dart';

class AccountEditBox extends ConsumerStatefulWidget {
  const AccountEditBox({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AccountEditBoxState();
}

class _AccountEditBoxState extends ConsumerState<AccountEditBox> {
  String accountNumber = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '새 계좌번호를 입력해주세요',
          style: WatsoText.lightBold,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: outlineTextFromField(
            onChanged: (value) {
              setState(() {
                accountNumber = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '계좌번호를 입력해주세요';
              }
              return null;
            },
            hintText: '계좌번호를 입력해주세요',
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey[300],
          ),
          onPressed: () {
            ref
                .read(userRepositoryProvider)
                .updateUserInfo('accountNumber', accountNumber)
                .then((value) {
              ref
                  .read(userNotifierProvider.notifier)
                  .setUserInfo('accountNumber', accountNumber);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('계좌번호가 변경되었습니다.')));
              Navigator.pop(context);
            }).onError((error, stackTrace) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('계좌번호 변경에 실패했습니다.')));
            });
          },
          child: Text('계좌번호 변경'),
        ),
      ],
    );
  }
}

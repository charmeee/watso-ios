import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/secondary_button.dart';

import '../../Common/theme/text.dart';
import '../../Common/widget/outline_textformfield.dart';
import '../../Common/widget/primary_button.dart';
import '../provider/user_provider.dart';
import '../repository/user_repository.dart';

class AccountEditBox extends ConsumerStatefulWidget {
  const AccountEditBox({
    Key? key,
    this.isSecondary = false,
  }) : super(key: key);
  final bool isSecondary;

  @override
  ConsumerState createState() => _AccountEditBoxState();
}

class _AccountEditBoxState extends ConsumerState<AccountEditBox> {
  String accountNumber = '';

  onPressSubmit() {
    ref
        .read(userRepositoryProvider)
        .updateAccountNumber(accountNumber)
        .then((value) {
      ref
          .read(userNotifierProvider.notifier)
          .setUserInfo('accountNumber', accountNumber);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('계좌번호가 변경되었습니다.')));
      if (widget.isSecondary == false) {
        Navigator.pop(context);
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('계좌번호 변경에 실패했습니다.')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '새 계좌번호를 입력해주세요',
          style: WatsoText.lightBold,
        ),
        const SizedBox(height: 20),
        outlineTextFromField(
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
        SizedBox(height: 20),
        widget.isSecondary
            ? secondaryButton(
                onPressed: onPressSubmit,
                text: '계좌번호 변경',
              )
            : primaryButton(
                onPressed: onPressSubmit,
                child: Text('계좌번호 변경'),
              ),
      ],
    );
  }
}

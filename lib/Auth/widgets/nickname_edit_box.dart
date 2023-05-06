import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/widget/outline_textfield.dart';
import '../models/user_request_model.dart';
import '../repository/user_repository.dart';
import 'duplicateCheckBtn.dart';

class NickNameEditBox extends ConsumerStatefulWidget {
  const NickNameEditBox({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _NickNameEditBoxState();
}

class _NickNameEditBoxState extends ConsumerState<NickNameEditBox> {
  String nickname = '';
  bool checkNicknameDuplicate = false;

  setDuplicationFlag(DuplicateCheckField field, bool value) {
    setState(() {
      checkNicknameDuplicate = value;
    });
  }

  onChanged(value) {
    setState(() {
      nickname = value;
      checkNicknameDuplicate = false;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: outlineTextFromField(
                context,
                onChanged: onChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력해주세요';
                  }
                  if (!checkNicknameDuplicate) {
                    return '닉네임 중복검사를 해주세요';
                  }
                  return null;
                },
                hintText: '닉네임을 입력해주세요',
              ),
            ),
            SizedBox(width: 15),
            SizedBox(
              width: 100,
              height: 50,
              child: DuplicateCheckButton(
                field: DuplicateCheckField.nickname,
                setValid: setDuplicationFlag,
                value: nickname,
              ),
            ),
          ],
        ),
        if (checkNicknameDuplicate)
          ElevatedButton(
            onPressed: () {
              ref
                  .read(userRepositoryProvider)
                  .updateUserInfo('nickname', nickname)
                  .then((value) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('닉네임이 변경되었습니다.')));
                Navigator.pop(context);
              }).onError((error, stackTrace) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('닉네임 변경에 실패했습니다.')));
              });
            },
            child: Text('닉네임 변경'),
          ),
      ],
    );
  }
}

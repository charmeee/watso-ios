import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_request_model.dart';
import '../repository/user_repository.dart';

class DuplicateCheckButton extends ConsumerWidget {
  const DuplicateCheckButton({
    Key? key,
    required this.field,
    required this.value,
    required this.setValid,
  }) : super(key: key);
  final DuplicateCheckField field;
  final String value;
  final Function(DuplicateCheckField, bool) setValid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[300],
      ),
      onPressed: () async {
        if (value.isNotEmpty) {
          await ref
              .read(userRepositoryProvider)
              .checkDuplicated(field: field, value: value)
              .then((value) {
            if (!value) {
              setValid(field, true);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('이미 존재하는 ${field.korName}입니다'),
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
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          });
          //api 호출
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${field.korName}을 입력해주세요')));
        }
      },
      child: field == (DuplicateCheckField.email) ? Text('인증하기') : Text('중복검사'),
    );
  }
}

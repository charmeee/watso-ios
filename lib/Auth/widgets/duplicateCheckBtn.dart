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
          try {
            await ref.read(userRepositoryProvider).checkDuplicated(
                field: field,
                value: field == DuplicateCheckField.email
                    ? value + rootEmail
                    : value);

            if (field == DuplicateCheckField.email) {
              //인증 코드 발송
              await ref
                  .read(userRepositoryProvider)
                  .sendValidEmail(value + rootEmail);
            }
            setValid(field, true);
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }

          //api 호출
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${field.korName}을 입력해주세요')));
        }
      },
      child:
      field == (DuplicateCheckField.email) ? Text('인증코드 발송') : Text('중복검사'),
    );
  }
}

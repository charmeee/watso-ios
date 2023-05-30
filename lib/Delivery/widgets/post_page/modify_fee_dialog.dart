import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/widget/outline_textformfield.dart';
import '../../provider/post_list_provider.dart';
import '../../repository/post_repository.dart';

class ModifyFeeDialog extends ConsumerStatefulWidget {
  const ModifyFeeDialog({
    Key? key,
    required this.storeFee,
    required this.postId,
    this.isConfirm = false,
  }) : super(key: key);
  final int storeFee;
  final String postId;
  final bool isConfirm;

  @override
  ConsumerState createState() => _ModifyFeeDialogState();
}

class _ModifyFeeDialogState extends ConsumerState<ModifyFeeDialog> {
  late int fee;
  String isError = '';

  @override
  void initState() {
    super.initState();
    fee = widget.storeFee;
  }

  @override
  void dispose() {
    isError = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isConfirm ? '배달완료 및 배달비 확정' : '배달비 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isError.isNotEmpty)
            Flexible(
              child: Text(
                isError,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
          if (widget.isConfirm)
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('실제로 지급한 배달비를 입력해 주세요'),
            )),
          outlineTextFromField(
            keyboardType: TextInputType.number,
            initialValue: fee.toString(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '배달비를 입력해 주세요(없을 시 0 입력)';
              }
              int tmp = int.parse(value);
              if (tmp >= 100000) {
                return '배달비는 10만원을 넘을 수 없습니다.';
              }
              if (tmp < 0) {
                return '배달비는 음수가 될 수 없습니다.';
              }
            },
            suffix: Text(
              '원',
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
            onChanged: (value) {
              if (value.isEmpty) return;
              int tmp = int.parse(value);
              if (tmp >= 0 && tmp < 100000) {
                setState(() {
                  fee = tmp;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(postRepositoryProvider)
                .updateDeliveryFee(widget.postId, fee)
                .then((value) {
              ref.invalidate(postDetailProvider(widget.postId));

              Navigator.pop(context);
            }).onError((error, stackTrace) {
              setState(() {
                isError = error.toString();
              });
            });
          },
          child: Text('확인'),
        ),
      ],
    );
  }
}

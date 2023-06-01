import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/primary_button.dart';

import '../../models/post_request_model.dart';
import '../../provider/post_list_provider.dart';
import '../../repository/order_repository.dart';
import '../../repository/post_repository.dart';
import '../check_account_page.dart';

class BasketSubmitButton extends ConsumerWidget {
  const BasketSubmitButton({Key? key, required this.postOrder})
      : super(key: key);
  final PostOrder postOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postOrder.orderOption.postId != null) {
      recuitSuccess() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('배달왔소에 참가하였습니다.'),
        ));
        ref.invalidate(myPostListProvider);
        ref.invalidate(joinablePostListProvider);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      recuitFail(String error) {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(error),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('확인')),
                  ],
                ));
      }

      return primaryButton(
          text: '배달왔소 참가',
          minimumSize: const Size.fromHeight(50),
          onPressed: () async {
            if (postOrder.orderOption.isAbleToRecuit) {
              //convert to try catch
              try {
                await ref
                    .read(
                    orderRepositoryProvider(postOrder.orderOption.postId!))
                    .postOrder(postOrder.order);
                recuitSuccess();
              } catch (error) {
                recuitFail(error.toString());
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('주문 시간이 지났습니다. 주문에 참가하실 수 없습니다.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: Text('확인')),
                        ],
                      ));
            }
          });
    }

    submitSuccess() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('배달왔소가 등록되었습니다.'),
      ));
      ref.invalidate(myPostListProvider);
      ref.invalidate(joinablePostListProvider);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => CheckMyAccount()),
              (route) => route.isFirst);
    }

    submitFail(String error) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(error),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('배달 취소')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('확인')),
                ],
              ));
    }

    return (primaryButton(
        text: '배달왔소 등록',
        minimumSize: const Size.fromHeight(50),
        onPressed: () {
          if (postOrder.isAbleToPost) {
            ref
                .read(postRepositoryProvider)
                .postDelivery(postOrder)
                .then((value) {
              submitSuccess();
            }).onError((error, stackTrace) {
              submitFail(error.toString());
            });
          } else {
            log(postOrder.newPostToJson().toString());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('문제가 발생하였습니다. 주문옵션을 확인해주세요'),
            ));
          }
        }));
  }
}

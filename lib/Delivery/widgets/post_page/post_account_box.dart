import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/theme/text.dart';
import 'package:watso/Delivery/models/post_model.dart';

import '../../../Auth/provider/user_provider.dart';
import '../../../Common/theme/color.dart';
import '../../repository/post_repository.dart';

class AccountCard extends ConsumerStatefulWidget {
  const AccountCard({Key? key,
    required this.isOwner,
    required this.status,
    required this.postId})
      : super(key: key);
  final bool isOwner;
  final PostStatus status;
  final String postId;

  @override
  ConsumerState createState() => _AccountCardState();
}

class _AccountCardState extends ConsumerState<AccountCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.isOwner) {
      String accountNum = ref.watch(userNotifierProvider)!.accountNumber;
      return SliverToBoxAdapter(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                    child: Text('팀장 계좌번호', style: WatsoText.readable),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                      child: Text(
                        accountNum,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        '공개',
                        style: TextStyle(
                          color: WatsoColor.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    }
    if (widget.status == PostStatus.delivered) {
      return SliverToBoxAdapter(
        child: FutureBuilder<String>(
            future: ref
                .watch(postRepositoryProvider)
                .getAccountNumber(widget.postId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8.0),
                          child: Text('팀장 계좌번호', style: WatsoText.readable),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8.0),
                            child: Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Icon(Icons.copy),
                          ),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: snapshot.data!));
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('계좌번호가 복사되었습니다.')));
                          },
                        ),

                      ],
                    ),
                  ),
                );
              }
              return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.hasError
                            ? '계좌번호를 불러오지 못했습니다.'
                            : '계좌번호를 불러오는 중입니다.',
                        textAlign: TextAlign.center,
                      )));
            }),
      );
    }
    //return empty
    return SliverToBoxAdapter(
        child: SizedBox(
          height: 0,
        ));
  }

  Widget accountCard({required Widget child}) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(padding: const EdgeInsets.all(8.0), child: child));
  }
}

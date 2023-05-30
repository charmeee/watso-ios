import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Common/widget/appbar.dart';
import 'package:watso/Common/widget/primary_button.dart';

import '../../Auth/models/user_model.dart';
import '../../Auth/provider/user_provider.dart';
import '../../Auth/widgets/account_edit_box.dart';
import '../../Common/theme/text.dart';
import '../../Common/widget/secondary_button.dart';

class CheckMyAccount extends ConsumerStatefulWidget {
  const CheckMyAccount({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CheckMyAccountState();
}

class _CheckMyAccountState extends ConsumerState<CheckMyAccount> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    UserInfo? user = ref.watch(userNotifierProvider);
    print('CheckMyAccount');
    if (user == null)
      return Scaffold(
          body: Container(
        child: Text('로그인이 필요합니다.'),
      ));
    UserInfo validUser = user;
    return Scaffold(
      appBar: customAppBar(context, title: '계좌번호 확인'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('계좌번호는 배달완료 후 모임 참가자에게 노출됩니다.'),
                        Text('정확한 배달비 분배를 위해 계좌번호를 확인해 주세요.'),
                      ],
                    ))),
            SliverToBoxAdapter(
              child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              '현재 계좌번호',
                              style: WatsoText.title,
                            ),
                            Spacer(),
                            SizedBox(
                                height: 30,
                                child: secondaryButton(
                                  onPressed: () {
                                    setState(() {
                                      isEdit = true;
                                    });
                                  },
                                  text: '변경',
                                  padding: EdgeInsets.zero,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${validUser.accountNumber}',
                          style: WatsoText.lightBold.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  )),
            ),
            if (isEdit)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: AccountEditBox(
                    isSecondary: true,
                  ),
                ),
              ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.bottomCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: primaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: '확인',
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Auth/repository/user_repository.dart';

class NotificationAllowBox extends ConsumerStatefulWidget {
  const NotificationAllowBox({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _NotificationAllowBoxState();
}

class _NotificationAllowBoxState extends ConsumerState<NotificationAllowBox> {
  bool notificationAllow = false;
  bool permission = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission().then((value) {
      log('permission: $value');
      setState(() {
        permission = value;
      });
    });
    ref.read(userRepositoryProvider).getNotificationAllow().then((value) {
      setState(() {
        notificationAllow = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        notificationAllow = false;
      });
    });
  }

  Future<bool> getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "알림",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (permission == false) ...{
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text("알림 권한이 없습니다. 알림을 받으시려면 알림 권한을 허용해주세요."),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("설정 > 왔소 > 알림 > 알림 허용"),
              )
            } else ...{
              ListTile(
                title: Text('알림 설정'),
                trailing: Switch(
                  value: notificationAllow,
                  onChanged: (value) {
                    ref
                        .read(userRepositoryProvider)
                        .updateNotificationAllow(value)
                        .then((_) => setState(() {
                              notificationAllow = value;
                            }))
                        .onError((error, stackTrace) =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('알림 변경이 적용되지않았습니다. 다시 시도해주세요'))));
                  },
                  activeTrackColor: Colors.indigo[100],
                  activeColor: Colors.indigo,
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}

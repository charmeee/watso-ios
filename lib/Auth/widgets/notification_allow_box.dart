import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/dio.dart';
import '../repository/auth_repository.dart';

class NotificationAllowBox extends ConsumerStatefulWidget {
  const NotificationAllowBox({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _NotificationAllowBoxState();
}

class _NotificationAllowBoxState extends ConsumerState<NotificationAllowBox> {
  bool notificationAllow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAllow();
  }

  setAllow() async {
    final storage = ref.read(secureStorageProvider);
    final fcmAllow = await storage.read(key: "fcmAllow");
    log(fcmAllow.toString());
    if (fcmAllow == "true") {
      setState(() {
        notificationAllow = true;
      });
    } else {
      setState(() {
        notificationAllow = false;
      });
    }
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
            ListTile(
              title: Text('알림 설정'),
              trailing: Switch(
                value: notificationAllow,
                onChanged: (value) {
                  setState(() {
                    notificationAllow = value;
                  });
                  ref.read(authRepositoryProvider).handleFcmAllow(value);
                },
                activeTrackColor: Colors.indigo[100],
                activeColor: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Main delivery page
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Auth/auth_provider.dart';


class DeliveryMainPage extends ConsumerWidget {
  const DeliveryMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
      ),
      body: Center(
        //make button
        child: TextButton(
          onPressed: (){
            log('button pressed');
            ref.read(userNotifierProvider.notifier).logout();

          },
          child: Text("Text BUTTON"),
        ),
      ),
    );
  }
}
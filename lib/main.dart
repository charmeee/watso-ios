import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Auth/auth_provider.dart';

import 'Auth/view/signIn.dart';
import 'Common/global.dart';
import 'Delivery/view/index.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ProviderScope(
    child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'dogbird',
        navigatorKey: navigatorState,
        theme: ThemeData(
            // scaffoldBackgroundColor: backgroundColor,
            // textTheme: TextTheme()
            //     .apply(bodyColor: Colors.white, displayColor: Colors.white)
        ),
        home: const MyApp(),
      ),
    ),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final initState = ref.watch(startProvider);

    // TODO: implement build
    return initState.when(
        data: (data) {
          return (data==AuthState.authenticated) ?DeliveryMainPage():SignInPage();
        },
        loading: () => const Scaffold(
          body: Center(
            child: Text('로딩'),
          ),
        ),
        error: (e, s) {
          log(e.toString());
          return const Scaffold(
            body: Center(
              child: Text('에러'),
            ),
          );
        });
  }
  
}
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:watso/Auth/provider/user_provider.dart';

import 'Auth/view/signIn.dart';
import 'Common/global.dart';
import 'Delivery/view/post_list_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //localization
  initializeDateFormatting().then((_) => runApp(ProviderScope(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'dogbird',
            navigatorKey: navigatorState,
            theme: ThemeData(
              primaryColor: Color(0xffFF7700),
              fontFamily: 'suite',
              // scaffoldBackgroundColor: backgroundColor,
              // textTheme: TextTheme()
              //     .apply(bodyColor: Colors.white, displayColor: Colors.white)
            ),
            home: const MyApp(),
          ),
        ),
      )));
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
          // AuthState authState = ref.watch(authStateProvider);
          // if (authState == AuthState.unauthenticated) {
          //   Navigator.popUntil(context, (route) => route.isFirst);
          //   print("authState : unauthenticated");
          // }
          return (data == AuthState.authenticated)
              ? DeliveryMainPage()
              : SignInPage();
        },
        loading: () => const Scaffold(
              body: Center(
                child: Text('로딩'),
              ),
            ),
        error: (e, s) {
          return const Scaffold(
            body: Center(
              child: Text('에러'),
            ),
          );
        });
  }
}

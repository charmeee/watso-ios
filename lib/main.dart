import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watso/Auth/provider/user_provider.dart';

import 'Auth/view/signIn.dart';
import 'Common/firebase/firebase_options.dart';
import 'Common/global.dart';
import 'Delivery/view/post_list_page.dart';
import 'Delivery/view/post_page.dart';

/*in storage
  refresh token string
  access token string
  fcmAllow bool
 */
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Handling a background message: ${message.messageId} ${message.data}");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(
    child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('ko', 'KR'),
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // iOS
        ],
        supportedLocales: [
          const Locale('en'), // English
          const Locale('ko'), // korean
          // ... other locales the app supports
        ],
        title: 'dogbird',
        navigatorKey: navigatorState,
        theme: ThemeData(
          primaryColor: Color(0xffFF7700),
          fontFamily: 'suite',
          scaffoldBackgroundColor: Color(0xfff7f7fa),
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
    getFcmPermission().then((value) {
      onFcmMessageListen();
    });
  }

  getFcmPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission: ${settings.authorizationStatus}');
      if (Platform.isIOS) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
      return true;
    }
    return false;
  }

  onFcmMessageListen() {
    //onMessageOpenedApp background -> notificaiton 클릭시에 실행됨.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('background!');
      handleMessage(message);
    });

    // //onforeground 자동으로 이함수가 실행됨
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('foreground!');
    //   // handleMessage(message);
    //   //포그라운드
    // });
  }

  handleMessage(RemoteMessage message) {
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.toMap()}');
    }
    final postId = message.data['post_id'];
    if (postId is String) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PostPage(
                    postId: postId,
                  )),
          (route) => route.isFirst);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => PostPage(
      //             postId: postId,
      //           )),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initState = ref.watch(startProvider);
    if (!initState.isLoading) {
      FlutterNativeSplash.remove();
    }

    return initState.when(
        data: (data) {
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

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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  //onMessageOpenedApp
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print(message);
  });

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.toMap()}');
    }
  });

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
  }

  @override
  Widget build(BuildContext context) {
    final initState = ref.watch(startProvider);
    if (!initState.isLoading) {
      FlutterNativeSplash.remove();
    }

    // TODO: implement build
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

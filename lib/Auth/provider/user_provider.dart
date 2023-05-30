import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Common/dio.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';

enum AuthState {
  initial,
  authenticated,
  unauthenticated,
}

//statenotifier로 만들어서 하면되지않을까?
final startProvider = FutureProvider((ref) async {
  final authState = ref.watch(authStateProvider);
  final storage = ref.watch(secureStorageProvider);
  final refreshToken = await storage.read(key: 'refreshToken');

  log(authState.toString());
  if (authState == AuthState.initial) {
    try {
      if (refreshToken != null) {
        await ref.read(userNotifierProvider.notifier).getUserProfile();
      } else {
        ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
      }
    } catch (e) {
      ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    }
  }

  return authState;
});

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.initial);

//상위껄만들어서 null이면 dispose하게끔..하면되지않을까?

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserInfo?>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return UserNotifier(ref, storage);
});

class UserNotifier extends StateNotifier<UserInfo?> {
  // final AuthRepository authRepo;
  final Ref ref;
  final FlutterSecureStorage storage;

  UserNotifier(this.ref, this.storage) : super(null);

  //로긴됏을때! 머다? authorize 한다.

  Future signIn(username, password) async {
    await ref.read(authRepositoryProvider).login(username, password);
    await getUserProfile();
  }

  Future getUserProfile() async {
    final userInfo = await ref.read(userRepositoryProvider).getUserProfile();
    state = userInfo;
    ref.read(authStateProvider.notifier).state = AuthState.authenticated;
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();
      log(fcmToken ?? 'null');
      if (fcmToken != null) {
        ref.read(userRepositoryProvider).updateDeviceToken(fcmToken);
      }
    } catch (e) {
      log('fcm token error');
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    init();
  }

  Future deleteUserProfile() async {
    log("회원탈퇴");
    await ref.read(userRepositoryProvider).deleteAccount();
    init();
  }

  init() {
    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    state = null;
  }

  setUserInfo(field, value) {
    UserInfo userInfo = UserInfo.clone(state!);
    if (field == 'nickname') {
      userInfo.nickname = value;
    } else if (field == 'accountNumber') {
      userInfo.accountNumber = value;
    }
    state = userInfo;
  }
}

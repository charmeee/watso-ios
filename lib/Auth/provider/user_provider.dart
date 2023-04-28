import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';

enum AuthState {
  initial,
  authenticated,
  unauthenticated,
}

final startProvider = FutureProvider((ref) async {
  final authState = ref.watch(authStateProvider);
  log(authState.toString());
  if (authState == AuthState.initial) {
    try {
      await ref.read(userNotifierProvider.notifier).getUserProfile();
    } catch (e) {
      ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    }
  }

  return authState;
});

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.initial);

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserInfo?>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<UserInfo?> {
  // final AuthRepository authRepo;
  final Ref ref;

  // UserNotifier( {required this.authRepo,required this.ref}) : super(null);
  UserNotifier(this.ref) : super(null);

  //로긴됏을때! 머다? authorize 한다.

  Future signIn(username, password) async {
    await ref.read(authRepositoryProvider).login(username, password);
    getUserProfile();
  }

  Future getUserProfile() async {
    final userInfo = await ref.read(userRepositoryProvider).getUserProfile();
    state = userInfo;
    ref.read(authStateProvider.notifier).state = AuthState.authenticated;
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (e) {
      log('로그아웃 실패');
    }
    init();
  }

  Future deleteUserProfile() async {
    log("회원탈퇴");
    init();
  }

  init() {
    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    state = null;
  }
}

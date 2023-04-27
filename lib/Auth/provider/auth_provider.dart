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
    await ref.read(userRepositoryProvider).getUserProfile();
  }

  Future signUp(username, nickname, password, email, account) async {
    await ref
        .read(userRepositoryProvider)
        .signUp(username, nickname, password, email, account);
  }

  Future signUpCheckDuplicate({required field, required value}) async {
    // try {
    //   final response = await dio.get('$staticUrl/signup/duplicate-check',
    //       queryParameters: {'field': field, 'value': value});
    //   if (response.data['is_duplicated'] != null) {
    //     return response.data['is_duplicated'];
    //   }
    //   throw Exception("응답 객체가 없음");
    // } on DioError catch (e) {
    //   throw FormatException("일시적인 서비스 장애입니다.");
    // }
  }

  Future getUserProfile() async {
    final userInfo = await ref.read(userRepositoryProvider).getUserProfile();
    state = userInfo;
    ref.read(authStateProvider.notifier).state = AuthState.authenticated;
  }

  // Future<LoginState> venderLogin(Vender vender) async {
  //   switch (vender) {
  //     case Vender.kakao:
  //       log("카카오 로그인");
  //       SocialLogin kakaoLogin = KakaoLogin();
  //       LoginState isKaKaoLogin = await kakaoLogin.login();
  //       if (isKaKaoLogin.isLogin) {
  //         await getUserProfile();
  //       }
  //       return isKaKaoLogin;
  //   //loginstate를반환 freshman 이면 리턴 freshman아니면 프로필 로딩.
  //     case Vender.google:
  //       log("구글 로그인");
  //       return LoginState(isLogin: false, isFreshman: false);
  //     case Vender.apple:
  //       log("애플 로그인");
  //       return LoginState(isLogin: false, isFreshman: false);
  //   }
  // }

  // Future<LoginState> nativeLogin(String username, String password) async {
  //   log("nativeLogin");
  //   LoginState isLogin = await nativeLoginRequest(username, password);
  //   if (isLogin.isLogin) {
  //     await getUserProfile();
  //   }
  //   return isLogin;
  // }

  // Future<bool> updateUserProfile(UserInfo newUserInfo) async {
  //   UserInfo userInfo = UserInfo(
  //       id: state.id,
  //       username: newUserInfo.username,
  //       nickname: newUserInfo.nickname,
  //       userEmail: newUserInfo.userEmail,
  //       ageRange: newUserInfo.ageRange,
  //       gender: newUserInfo.gender);
  //   bool result = await UserUpdateRequest(userInfo);
  //   if (result) {
  //     state = userInfo;
  //     log("$newUserInfo.nickname로 닉넴 변경 ");
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (e) {
      log('로그아웃 실패');
    }
    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    state = null;
  }

  Future deleteUserProfile() async {
    log("회원탈퇴");
    state = null;
    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
  }
}

import 'dart:developer';

import 'package:dio/src/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/dio.dart';
import 'models/user_model.dart';


enum AuthState {
  initial,
  authenticated,
  unauthenticated,
  error
}

final startProvider = FutureProvider((ref) async {
  var authState = ref.watch(authStateProvider);
  if(authState == AuthState.initial){
    try {
      await ref.read(userNotifierProvider.notifier).getUserProfile();
      ref.read(authStateProvider.notifier).state = AuthState.authenticated;
    }catch(e){
      log(e.toString());
      ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    }
  }
  return authState;
});

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.initial);

final userNotifierProvider =
StateNotifierProvider<UserNotifier, UserInfo>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<UserInfo> {
  final Ref ref;
  UserNotifier(this.ref) : super(UserInfo());
  //로긴됏을때! 머다? authorize 한다.
  getUserProfile() async {
    log("******us erProfile 받아오기******");
    // try {
    //   UserInfo userInfo = await userProfileRequest();
    //   state = userInfo;
    //   log(state.id.toString());
    //   log(state.username.toString());
    //   log(state.nickname.toString());
    //   log("*****************************");
    // } catch (e) {
    //   logout();
    // }
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

  logout() async {
    state = UserInfo.init();
    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
  }

  deleteUserProfile() async {
    log("회원탈퇴");
    if (state.id != null) {
      state = UserInfo.init();
      ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    }
  }
}


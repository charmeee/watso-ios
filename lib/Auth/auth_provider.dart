import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Common/dio.dart';
import 'models/user_model.dart';


enum AuthState {
  initial,
  authenticated,
  unauthenticated,
}

final startProvider = FutureProvider((ref) async {
  final authState = ref.watch(authStateProvider);
  log(authState.toString());
  if(authState==AuthState.initial) {
    try {
      await ref.read(userNotifierProvider.notifier).getUserProfile();
      //ref.read(authStateProvider.notifier).state = AuthState.authenticated;
    } catch (e) {
      log(e.toString());
      ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    }
  }

  return authState;
});

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.initial);

final userNotifierProvider =
StateNotifierProvider<UserNotifier, UserInfo?>((ref) {


  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);

  //dio url /auth 추가
  dio.options.baseUrl +='/auth';

  return UserNotifier(dio,storage,ref:ref);
});

class UserNotifier extends StateNotifier<UserInfo?> {
  // final AuthRepository authRepo;
  final Dio dio;
  final Ref ref;
  final FlutterSecureStorage storage;
  // UserNotifier( {required this.authRepo,required this.ref}) : super(null);
  UserNotifier(this.dio, this.storage,{required this.ref}) : super(null);
  //로긴됏을때! 머다? authorize 한다.

  Future signIn(username,password) async{
    try {
      final response = await dio.post('/signin', data: {
        'username': username,
        'pw': password,
        'registration_token': 'string'
      });
      if(response.headers["authentication"] != null){
        final token = response.headers["authentication"].toString().split("/");
        log("access token 발급 완료  $token");

        storage.delete(key: "accessToken");
        storage.write(key: "accessToken", value: token[0]);
        storage.delete(key: "refreshToken");
        storage.write(key: "refreshToken", value: token[1]);
      }else{
        throw Exception("access token 발급 실패");
      }
      ref.read(authStateProvider.notifier).state = AuthState.authenticated;
      return response;
    }on DioError catch(e){
      if(e.type == DioErrorType.badResponse){
        log(e.response.toString());
        throw FormatException("아이디 또는 비밀번호가 틀렸습니다.");
      }
      throw Exception("로그인 실패");
    }
  }

  Future signUp(username,nickname,password,email,account)async{
    try{
      final response = await dio.post('/signup', data: {
        'username': username.toString(),
        'pw': password.toString(),
        'nickname': nickname.toString(),
        'account_number': account.toString(),
        'email': email.toString(),
      });
      return response;
    }catch(e){//return errormessage
      log((e is Error).toString() );
      return e;
    }
  }

  Future getUserProfile() async {
    //log("******us erProfile 받아오기******");
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

  Future logout() async {
    try {
      await dio.get('/logout', queryParameters: {
        'Authorization': await storage.read(key: "accessToken")
      });
      storage.delete(key: "accessToken");
      state = null;
      ref
          .read(authStateProvider.notifier)
          .state = AuthState.unauthenticated;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future deleteUserProfile() async {
    log("회원탈퇴");
    state = null;
    ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
  }
}


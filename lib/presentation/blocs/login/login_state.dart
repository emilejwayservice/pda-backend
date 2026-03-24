part of 'login_bloc.dart';



class LoginState {

  AppStatus? loginStatus;
  String? error;
  bool? isOffline;
  bool? isAuth;


  LoginState.empty();

  LoginState copyWith({
    AppStatus? loginStatus,
    String? error,
    bool? isOffline,
    bool? isAuth,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      error: error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
      isAuth: isAuth ?? this.isAuth,
    );
  }

  LoginState({
    this.loginStatus,
    this.error,
    this.isOffline,
    this.isAuth,
  });
}



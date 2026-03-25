part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class Login extends LoginEvent{
  int company;
  String email;
  String password;

  Login(this.company, this.email, this.password);
}



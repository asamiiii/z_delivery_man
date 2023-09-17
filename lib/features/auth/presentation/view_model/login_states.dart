import '../../../../models/auth_model/login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final LoginModel? loginModel;

  LoginSuccessState({this.loginModel});
}

class LoginFailedState extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

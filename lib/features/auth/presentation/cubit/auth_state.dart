import 'package:mat3amy/features/auth/presentation/model/login_result.dart';

class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final LoginResult? loginResult;

  AuthSuccessState(this.loginResult);
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState({required this.error});
}

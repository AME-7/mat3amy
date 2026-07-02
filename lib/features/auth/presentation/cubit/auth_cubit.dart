import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/features/auth/presentation/cubit/auth_state.dart';
import 'package:mat3amy/features/auth/presentation/model/auth_params.dart';
import 'package:mat3amy/features/auth/presentation/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    emit(AuthLoadingState());

    final result = await AuthRepo.login(
      AuthParams(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    result.fold(
      (failure) {
        emit(AuthErrorState(error: failure.massage));
      },
      (_) {
        emit(AuthSuccessState());
      },
    );
  }

  Future<void> register() async {
    emit(AuthLoadingState());

    final result = await AuthRepo.register(
      AuthParams(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    result.fold(
      (failure) {
        emit(AuthErrorState(error: failure.massage));
      },
      (_) {
        emit(AuthSuccessState());
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoadingState());

    final result = await AuthRepo.logout();

    result.fold(
      (failure) {
        emit(AuthErrorState(error: failure.massage));
      },
      (_) {
        emit(AuthSuccessState());
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    return super.close();
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoadingState());

    final result = await AuthRepo.signInWithGoogle();

    result.fold(
      (failure) => emit(AuthErrorState(error: failure.massage)),
      (_) => emit(AuthSuccessState()),
    );
  }
}

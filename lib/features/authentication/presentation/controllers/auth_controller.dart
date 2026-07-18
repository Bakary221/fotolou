import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/login_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/request_phone_otp_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/verify_phone_otp_use_case.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required LoginUseCase loginUseCase,
    required RequestPhoneOtpUseCase requestPhoneOtpUseCase,
    required VerifyPhoneOtpUseCase verifyPhoneOtpUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _requestPhoneOtpUseCase = requestPhoneOtpUseCase,
       _verifyPhoneOtpUseCase = verifyPhoneOtpUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthState.initial()) {
    unawaited(loadCurrentUser());
  }

  final LoginUseCase _loginUseCase;
  final RequestPhoneOtpUseCase _requestPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase _verifyPhoneOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> loadCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading, clearMessage: true);

    final result = await _getCurrentUserUseCase(const NoParams());
    state = result.fold(
      onFailure: (failure) =>
          AuthState(status: AuthStatus.error, message: failure.message),
      onSuccess: (user) => user == null
          ? const AuthState(status: AuthStatus.empty)
          : AuthState(status: AuthStatus.success, user: user),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, clearMessage: true);

    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    state = result.fold(
      onFailure: (failure) =>
          AuthState(status: AuthStatus.error, message: failure.message),
      onSuccess: (user) => AuthState(status: AuthStatus.success, user: user),
    );
  }

  Future<bool> requestPhoneOtp({required String phone}) async {
    state = state.copyWith(status: AuthStatus.loading, clearMessage: true);

    final result = await _requestPhoneOtpUseCase(
      RequestPhoneOtpParams(phone: phone),
    );

    return result.fold(
      onFailure: (failure) {
        state = AuthState(status: AuthStatus.error, message: failure.message);
        return false;
      },
      onSuccess: (_) {
        state = const AuthState(status: AuthStatus.empty);
        return true;
      },
    );
  }

  Future<UserEntity?> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, clearMessage: true);

    final result = await _verifyPhoneOtpUseCase(
      VerifyPhoneOtpParams(phone: phone, otp: otp),
    );

    return result.fold(
      onFailure: (failure) {
        state = AuthState(status: AuthStatus.error, message: failure.message);
        return null;
      },
      onSuccess: (user) {
        state = AuthState(status: AuthStatus.success, user: user);
        return user;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, clearMessage: true);

    final result = await _logoutUseCase(const NoParams());
    state = result.fold(
      onFailure: (failure) =>
          AuthState(status: AuthStatus.error, message: failure.message),
      onSuccess: (_) => const AuthState(status: AuthStatus.empty),
    );
  }
}

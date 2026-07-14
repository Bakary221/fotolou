import 'package:dio/dio.dart';
import 'package:fotolou/core/exceptions/app_exception.dart';
import 'package:fotolou/core/network/api_client.dart';
import 'package:fotolou/features/authentication/data/models/auth_session_model.dart';
import 'package:fotolou/features/authentication/data/models/login_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/phone_otp_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/user_model.dart';
import 'package:fotolou/features/authentication/data/models/verify_otp_request_dto.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSessionModel> login(
    LoginRequestDto request, {
    CancelToken? cancelToken,
  });

  Future<void> requestPhoneOtp(
    PhoneOtpRequestDto request, {
    CancelToken? cancelToken,
  });

  Future<AuthSessionModel> verifyPhoneOtp(
    VerifyOtpRequestDto request, {
    CancelToken? cancelToken,
  });

  Future<void> logout({CancelToken? cancelToken});
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  const MockAuthRemoteDataSource({
    this.delay = const Duration(milliseconds: 150),
  });

  static const _mockAccounts = [
    _MockAuthAccount(
      id: 'client_001',
      phone: '+221701234567',
      otp: '123456',
      email: 'client@fotolou.local',
      name: 'Diassy',
      role: UserRole.client,
    ),
    _MockAuthAccount(
      id: 'barber_001',
      phone: '+221771112233',
      otp: '654321',
      email: 'barber@fotolou.local',
      name: 'King Barber',
      role: UserRole.barber,
    ),
  ];

  final Duration delay;

  @override
  Future<AuthSessionModel> login(
    LoginRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    await Future<void>.delayed(delay);

    if (cancelToken?.isCancelled ?? false) {
      throw const NetworkException('La requête a été annulée.');
    }

    if (request.email.endsWith('@blocked.local')) {
      throw const UnauthorizedException('Identifiants invalides.');
    }

    return AuthSessionModel(
      user: UserModel(
        id: 'usr_${request.email.hashCode.abs()}',
        email: request.email.trim().toLowerCase(),
        name: _nameFromEmail(request.email),
        createdAt: DateTime.utc(2026),
      ),
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
    );
  }

  @override
  Future<void> requestPhoneOtp(
    PhoneOtpRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    await Future<void>.delayed(delay);
    _throwIfCancelled(cancelToken);

    _findAccountByPhone(request.phone);
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp(
    VerifyOtpRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    await Future<void>.delayed(delay);
    _throwIfCancelled(cancelToken);

    final account = _findAccountByPhone(request.phone);
    if (request.otp.trim() != account.otp) {
      throw const UnauthorizedException('Code OTP invalide.');
    }

    return AuthSessionModel(
      user: account.toUserModel(),
      accessToken: 'mock-${account.role.name}-access-token',
      refreshToken: 'mock-${account.role.name}-refresh-token',
    );
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {
    await Future<void>.delayed(delay);
  }

  void _throwIfCancelled(CancelToken? cancelToken) {
    if (cancelToken?.isCancelled ?? false) {
      throw const NetworkException('La requête a été annulée.');
    }
  }

  _MockAuthAccount _findAccountByPhone(String phone) {
    final normalizedPhone = _normalizePhone(phone);
    for (final account in _mockAccounts) {
      if (_normalizePhone(account.phone) == normalizedPhone) {
        return account;
      }
    }

    throw const UnauthorizedException('Numéro de téléphone inconnu.');
  }

  String _nameFromEmail(String email) {
    final localPart = email.split('@').first.trim();
    if (localPart.isEmpty) {
      return 'Utilisateur';
    }

    return localPart
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('221')) {
      return '+$digits';
    }

    return '+221$digits';
  }
}

class _MockAuthAccount {
  const _MockAuthAccount({
    required this.id,
    required this.phone,
    required this.otp,
    required this.email,
    required this.name,
    required this.role,
  });

  final String id;
  final String phone;
  final String otp;
  final String email;
  final String name;
  final UserRole role;

  UserModel toUserModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.utc(2026),
    );
  }
}

class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  const DioAuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthSessionModel> login(
    LoginRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiClient.postJson(
      '/auth/login',
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    try {
      return AuthSessionModel.fromJson(Map<String, dynamic>.from(response));
    } on TypeError {
      throw const ServerException('Le format de session est invalide.');
    }
  }

  @override
  Future<void> requestPhoneOtp(
    PhoneOtpRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    await _apiClient.postJson(
      '/auth/otp/request',
      data: request.toJson(),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp(
    VerifyOtpRequestDto request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiClient.postJson(
      '/auth/otp/verify',
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    try {
      return AuthSessionModel.fromJson(Map<String, dynamic>.from(response));
    } on TypeError {
      throw const ServerException('Le format de session est invalide.');
    }
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {
    await _apiClient.postJson('/auth/logout', cancelToken: cancelToken);
  }
}

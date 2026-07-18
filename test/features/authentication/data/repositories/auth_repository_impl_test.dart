import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/exceptions/app_exception.dart';
import 'package:fotolou/core/failures/failure.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:fotolou/features/authentication/data/models/auth_session_model.dart';
import 'package:fotolou/features/authentication/data/models/login_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/phone_otp_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/user_model.dart';
import 'package:fotolou/features/authentication/data/models/verify_otp_request_dto.dart';
import 'package:fotolou/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:fotolou/features/authentication/domain/entities/login_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/phone_otp_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const LoginRequestDto(email: 'user@example.com', password: 'Password1'),
    );
    registerFallbackValue(const PhoneOtpRequestDto(phone: '+221701234567'));
    registerFallbackValue(
      const VerifyOtpRequestDto(phone: '+221701234567', otp: '123456'),
    );
  });

  late AuthRemoteDataSource remoteDataSource;
  late AuthLocalDataSource localDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    localDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  test('caches the session and returns a domain user after login', () async {
    final session = AuthSessionModel(
      user: UserModel(
        id: 'usr_1',
        email: 'user@example.com',
        name: 'User',
        createdAt: DateTime.utc(2026),
      ),
      accessToken: 'access',
      refreshToken: 'refresh',
    );

    when(() => remoteDataSource.login(any())).thenAnswer((_) async => session);
    when(() => localDataSource.cacheSession(session)).thenAnswer((_) async {});

    final result = await repository.login(
      const LoginCredentials(email: 'user@example.com', password: 'Password1'),
    );

    expect(result, isA<ResultSuccess<UserEntity>>());
    expect(
      (result as ResultSuccess<UserEntity>).value.email,
      'user@example.com',
    );
    verify(() => localDataSource.cacheSession(session)).called(1);
  });

  test('requests otp through the remote data source', () async {
    when(
      () => remoteDataSource.requestPhoneOtp(any()),
    ).thenAnswer((_) async {});

    final result = await repository.requestPhoneOtp('+221701234567');

    expect(result, isA<ResultSuccess<void>>());
    verify(() => remoteDataSource.requestPhoneOtp(any())).called(1);
  });

  test(
    'caches the session and returns the role after otp verification',
    () async {
      final session = AuthSessionModel(
        user: UserModel(
          id: 'barber_001',
          email: 'barber@fotolou.local',
          name: 'King Barber',
          role: UserRole.barber,
          createdAt: DateTime.utc(2026),
        ),
        accessToken: 'access',
        refreshToken: 'refresh',
      );

      when(
        () => remoteDataSource.verifyPhoneOtp(any()),
      ).thenAnswer((_) async => session);
      when(
        () => localDataSource.cacheSession(session),
      ).thenAnswer((_) async {});

      final result = await repository.verifyPhoneOtp(
        const PhoneOtpCredentials(phone: '+221771112233', otp: '654321'),
      );

      expect(result, isA<ResultSuccess<UserEntity>>());
      expect((result as ResultSuccess<UserEntity>).value.role, UserRole.barber);
      verify(() => localDataSource.cacheSession(session)).called(1);
    },
  );

  test('maps technical exceptions to domain failures', () async {
    when(
      () => remoteDataSource.login(any()),
    ).thenThrow(const UnauthorizedException('Identifiants invalides.'));

    final result = await repository.login(
      const LoginCredentials(email: 'user@example.com', password: 'Password1'),
    );

    expect(result, isA<ResultFailure<UserEntity>>());
    expect(
      (result as ResultFailure<UserEntity>).failure,
      isA<UnauthorizedFailure>(),
    );
  });

  test('always clears the local session when remote logout fails', () async {
    when(
      () => remoteDataSource.logout(),
    ).thenThrow(const NetworkException('Réseau indisponible.'));
    when(() => localDataSource.clearSession()).thenAnswer((_) async {});

    final result = await repository.logout();

    expect(result, isA<ResultFailure<void>>());
    verify(() => localDataSource.clearSession()).called(1);
  });
}

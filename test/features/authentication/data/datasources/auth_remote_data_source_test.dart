import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/exceptions/app_exception.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:fotolou/features/authentication/data/models/login_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/phone_otp_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/verify_otp_request_dto.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';

void main() {
  test(
    'mock remote data source returns a session for valid credentials',
    () async {
      const dataSource = MockAuthRemoteDataSource(delay: Duration.zero);

      final session = await dataSource.login(
        const LoginRequestDto(
          email: 'jane.doe@example.com',
          password: 'Password1',
        ),
      );

      expect(session.user.email, 'jane.doe@example.com');
      expect(session.accessToken, isNotEmpty);
      expect(session.refreshToken, isNotEmpty);
    },
  );

  test('mock remote data source rejects blocked test accounts', () async {
    const dataSource = MockAuthRemoteDataSource(delay: Duration.zero);

    expect(
      () => dataSource.login(
        const LoginRequestDto(
          email: 'user@blocked.local',
          password: 'Password1',
        ),
      ),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('mock remote data source verifies the client phone and otp', () async {
    const dataSource = MockAuthRemoteDataSource(delay: Duration.zero);

    await dataSource.requestPhoneOtp(
      const PhoneOtpRequestDto(phone: '+221 70 123 45 67'),
    );
    final session = await dataSource.verifyPhoneOtp(
      const VerifyOtpRequestDto(phone: '+221701234567', otp: '123456'),
    );

    expect(session.user.role, UserRole.client);
    expect(session.user.name, 'Diassy');
  });

  test('mock remote data source verifies the barber phone and otp', () async {
    const dataSource = MockAuthRemoteDataSource(delay: Duration.zero);

    await dataSource.requestPhoneOtp(
      const PhoneOtpRequestDto(phone: '77 111 22 33'),
    );
    final session = await dataSource.verifyPhoneOtp(
      const VerifyOtpRequestDto(phone: '+221771112233', otp: '654321'),
    );

    expect(session.user.role, UserRole.barber);
    expect(session.user.name, 'King Barber');
  });

  test('mock remote data source rejects an invalid otp', () async {
    const dataSource = MockAuthRemoteDataSource(delay: Duration.zero);

    expect(
      () => dataSource.verifyPhoneOtp(
        const VerifyOtpRequestDto(phone: '+221701234567', otp: '000000'),
      ),
      throwsA(isA<UnauthorizedException>()),
    );
  });
}

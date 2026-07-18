import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/login_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/request_phone_otp_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/verify_phone_otp_use_case.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRequestPhoneOtpUseCase extends Mock
    implements RequestPhoneOtpUseCase {}

class MockVerifyPhoneOtpUseCase extends Mock implements VerifyPhoneOtpUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const LoginParams(email: 'user@example.com', password: 'Password1'),
    );
    registerFallbackValue(const RequestPhoneOtpParams(phone: '+221701234567'));
    registerFallbackValue(
      const VerifyPhoneOtpParams(phone: '+221701234567', otp: '123456'),
    );
  });

  late MockLoginUseCase loginUseCase;
  late MockRequestPhoneOtpUseCase requestPhoneOtpUseCase;
  late MockVerifyPhoneOtpUseCase verifyPhoneOtpUseCase;
  late MockLogoutUseCase logoutUseCase;
  late MockGetCurrentUserUseCase getCurrentUserUseCase;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    requestPhoneOtpUseCase = MockRequestPhoneOtpUseCase();
    verifyPhoneOtpUseCase = MockVerifyPhoneOtpUseCase();
    logoutUseCase = MockLogoutUseCase();
    getCurrentUserUseCase = MockGetCurrentUserUseCase();

    when(
      () => getCurrentUserUseCase(any()),
    ).thenAnswer((_) async => const ResultSuccess<UserEntity?>(null));
  });

  test('moves from empty session to success after login', () async {
    const user = UserEntity(
      id: 'usr_1',
      email: 'user@example.com',
      name: 'User',
    );

    when(
      () => loginUseCase(any()),
    ).thenAnswer((_) async => const ResultSuccess<UserEntity>(user));

    final container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(loginUseCase),
        requestPhoneOtpUseCaseProvider.overrideWithValue(
          requestPhoneOtpUseCase,
        ),
        verifyPhoneOtpUseCaseProvider.overrideWithValue(verifyPhoneOtpUseCase),
        logoutUseCaseProvider.overrideWithValue(logoutUseCase),
        getCurrentUserUseCaseProvider.overrideWithValue(getCurrentUserUseCase),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(authControllerProvider.notifier);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(authControllerProvider).status, AuthStatus.empty);

    await controller.login(email: 'user@example.com', password: 'Password1');

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.success);
    expect(state.user, user);
  });
}

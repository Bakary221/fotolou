import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/failures/failure.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/domain/entities/login_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fotolou/features/authentication/domain/usecases/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const LoginCredentials(email: 'user@example.com', password: 'Password1'),
    );
  });

  late AuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('returns a validation failure when email is invalid', () async {
    final result = await useCase(
      const LoginParams(email: 'invalid', password: 'Password1'),
    );

    expect(result, isA<ResultFailure<UserEntity>>());
    expect(
      (result as ResultFailure<UserEntity>).failure,
      isA<ValidationFailure>(),
    );
    verifyNever(() => repository.login(any()));
  });

  test('delegates valid credentials to the repository', () async {
    const user = UserEntity(
      id: 'usr_1',
      email: 'user@example.com',
      name: 'User',
    );

    when(
      () => repository.login(any()),
    ).thenAnswer((_) async => const ResultSuccess<UserEntity>(user));

    final result = await useCase(
      const LoginParams(email: 'user@example.com', password: 'Password1'),
    );

    expect(result, isA<ResultSuccess<UserEntity>>());
    expect((result as ResultSuccess<UserEntity>).value, user);

    final credentials =
        verify(() => repository.login(captureAny())).captured.single
            as LoginCredentials;
    expect(credentials.email, 'user@example.com');
  });
}

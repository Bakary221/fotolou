import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/network/token_refresher.dart';
import 'package:fotolou/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockDio dio;
  late MockTokenStorage tokenStorage;
  late DioTokenRefresher tokenRefresher;

  setUp(() {
    dio = MockDio();
    tokenStorage = MockTokenStorage();
    tokenRefresher = DioTokenRefresher(dio: dio, tokenStorage: tokenStorage);
  });

  test('returns false without a refresh token', () async {
    when(() => tokenStorage.readRefreshToken()).thenAnswer((_) async => null);

    expect(await tokenRefresher.refreshToken(), isFalse);
    verifyNever(
      () => dio.post<Object?>(any(), data: any<Object?>(named: 'data')),
    );
  });

  test('stores access and rotated refresh tokens', () async {
    when(
      () => tokenStorage.readRefreshToken(),
    ).thenAnswer((_) async => 'old-refresh');
    when(
      () => dio.post<Object?>(
        '/auth/refresh',
        data: {'refreshToken': 'old-refresh'},
      ),
    ).thenAnswer(
      (_) async => Response<Object?>(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        data: const {
          'accessToken': 'new-access',
          'refreshToken': 'new-refresh',
        },
      ),
    );
    when(
      () => tokenStorage.saveTokens(
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
      ),
    ).thenAnswer((_) async {});

    expect(await tokenRefresher.refreshToken(), isTrue);
    verify(
      () => tokenStorage.saveTokens(
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
      ),
    ).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/validators/app_validators.dart';

void main() {
  test('validates email values', () {
    expect(AppValidators.email('user@example.com'), isNull);
    expect(AppValidators.email('invalid'), 'Saisissez un email valide.');
  });

  test('validates password length', () {
    expect(AppValidators.password('Password1'), isNull);
    expect(
      AppValidators.password('short'),
      'Le mot de passe doit contenir au moins 8 caractères.',
    );
  });

  test('validates otp values', () {
    expect(AppValidators.otp('123456'), isNull);
    expect(AppValidators.otp('12345'), 'Le code OTP doit contenir 6 chiffres.');
    expect(
      AppValidators.otp('abcdef'),
      'Le code OTP doit contenir 6 chiffres.',
    );
  });
}

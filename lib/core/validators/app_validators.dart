import 'package:fotolou/core/extensions/string_extensions.dart';

abstract final class AppValidators {
  static String? requiredField(String? value, {String fieldName = 'Ce champ'}) {
    if (value.isBlank) {
      return '$fieldName est requis.';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'L’email');
    if (requiredError != null) {
      return requiredError;
    }

    final normalizedValue = value!.trim();
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(normalizedValue)) {
      return 'Saisissez un email valide.';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, fieldName: 'Le mot de passe');
    if (requiredError != null) {
      return requiredError;
    }

    final passwordValue = value!;
    if (passwordValue.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères.';
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final passwordError = AppValidators.password(value);
    if (passwordError != null) {
      return passwordError;
    }

    if (value != password) {
      return 'Les mots de passe ne correspondent pas.';
    }

    return null;
  }

  static String? phone(String? value) {
    final requiredError = requiredField(value, fieldName: 'Le téléphone');
    if (requiredError != null) {
      return requiredError;
    }

    final normalizedValue = value!.replaceAll(RegExp(r'[\s().-]'), '');
    final pattern = RegExp(r'^\+?[0-9]{8,15}$');
    if (!pattern.hasMatch(normalizedValue)) {
      return 'Saisissez un numéro de téléphone valide.';
    }

    return null;
  }

  static String? otp(String? value) {
    final requiredError = requiredField(value, fieldName: 'Le code OTP');
    if (requiredError != null) {
      return requiredError;
    }

    final normalizedValue = value!.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(normalizedValue)) {
      return 'Le code OTP doit contenir 6 chiffres.';
    }

    return null;
  }
}

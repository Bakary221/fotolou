import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

@immutable
class AppBrandTextTheme extends ThemeExtension<AppBrandTextTheme> {
  const AppBrandTextTheme({
    required this.splashLogoTitle,
    required this.splashTagline,
    required this.splashVersion,
    required this.logoLetter,
    required this.onboardingTitle,
    required this.onboardingBody,
    required this.onboardingButton,
    required this.phoneTitle,
    required this.phoneSubtitle,
    required this.phoneLabel,
    required this.phoneCode,
    required this.phonePlaceholder,
    required this.phoneSubmit,
    required this.legal,
    required this.legalLink,
    required this.otpTitle,
    required this.otpSubtitle,
    required this.otpCode,
    required this.otpResend,
  });

  static const light = AppBrandTextTheme(
    splashLogoTitle: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 0,
    ),
    splashTagline: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 14,
      fontWeight: FontWeight.w200,
      height: 1.2,
      letterSpacing: 0,
    ),
    splashVersion: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0,
    ),
    logoLetter: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 64,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 0,
    ),
    onboardingTitle: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 0,
    ),
    onboardingBody: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    ),
    onboardingButton: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0,
    ),
    phoneTitle: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.125,
      letterSpacing: -0.75,
    ),
    phoneSubtitle: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1,
      letterSpacing: 0,
    ),
    phoneLabel: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: 0,
    ),
    phoneCode: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0,
    ),
    phonePlaceholder: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.2,
      letterSpacing: 0,
    ),
    phoneSubmit: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.55,
      letterSpacing: 0,
    ),
    legal: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.895,
      letterSpacing: 0,
    ),
    legalLink: TextStyle(
      fontFamily: AppFonts.inter,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.895,
      letterSpacing: 0,
    ),
    otpTitle: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1,
      letterSpacing: 0,
    ),
    otpSubtitle: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      height: 2,
      letterSpacing: 0,
    ),
    otpCode: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.4,
      letterSpacing: 0,
    ),
    otpResend: TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0,
    ),
  );

  final TextStyle splashLogoTitle;
  final TextStyle splashTagline;
  final TextStyle splashVersion;
  final TextStyle logoLetter;
  final TextStyle onboardingTitle;
  final TextStyle onboardingBody;
  final TextStyle onboardingButton;
  final TextStyle phoneTitle;
  final TextStyle phoneSubtitle;
  final TextStyle phoneLabel;
  final TextStyle phoneCode;
  final TextStyle phonePlaceholder;
  final TextStyle phoneSubmit;
  final TextStyle legal;
  final TextStyle legalLink;
  final TextStyle otpTitle;
  final TextStyle otpSubtitle;
  final TextStyle otpCode;
  final TextStyle otpResend;

  @override
  AppBrandTextTheme copyWith({
    TextStyle? splashLogoTitle,
    TextStyle? splashTagline,
    TextStyle? splashVersion,
    TextStyle? logoLetter,
    TextStyle? onboardingTitle,
    TextStyle? onboardingBody,
    TextStyle? onboardingButton,
    TextStyle? phoneTitle,
    TextStyle? phoneSubtitle,
    TextStyle? phoneLabel,
    TextStyle? phoneCode,
    TextStyle? phonePlaceholder,
    TextStyle? phoneSubmit,
    TextStyle? legal,
    TextStyle? legalLink,
    TextStyle? otpTitle,
    TextStyle? otpSubtitle,
    TextStyle? otpCode,
    TextStyle? otpResend,
  }) {
    return AppBrandTextTheme(
      splashLogoTitle: splashLogoTitle ?? this.splashLogoTitle,
      splashTagline: splashTagline ?? this.splashTagline,
      splashVersion: splashVersion ?? this.splashVersion,
      logoLetter: logoLetter ?? this.logoLetter,
      onboardingTitle: onboardingTitle ?? this.onboardingTitle,
      onboardingBody: onboardingBody ?? this.onboardingBody,
      onboardingButton: onboardingButton ?? this.onboardingButton,
      phoneTitle: phoneTitle ?? this.phoneTitle,
      phoneSubtitle: phoneSubtitle ?? this.phoneSubtitle,
      phoneLabel: phoneLabel ?? this.phoneLabel,
      phoneCode: phoneCode ?? this.phoneCode,
      phonePlaceholder: phonePlaceholder ?? this.phonePlaceholder,
      phoneSubmit: phoneSubmit ?? this.phoneSubmit,
      legal: legal ?? this.legal,
      legalLink: legalLink ?? this.legalLink,
      otpTitle: otpTitle ?? this.otpTitle,
      otpSubtitle: otpSubtitle ?? this.otpSubtitle,
      otpCode: otpCode ?? this.otpCode,
      otpResend: otpResend ?? this.otpResend,
    );
  }

  @override
  AppBrandTextTheme lerp(ThemeExtension<AppBrandTextTheme>? other, double t) {
    if (other is! AppBrandTextTheme) {
      return this;
    }

    return AppBrandTextTheme(
      splashLogoTitle: TextStyle.lerp(
        splashLogoTitle,
        other.splashLogoTitle,
        t,
      )!,
      splashTagline: TextStyle.lerp(splashTagline, other.splashTagline, t)!,
      splashVersion: TextStyle.lerp(splashVersion, other.splashVersion, t)!,
      logoLetter: TextStyle.lerp(logoLetter, other.logoLetter, t)!,
      onboardingTitle: TextStyle.lerp(
        onboardingTitle,
        other.onboardingTitle,
        t,
      )!,
      onboardingBody: TextStyle.lerp(onboardingBody, other.onboardingBody, t)!,
      onboardingButton: TextStyle.lerp(
        onboardingButton,
        other.onboardingButton,
        t,
      )!,
      phoneTitle: TextStyle.lerp(phoneTitle, other.phoneTitle, t)!,
      phoneSubtitle: TextStyle.lerp(phoneSubtitle, other.phoneSubtitle, t)!,
      phoneLabel: TextStyle.lerp(phoneLabel, other.phoneLabel, t)!,
      phoneCode: TextStyle.lerp(phoneCode, other.phoneCode, t)!,
      phonePlaceholder: TextStyle.lerp(
        phonePlaceholder,
        other.phonePlaceholder,
        t,
      )!,
      phoneSubmit: TextStyle.lerp(phoneSubmit, other.phoneSubmit, t)!,
      legal: TextStyle.lerp(legal, other.legal, t)!,
      legalLink: TextStyle.lerp(legalLink, other.legalLink, t)!,
      otpTitle: TextStyle.lerp(otpTitle, other.otpTitle, t)!,
      otpSubtitle: TextStyle.lerp(otpSubtitle, other.otpSubtitle, t)!,
      otpCode: TextStyle.lerp(otpCode, other.otpCode, t)!,
      otpResend: TextStyle.lerp(otpResend, other.otpResend, t)!,
    );
  }
}

extension AppBrandTextThemeX on BuildContext {
  AppBrandTextTheme get brandTextTheme {
    return Theme.of(this).extension<AppBrandTextTheme>()!;
  }
}

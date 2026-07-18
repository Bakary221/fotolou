import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_system_ui.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/figma_frame.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_assets.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_bottom_action.dart';
import 'package:fotolou/shared/widgets/app_otp_input.dart';
import 'package:fotolou/shared/widgets/responsive_design_viewport.dart';
import 'package:go_router/go_router.dart';

abstract final class OtpTokens {
  static Key otpBoxKey(int index) => ValueKey('otp_box_$index');

  static const backLeft = 24.0;
  static const backTop = 94.0;
  static const backSize = 24.0;
  static const contentLeft = 44.0;
  static const titleTop = 177.0;
  static const contentWidth = 352.0;
  static const subtitleTop = 224.0;
  static const otpTop = 344.0;
  static const otpBoxWidth = 48.0;
  static const otpBoxHeight = 56.0;
  static const otpBoxRadius = 12.0;
  static const resendTop = 441.0;
  static const buttonTop = 796.0;
}

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({this.phone, super.key});

  final String? phone;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  var _otpCode = '';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: ResponsiveDesignViewport(
          child: FigmaFrame(
            backgroundColor: AppColors.white,
            builder: (context, metrics) {
              return Stack(
                children: [
                  Positioned(
                    left: metrics.x(OtpTokens.backLeft),
                    top: metrics.y(OtpTokens.backTop),
                    child: Semantics(
                      button: true,
                      label: 'Retour',
                      child: GestureDetector(
                        onTap: () => context.goNamed(AppRoute.phoneLogin.name),
                        child: SvgPicture.asset(
                          OnboardingAssets.back,
                          width: metrics.s(OtpTokens.backSize),
                          height: metrics.s(OtpTokens.backSize),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: metrics.x(OtpTokens.contentLeft),
                    top: metrics.y(OtpTokens.titleTop),
                    width: metrics.s(OtpTokens.contentWidth),
                    child: _OtpHeader(
                      phone: _formattedPhone,
                      scale: metrics.scale,
                    ),
                  ),
                  Positioned(
                    left: metrics.x(OtpTokens.contentLeft),
                    top: metrics.y(OtpTokens.otpTop),
                    width: metrics.s(OtpTokens.contentWidth),
                    child: AppOtpInput(
                      boxKeyBuilder: OtpTokens.otpBoxKey,
                      scale: metrics.scale,
                      onChanged: (value) => _otpCode = value,
                    ),
                  ),
                  Positioned(
                    left: metrics.x(OtpTokens.contentLeft),
                    top: metrics.y(OtpTokens.resendTop),
                    width: metrics.s(OtpTokens.contentWidth),
                    child: _ResendText(scale: metrics.scale),
                  ),
                  Positioned(
                    left: metrics.x(OnboardingBottomActionTokens.left),
                    top: metrics.y(OtpTokens.buttonTop),
                    child: OnboardingBottomAction(
                      label: 'verifier',
                      iconAsset: OnboardingAssets.verifyArrow,
                      isEnabled: authState.status != AuthStatus.loading,
                      scale: metrics.scale,
                      onPressed: _verify,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _verify() async {
    final phone = widget.phone;
    if (phone == null || phone.isEmpty) {
      _showMessage('Veuillez saisir votre numéro de téléphone.');
      context.goNamed(AppRoute.phoneLogin.name);
      return;
    }

    final user = await ref
        .read(authControllerProvider.notifier)
        .verifyPhoneOtp(phone: phone, otp: _otpCode);
    if (!mounted) {
      return;
    }

    if (user == null) {
      final message =
          ref.read(authControllerProvider).message ?? 'Code OTP invalide.';
      _showMessage(message);
      return;
    }

    context.goNamed(_routeForRole(user.role).name);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String get _formattedPhone {
    final rawPhone = widget.phone ?? '+221 70 123 45 67';
    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    final nationalDigits = digits.startsWith('221')
        ? digits.substring(3)
        : digits;
    if (nationalDigits.length != 9) {
      return rawPhone;
    }

    return '+221 ${nationalDigits.substring(0, 2)} '
        '${nationalDigits.substring(2, 5)} '
        '${nationalDigits.substring(5, 7)} '
        '${nationalDigits.substring(7)}';
  }

  AppRoute _routeForRole(UserRole role) {
    return switch (role) {
      UserRole.client => AppRoute.clientHome,
      UserRole.barber => AppRoute.barberHome,
    };
  }
}

class _OtpHeader extends StatelessWidget {
  const _OtpHeader({required this.phone, required this.scale});

  final String phone;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return Column(
      children: [
        Text(
          'Entrez le code',
          textAlign: TextAlign.center,
          style: brandTextTheme.otpTitle.copyWith(
            color: AppColors.ink,
            fontSize: brandTextTheme.otpTitle.fontSize! * scale,
          ),
        ),
        SizedBox(
          height: (OtpTokens.subtitleTop - OtpTokens.titleTop - 36) * scale,
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Nous avons envoyé un code OTP\nau '),
              TextSpan(
                text: phone,
                style: brandTextTheme.otpSubtitle.copyWith(
                  color: AppColors.gray800,
                  fontSize: brandTextTheme.otpSubtitle.fontSize! * scale,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: brandTextTheme.otpSubtitle.copyWith(
            color: AppColors.gray600,
            fontSize: brandTextTheme.otpSubtitle.fontSize! * scale,
          ),
        ),
      ],
    );
  }
}

class _ResendText extends StatelessWidget {
  const _ResendText({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return Text(
      'Renvoyer le code dans 00:45',
      textAlign: TextAlign.center,
      style: brandTextTheme.otpResend.copyWith(
        color: AppColors.gray600,
        fontSize: brandTextTheme.otpResend.fontSize! * scale,
      ),
    );
  }
}

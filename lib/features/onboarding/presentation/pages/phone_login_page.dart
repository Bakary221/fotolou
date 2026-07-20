import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/app/theme/app_system_ui.dart';
import 'package:fotolou/core/validators/app_validators.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/figma_frame.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_assets.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_bottom_action.dart';
import 'package:go_router/go_router.dart';

abstract final class PhoneLoginTokens {
  static const inputFrameKey = Key('phone_input_frame');
  static const countrySelectorFrameKey = Key('phone_country_selector_frame');
  static const headerLeft = 19.0;
  static const headerTop = 193.0;
  static const headerWidth = 342.0;
  static const headerGap = 8.0;
  static const formLeft = 20.0;
  static const formTop = 286.0;
  static const formWidth = 400.0;
  static const inputLabelGap = 8.0;
  static const inputHeight = 80.0;
  static const inputRadius = 12.0;
  static const countryWidth = 108.0;
  static const flagLeft = 12.0;
  static const codeLeft = 43.0;
  static const dropdownLeft = 85.0;
  static const dropdownWidth = 10.6667;
  static const dropdownHeight = 6.0;
  static const placeholderLeft = 125.0;
  static const legalCenterY = 903.0;
  static const legalWidth = 360.0;
}

class PhoneLoginPage extends ConsumerStatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  ConsumerState<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends ConsumerState<PhoneLoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: FigmaFrameTokens.width,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final scale =
                      ((constraints.maxWidth - AppSpacing.pageHorizontal * 2) /
                              PhoneLoginTokens.formWidth)
                          .clamp(0.68, 1.0)
                          .toDouble();
                  final isTight = constraints.maxHeight < 560;
                  final topGap = (constraints.maxHeight * 0.24)
                      .clamp(isTight ? 28.0 : 96.0, 184.0)
                      .toDouble();
                  final fieldGap = isTight ? 14.0 : 20.0;
                  final legalGap = isTight ? 8.0 : 14.0;
                  final bottomGap = (constraints.maxHeight * 0.04)
                      .clamp(12.0, 32.0)
                      .toDouble();

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: topGap),
                        _PhoneHeader(scale: scale),
                        SizedBox(height: fieldGap),
                        _PhoneInput(
                          controller: _phoneController,
                          scale: scale,
                          onSubmitted: _submit,
                        ),
                        const Spacer(),
                        Center(
                          child: OnboardingBottomAction(
                            label: 'Continuer',
                            isPrimary: true,
                            isLoading: authState.status == AuthStatus.loading,
                            scale: scale,
                            onPressed: _submit,
                          ),
                        ),
                        SizedBox(height: legalGap),
                        Center(child: _LegalText(scale: scale)),
                        SizedBox(height: bottomGap),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final phone = _fullPhoneNumber(_phoneController.text);
    final phoneError = AppValidators.phone(phone);
    if (phoneError != null) {
      _showMessage(phoneError);
      return;
    }

    final success = await ref
        .read(authControllerProvider.notifier)
        .requestPhoneOtp(phone: phone);
    if (!mounted) {
      return;
    }

    if (success) {
      context.goNamed(AppRoute.otp.name, queryParameters: {'phone': phone});
      return;
    }

    final message =
        ref.read(authControllerProvider).message ??
        'Impossible d’envoyer le code OTP.';
    _showMessage(message);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _fullPhoneNumber(String rawPhone) {
    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('221')) {
      return '+$digits';
    }

    return '+221$digits';
  }
}

class _PhoneHeader extends StatelessWidget {
  const _PhoneHeader({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenue 👋',
          style: brandTextTheme.phoneTitle.copyWith(
            color: AppColors.slate900,
            fontSize: brandTextTheme.phoneTitle.fontSize! * scale,
          ),
        ),
        SizedBox(height: PhoneLoginTokens.headerGap * scale),
        Text(
          'Connecte-toi pour continuer',
          style: brandTextTheme.phoneSubtitle.copyWith(
            color: AppColors.slate500,
            fontSize: brandTextTheme.phoneSubtitle.fontSize! * scale,
          ),
        ),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput({
    required this.controller,
    required this.scale,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final double scale;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Téléphone',
          style: brandTextTheme.phoneLabel.copyWith(
            color: AppColors.slate800,
            fontSize: brandTextTheme.phoneLabel.fontSize! * scale,
          ),
        ),
        SizedBox(height: PhoneLoginTokens.inputLabelGap * scale),
        SizedBox(
          key: PhoneLoginTokens.inputFrameKey,
          width: PhoneLoginTokens.formWidth * scale,
          height: PhoneLoginTokens.inputHeight * scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.gray200, width: scale),
              borderRadius: BorderRadius.circular(
                PhoneLoginTokens.inputRadius * scale,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                PhoneLoginTokens.inputRadius * scale,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    width: PhoneLoginTokens.countryWidth * scale,
                    height: PhoneLoginTokens.inputHeight * scale,
                    child: DecoratedBox(
                      key: PhoneLoginTokens.countrySelectorFrameKey,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.gray200,
                          width: scale,
                        ),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(
                            PhoneLoginTokens.inputRadius * scale,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: PhoneLoginTokens.flagLeft * scale,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                '🇸🇳',
                                style: brandTextTheme.phonePlaceholder.copyWith(
                                  color: AppColors.slate900,
                                  fontSize:
                                      brandTextTheme
                                          .phonePlaceholder
                                          .fontSize! *
                                      scale,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: PhoneLoginTokens.codeLeft * scale,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                '+221',
                                style: brandTextTheme.phoneCode.copyWith(
                                  color: AppColors.slate800,
                                  fontSize:
                                      brandTextTheme.phoneCode.fontSize! *
                                      scale,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: PhoneLoginTokens.dropdownLeft * scale,
                            top:
                                (PhoneLoginTokens.inputHeight -
                                    PhoneLoginTokens.dropdownHeight) *
                                scale /
                                2,
                            child: SvgPicture.asset(
                              OnboardingAssets.dropdown,
                              width: PhoneLoginTokens.dropdownWidth * scale,
                              height: PhoneLoginTokens.dropdownHeight * scale,
                              colorFilter: const ColorFilter.mode(
                                AppColors.slate500,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: PhoneLoginTokens.placeholderLeft * scale,
                    top: 0,
                    right: 12 * scale,
                    bottom: 0,
                    child: Center(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                        ],
                        onSubmitted: (_) => onSubmitted(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: false,
                          counterText: '',
                          hintText: '70 123 45 67',
                          isCollapsed: true,
                          hintStyle: brandTextTheme.phonePlaceholder.copyWith(
                            color: AppColors.slate300,
                            fontSize:
                                brandTextTheme.phonePlaceholder.fontSize! *
                                scale,
                          ),
                        ),
                        style: brandTextTheme.phonePlaceholder.copyWith(
                          color: AppColors.slate900,
                          fontSize:
                              brandTextTheme.phonePlaceholder.fontSize! * scale,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;
    final baseStyle = brandTextTheme.legal.copyWith(
      color: AppColors.slate500,
      fontSize: brandTextTheme.legal.fontSize! * scale,
    );
    final linkStyle = brandTextTheme.legalLink.copyWith(
      color: AppColors.primary,
      fontSize: brandTextTheme.legalLink.fontSize! * scale,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'En continuant, tu acceptes nos ', style: baseStyle),
          TextSpan(text: 'Conditions\nd’utilisation', style: linkStyle),
          TextSpan(text: ' et notre ', style: baseStyle),
          TextSpan(text: 'Politique de confidentialité', style: linkStyle),
          TextSpan(text: '.', style: baseStyle),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

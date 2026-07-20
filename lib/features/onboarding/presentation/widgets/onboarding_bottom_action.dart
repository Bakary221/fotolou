import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_assets.dart';

abstract final class OnboardingBottomActionTokens {
  static const left = AppSpacing.pageHorizontal;
  static const top = 23.0;
  static const width = 400.0;
  static const height = 73.0;
  static const radius = 30.0;
  static const iconSize = 16.0;
  static const iconGap = 10.0;
  static const shadowBlur = 10.0;
}

class OnboardingBottomAction extends StatelessWidget {
  const OnboardingBottomAction({
    required this.label,
    required this.onPressed,
    required this.scale,
    this.isPrimary = false,
    this.isEnabled = true,
    this.isLoading = false,
    this.iconAsset = OnboardingAssets.arrowNext,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final double scale;
  final bool isPrimary;
  final bool isEnabled;
  final bool isLoading;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;
    final backgroundColor = isPrimary ? AppColors.primary : AppColors.white;
    final foregroundColor = isPrimary ? AppColors.white : AppColors.actionBlue;

    return SizedBox(
      width: OnboardingBottomActionTokens.width * scale,
      height: OnboardingBottomActionTokens.height * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            OnboardingBottomActionTokens.radius * scale,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowBlack25,
              blurRadius: OnboardingBottomActionTokens.shadowBlur,
            ),
          ],
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              OnboardingBottomActionTokens.radius * scale,
            ),
            onTap: isEnabled && !isLoading ? onPressed : null,
            child: Center(
              child: isLoading
                  ? SizedBox.square(
                      dimension: 22 * scale,
                      child: CircularProgressIndicator(
                        strokeWidth: 2 * scale,
                        color: foregroundColor,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: brandTextTheme.onboardingButton.copyWith(
                            color: foregroundColor,
                            fontSize:
                                brandTextTheme.onboardingButton.fontSize! *
                                scale,
                          ),
                        ),
                        SizedBox(
                          width: OnboardingBottomActionTokens.iconGap * scale,
                        ),
                        SvgPicture.asset(
                          iconAsset,
                          width: OnboardingBottomActionTokens.iconSize * scale,
                          height: OnboardingBottomActionTokens.iconSize * scale,
                          colorFilter: ColorFilter.mode(
                            foregroundColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

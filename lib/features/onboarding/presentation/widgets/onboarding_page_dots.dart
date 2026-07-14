import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';

abstract final class OnboardingPageDotsTokens {
  static const dotHeight = 10.0;
  static const activeWidth = 50.0;
  static const inactiveWidth = 25.0;
  static const radius = 20.0;
  static const gap = 9.0;
}

class OnboardingPageDots extends StatelessWidget {
  const OnboardingPageDots({
    required this.currentIndex,
    required this.count,
    required this.scale,
    super.key,
  });

  final int currentIndex;
  final int count;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return Padding(
          padding: EdgeInsets.only(
            right: index == count - 1
                ? 0
                : OnboardingPageDotsTokens.gap * scale,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondary : AppColors.mutedInk,
              borderRadius: BorderRadius.circular(
                OnboardingPageDotsTokens.radius * scale,
              ),
            ),
            child: SizedBox(
              width:
                  (isActive
                      ? OnboardingPageDotsTokens.activeWidth
                      : OnboardingPageDotsTokens.inactiveWidth) *
                  scale,
              height: OnboardingPageDotsTokens.dotHeight * scale,
            ),
          ),
        );
      }),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/shared/widgets/fotolou_logo.dart';
import 'package:go_router/go_router.dart';

abstract final class SplashDesignTokens {
  static const frameWidth = 440.0;
  static const frameHeight = 956.0;
  static const logoGroupLeft = 50.0;
  static const logoGroupTop = 390.0;
  static const logoGroupWidth = 286.0;
  static const logoGroupHeight = 123.0;
  static const logoTitleLeft = 135.0;
  static const logoTitleTop = 17.0;
  static const taglineLeft = 137.0;
  static const taglineTop = 78.0;
  static const progressTop = 557.0;
  static const progressWidth = 109.0;
  static const progressHeight = 10.0;
  static const progressValueWidth = 64.0;
  static const versionTop = 905.0;
  static const navigationDelay = Duration(milliseconds: 1800);
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(SplashDesignTokens.navigationDelay, () {
      if (!mounted) {
        return;
      }

      context.goNamed(AppRoute.onboarding.name);
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: _SplashCanvas(),
      ),
    );
  }
}

class _SplashCanvas extends StatelessWidget {
  const _SplashCanvas();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final widthScale = size.width / SplashDesignTokens.frameWidth;
        final heightScale = size.height / SplashDesignTokens.frameHeight;
        final scale = widthScale < heightScale ? widthScale : heightScale;
        final scaledFrameWidth = SplashDesignTokens.frameWidth * scale;
        final scaledFrameHeight = SplashDesignTokens.frameHeight * scale;
        final xOffset = (size.width - scaledFrameWidth) / 2;
        final yOffset = (size.height - scaledFrameHeight) / 2;

        double x(double value) => xOffset + value * scale;
        double y(double value) => yOffset + value * scale;

        return ColoredBox(
          color: AppColors.primary,
          child: Stack(
            children: [
              Positioned(
                left: x(SplashDesignTokens.logoGroupLeft),
                top: y(SplashDesignTokens.logoGroupTop),
                child: _LogoLockup(scale: scale),
              ),
              Positioned(
                left: x(
                  (SplashDesignTokens.frameWidth -
                          SplashDesignTokens.progressWidth) /
                      2,
                ),
                top: y(SplashDesignTokens.progressTop),
                child: _SplashProgress(scale: scale),
              ),
              Positioned(
                top: y(SplashDesignTokens.versionTop),
                left: 0,
                right: 0,
                child: _VersionText(scale: scale),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogoLockup extends StatelessWidget {
  const _LogoLockup({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return SizedBox(
      width: SplashDesignTokens.logoGroupWidth * scale,
      height: SplashDesignTokens.logoGroupHeight * scale,
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: scale,
        child: SizedBox(
          width: SplashDesignTokens.logoGroupWidth,
          height: SplashDesignTokens.logoGroupHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const FotolouLogoMark(),
              Positioned(
                left: SplashDesignTokens.logoTitleLeft,
                top: SplashDesignTokens.logoTitleTop,
                child: Text(
                  'Fotolou',
                  style: brandTextTheme.splashLogoTitle.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              Positioned(
                left: SplashDesignTokens.taglineLeft,
                top: SplashDesignTokens.taglineTop,
                child: Text(
                  'Moins d’attente. Plus de temps.',
                  style: brandTextTheme.splashTagline.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashProgress extends StatelessWidget {
  const _SplashProgress({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SplashDesignTokens.progressWidth * scale,
      height: SplashDesignTokens.progressHeight * scale,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          SplashDesignTokens.progressHeight * scale,
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: AppColors.splashProgressTrack),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ColoredBox(
                color: AppColors.white,
                child: SizedBox(
                  width: SplashDesignTokens.progressValueWidth * scale,
                  height: SplashDesignTokens.progressHeight * scale,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionText extends StatelessWidget {
  const _VersionText({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return Transform.scale(
      scale: scale,
      child: Text(
        'version 1.0.0',
        textAlign: TextAlign.center,
        style: brandTextTheme.splashVersion.copyWith(color: AppColors.white),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';

abstract final class FotolouLogoTokens {
  static const markWidth = 122.0;
  static const markHeight = 123.0;
  static const ticketWidth = 76.0;
  static const ticketHeight = 115.0;
  static const ticketLeft = 33.2;
  static const ticketRadius = 10.0;
  static const ticketRotationDegrees = 6.0;
  static const speedLineHeight = 8.0;
  static const speedLineRadius = 20.0;
  static const speedLineShortWidth = 21.0;
  static const speedLineLongWidth = 32.0;
  static const firstSpeedLineLeft = 14.0;
  static const secondSpeedLineLeft = 0.0;
  static const thirdSpeedLineLeft = 8.0;
  static const speedLineTop = 28.66;
  static const speedLineGap = 16.0;
  static const notchWidth = 17.0;
  static const notchHeight = 35.0;
  static const firstNotchLeft = 15.15;
  static const secondNotchLeft = 42.21;
  static const notchTop = 101.63;
  static const letterLeft = 24.0;
  static const letterTop = 5.0;
  static const sparkleWidth = 28.0;
  static const sparkleHeight = 21.0;
  static const sparkleLeft = 67.0;
  static const sparkleTop = -11.0;
}

class FotolouLogoMark extends StatelessWidget {
  const FotolouLogoMark({
    this.scale = 1,
    this.ticketColor = AppColors.white,
    this.contentColor = AppColors.secondary,
    this.speedLineColor = AppColors.white,
    this.showSpeedLines = true,
    super.key,
  });

  final double scale;
  final Color ticketColor;
  final Color contentColor;
  final Color speedLineColor;
  final bool showSpeedLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: FotolouLogoTokens.markWidth * scale,
      height: FotolouLogoTokens.markHeight * scale,
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: scale,
        child: SizedBox(
          width: FotolouLogoTokens.markWidth,
          height: FotolouLogoTokens.markHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (showSpeedLines) ...[
                _SpeedLine(
                  width: FotolouLogoTokens.speedLineShortWidth,
                  left: FotolouLogoTokens.firstSpeedLineLeft,
                  top: FotolouLogoTokens.speedLineTop,
                  color: speedLineColor,
                ),
                _SpeedLine(
                  width: FotolouLogoTokens.speedLineLongWidth,
                  left: FotolouLogoTokens.secondSpeedLineLeft,
                  top:
                      FotolouLogoTokens.speedLineTop +
                      FotolouLogoTokens.speedLineGap +
                      FotolouLogoTokens.speedLineHeight,
                  color: speedLineColor,
                ),
                _SpeedLine(
                  width: FotolouLogoTokens.speedLineShortWidth,
                  left: FotolouLogoTokens.thirdSpeedLineLeft,
                  top:
                      FotolouLogoTokens.speedLineTop +
                      (FotolouLogoTokens.speedLineGap +
                              FotolouLogoTokens.speedLineHeight) *
                          2,
                  color: speedLineColor,
                ),
              ],
              Positioned(
                left: FotolouLogoTokens.ticketLeft,
                top: 0,
                child: Transform.rotate(
                  angle:
                      FotolouLogoTokens.ticketRotationDegrees * math.pi / 180,
                  child: _LogoTicket(
                    ticketColor: ticketColor,
                    contentColor: contentColor,
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

class _SpeedLine extends StatelessWidget {
  const _SpeedLine({
    required this.width,
    required this.left,
    required this.top,
    required this.color,
  });

  final double width;
  final double left;
  final double top;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            FotolouLogoTokens.speedLineRadius,
          ),
        ),
        child: SizedBox(
          width: width,
          height: FotolouLogoTokens.speedLineHeight,
        ),
      ),
    );
  }
}

class _LogoTicket extends StatelessWidget {
  const _LogoTicket({required this.ticketColor, required this.contentColor});

  final Color ticketColor;
  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(FotolouLogoTokens.ticketRadius),
      child: ColoredBox(
        color: ticketColor,
        child: SizedBox(
          width: FotolouLogoTokens.ticketWidth,
          height: FotolouLogoTokens.ticketHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: FotolouLogoTokens.firstNotchLeft,
                top: FotolouLogoTokens.notchTop,
                child: _LogoOval(color: contentColor),
              ),
              Positioned(
                left: FotolouLogoTokens.secondNotchLeft,
                top: FotolouLogoTokens.notchTop - 0.83,
                child: _LogoOval(color: contentColor),
              ),
              Positioned(
                left: FotolouLogoTokens.letterLeft,
                top: FotolouLogoTokens.letterTop,
                child: Text(
                  'F',
                  style: brandTextTheme.logoLetter.copyWith(
                    color: contentColor,
                  ),
                ),
              ),
              Positioned(
                left: FotolouLogoTokens.sparkleLeft,
                top: FotolouLogoTokens.sparkleTop,
                child: Transform.rotate(
                  angle:
                      FotolouLogoTokens.ticketRotationDegrees * math.pi / 180,
                  child: _LogoOval(
                    width: FotolouLogoTokens.sparkleWidth,
                    height: FotolouLogoTokens.sparkleHeight,
                    color: contentColor,
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

class _LogoOval extends StatelessWidget {
  const _LogoOval({
    required this.color,
    this.width = FotolouLogoTokens.notchWidth,
    this.height = FotolouLogoTokens.notchHeight,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.elliptical(width, height)),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}

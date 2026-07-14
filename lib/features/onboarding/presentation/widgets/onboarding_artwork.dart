import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_assets.dart';

enum OnboardingArtworkType { ticket, queue, time }

class OnboardingArtwork extends StatelessWidget {
  const OnboardingArtwork({required this.type, required this.scale, super.key});

  final OnboardingArtworkType type;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      OnboardingArtworkType.ticket => _TicketArtwork(scale: scale),
      OnboardingArtworkType.queue => _QueueArtwork(scale: scale),
      OnboardingArtworkType.time => _TimeArtwork(scale: scale),
    };
  }
}

class _TicketArtwork extends StatelessWidget {
  const _TicketArtwork({required this.scale});

  static const size = 374.0;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      OnboardingAssets.ticketBarber,
      width: size * scale,
      height: size * scale,
      fit: BoxFit.cover,
    );
  }
}

class _QueueArtwork extends StatelessWidget {
  const _QueueArtwork({required this.scale});

  static const width = 342.0;
  static const height = 442.0;
  static const imageLeftRatio = -0.3893;
  static const imageWidthRatio = 1.7751;
  static const imageHeightRatio = 0.9648;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: width * scale,
        height: height * scale,
        child: Stack(
          children: [
            Positioned(
              left: width * imageLeftRatio * scale,
              top: 0,
              child: Image.asset(
                OnboardingAssets.queuePhone,
                width: width * imageWidthRatio * scale,
                height: height * imageHeightRatio * scale,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeArtwork extends StatelessWidget {
  const _TimeArtwork({required this.scale});

  static const size = 401.0;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: size * scale,
        height: size * scale,
        child: Stack(
          children: [
            _FractionalSvg(
              asset: OnboardingAssets.timeBackground,
              left: 0,
              top: 0.11,
              width: 1,
              height: 0.6929,
              scale: scale,
            ),
            _FractionalSvg(
              asset: OnboardingAssets.timeShadow,
              left: 0.1122,
              top: 0.8098,
              width: 0.7756,
              height: 0.0453,
              scale: scale,
            ),
            _FractionalSvg(
              asset: OnboardingAssets.timeHourglass,
              left: 0.4557,
              top: 0.4058,
              width: 0.2767,
              height: 0.4215,
              scale: scale,
            ),
            _FractionalSvg(
              asset: OnboardingAssets.timeCharacter,
              left: 0.329,
              top: 0.2159,
              width: 0.2281,
              height: 0.6171,
              scale: scale,
            ),
            _FractionalSvg(
              asset: OnboardingAssets.timeClock,
              left: 0.2749,
              top: 0.1864,
              width: 0.1271,
              height: 0.1259,
              scale: scale,
            ),
          ],
        ),
      ),
    );
  }
}

class _FractionalSvg extends StatelessWidget {
  const _FractionalSvg({
    required this.asset,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.scale,
  });

  final String asset;
  final double left;
  final double top;
  final double width;
  final double height;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _TimeArtwork.size * left * scale,
      top: _TimeArtwork.size * top * scale,
      child: SvgPicture.asset(
        asset,
        width: _TimeArtwork.size * width * scale,
        height: _TimeArtwork.size * height * scale,
        fit: BoxFit.fill,
      ),
    );
  }
}

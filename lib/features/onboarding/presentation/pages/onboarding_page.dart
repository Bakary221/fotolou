import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/figma_frame.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_artwork.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_bottom_action.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_page_dots.dart';
import 'package:go_router/go_router.dart';

abstract final class OnboardingScreenTokens {
  static const titleTop = 148.0;
  static const bodyTop = 226.0;
  static const ticketTitleLeft = 81.0;
  static const queueTitleLeft = 21.0;
  static const timeTitleLeft = 84.0;
  static const bodyWidth = FigmaFrameTokens.width;
  static const ticketArtworkLeft = 33.0;
  static const ticketArtworkTop = 336.0;
  static const queueArtworkLeft = 49.0;
  static const queueArtworkTop = 334.0;
  static const timeArtworkLeft = 19.0;
  static const timeArtworkTop = 359.0;
  static const bottomPanelTop = 767.0;
  static const bottomPanelHeight = 189.0;
  static const nextButtonTop = 23.0;
  static const startButtonTop = 25.0;
  static const nextDotsTop = 123.0;
  static const startDotsTop = 128.0;
  static const transitionDuration = Duration(milliseconds: 280);
}

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();

  static const _slides = [
    _OnboardingSlideData(
      title: 'Prends ton ticket',
      body: 'Choisi ton salon et\nprend ton ticket en 1 clic.',
      titleLeft: OnboardingScreenTokens.ticketTitleLeft,
      artworkLeft: OnboardingScreenTokens.ticketArtworkLeft,
      artworkTop: OnboardingScreenTokens.ticketArtworkTop,
      artworkType: OnboardingArtworkType.ticket,
    ),
    _OnboardingSlideData(
      title: 'Suis ta file en temps reel',
      body:
          'Vois ta position et recois\nune notification quand ton\ntour approche',
      titleLeft: OnboardingScreenTokens.queueTitleLeft,
      artworkLeft: OnboardingScreenTokens.queueArtworkLeft,
      artworkTop: OnboardingScreenTokens.queueArtworkTop,
      artworkType: OnboardingArtworkType.queue,
    ),
    _OnboardingSlideData(
      title: 'Gagne du temps',
      body: 'Attends ou tu veux, on\nt’informe quand c’est\npresque ton tour',
      titleLeft: OnboardingScreenTokens.timeTitleLeft,
      artworkLeft: OnboardingScreenTokens.timeArtworkLeft,
      artworkTop: OnboardingScreenTokens.timeArtworkTop,
      artworkType: OnboardingArtworkType.time,
      actionLabel: 'Commencer',
      isFinalSlide: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: PageView.builder(
          controller: _pageController,
          itemCount: _slides.length,
          onPageChanged: (index) {
            ref.read(onboardingControllerProvider.notifier).setPage(index);
          },
          itemBuilder: (context, index) {
            return _OnboardingSlide(
              data: _slides[index],
              currentIndex: index,
              count: _slides.length,
              onActionPressed: () => _handleAction(index),
            );
          },
        ),
      ),
    );
  }

  void _handleAction(int index) {
    if (index == _slides.length - 1) {
      context.goNamed(AppRoute.phoneLogin.name);
      return;
    }

    _pageController.nextPage(
      duration: OnboardingScreenTokens.transitionDuration,
      curve: Curves.easeOut,
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.data,
    required this.currentIndex,
    required this.count,
    required this.onActionPressed,
  });

  final _OnboardingSlideData data;
  final int currentIndex;
  final int count;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return FigmaFrame(
      backgroundColor: AppColors.white,
      builder: (context, metrics) {
        return Stack(
          children: [
            Positioned(
              left: metrics.x(data.titleLeft),
              top: metrics.y(OnboardingScreenTokens.titleTop),
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: brandTextTheme.onboardingTitle.copyWith(
                  color: AppColors.ink,
                  fontSize:
                      brandTextTheme.onboardingTitle.fontSize! * metrics.scale,
                ),
              ),
            ),
            Positioned(
              left: metrics.x(0),
              top: metrics.y(OnboardingScreenTokens.bodyTop),
              width: metrics.s(OnboardingScreenTokens.bodyWidth),
              child: Text(
                data.body,
                textAlign: TextAlign.center,
                style: brandTextTheme.onboardingBody.copyWith(
                  color: AppColors.mutedInk,
                  fontSize:
                      brandTextTheme.onboardingBody.fontSize! * metrics.scale,
                ),
              ),
            ),
            Positioned(
              left: metrics.x(data.artworkLeft),
              top: metrics.y(data.artworkTop),
              child: OnboardingArtwork(
                type: data.artworkType,
                scale: metrics.scale,
              ),
            ),
            Positioned(
              left: metrics.x(0),
              top: metrics.y(OnboardingScreenTokens.bottomPanelTop),
              width: metrics.s(FigmaFrameTokens.width),
              height: metrics.s(OnboardingScreenTokens.bottomPanelHeight),
              child: _BottomPanel(
                data: data,
                currentIndex: currentIndex,
                count: count,
                metrics: metrics,
                onActionPressed: onActionPressed,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.data,
    required this.currentIndex,
    required this.count,
    required this.metrics,
    required this.onActionPressed,
  });

  final _OnboardingSlideData data;
  final int currentIndex;
  final int count;
  final FigmaFrameMetrics metrics;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final buttonTop = data.isFinalSlide
        ? OnboardingScreenTokens.startButtonTop
        : OnboardingScreenTokens.nextButtonTop;
    final dotsTop = data.isFinalSlide
        ? OnboardingScreenTokens.startDotsTop
        : OnboardingScreenTokens.nextDotsTop;

    return ColoredBox(
      color: AppColors.white,
      child: Stack(
        children: [
          Positioned(
            left: OnboardingBottomActionTokens.left * metrics.scale,
            top: buttonTop * metrics.scale,
            child: OnboardingBottomAction(
              label: data.actionLabel,
              isPrimary: data.isFinalSlide,
              scale: metrics.scale,
              onPressed: onActionPressed,
            ),
          ),
          Positioned(
            top: dotsTop * metrics.scale,
            left: 0,
            right: 0,
            child: Center(
              child: OnboardingPageDots(
                currentIndex: currentIndex,
                count: count,
                scale: metrics.scale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.title,
    required this.body,
    required this.titleLeft,
    required this.artworkLeft,
    required this.artworkTop,
    required this.artworkType,
    this.actionLabel = 'Suivant',
    this.isFinalSlide = false,
  });

  final String title;
  final String body;
  final double titleLeft;
  final double artworkLeft;
  final double artworkTop;
  final OnboardingArtworkType artworkType;
  final String actionLabel;
  final bool isFinalSlide;
}

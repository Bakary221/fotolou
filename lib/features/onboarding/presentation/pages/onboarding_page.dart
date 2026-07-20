import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_brand_text_theme.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/app/theme/app_system_ui.dart';
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
  static const skipTop = 58.0;
  static const skipRight = AppSpacing.pageHorizontal;
  static const skipWidth = 92.0;
  static const skipHeight = 42.0;
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
      body: 'Choisis ton salon et\nprends ton ticket en 1 clic.',
      titleLeft: OnboardingScreenTokens.ticketTitleLeft,
      artworkLeft: OnboardingScreenTokens.ticketArtworkLeft,
      artworkTop: OnboardingScreenTokens.ticketArtworkTop,
      artworkType: OnboardingArtworkType.ticket,
    ),
    _OnboardingSlideData(
      title: 'Suis ta file en temps réel',
      body:
          'Vois ta position et reçois\nune notification quand ton\ntour approche',
      titleLeft: OnboardingScreenTokens.queueTitleLeft,
      artworkLeft: OnboardingScreenTokens.queueArtworkLeft,
      artworkTop: OnboardingScreenTokens.queueArtworkTop,
      artworkType: OnboardingArtworkType.queue,
    ),
    _OnboardingSlideData(
      title: 'Gagne du temps',
      body: 'Attends où tu veux, on\nt’informe quand c’est\npresque ton tour',
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
    final currentIndex = ref.watch(onboardingControllerProvider).currentIndex;
    final currentSlide = _slides[currentIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: FigmaFrame(
          backgroundColor: AppColors.white,
          builder: (context, metrics) {
            return Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .setPage(index);
                    },
                    itemBuilder: (context, index) {
                      return _OnboardingSlideContent(
                        data: _slides[index],
                        metrics: metrics,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: metrics.y(OnboardingScreenTokens.skipTop),
                  right: metrics.s(OnboardingScreenTokens.skipRight),
                  child: _SkipButton(
                    scale: metrics.scale,
                    onPressed: _goToPhoneLogin,
                  ),
                ),
                Positioned(
                  left: metrics.x(0),
                  top: metrics.y(OnboardingScreenTokens.bottomPanelTop),
                  width: metrics.s(FigmaFrameTokens.width),
                  height: metrics.s(OnboardingScreenTokens.bottomPanelHeight),
                  child: _BottomPanel(
                    data: currentSlide,
                    currentIndex: currentIndex,
                    count: _slides.length,
                    metrics: metrics,
                    onActionPressed: () => _handleAction(currentIndex),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleAction(int index) {
    if (index == _slides.length - 1) {
      _goToPhoneLogin();
      return;
    }

    _pageController.nextPage(
      duration: OnboardingScreenTokens.transitionDuration,
      curve: Curves.easeOut,
    );
  }

  void _goToPhoneLogin() {
    context.goNamed(AppRoute.phoneLogin.name);
  }
}

class _OnboardingSlideContent extends StatelessWidget {
  const _OnboardingSlideContent({required this.data, required this.metrics});

  final _OnboardingSlideData data;
  final FigmaFrameMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final brandTextTheme = context.brandTextTheme;

    return SizedBox.expand(
      child: Stack(
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
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.scale, required this.onPressed});

  final double scale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: OnboardingScreenTokens.skipWidth * scale,
      height: OnboardingScreenTokens.skipHeight * scale,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mutedInk,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21 * scale),
          ),
          textStyle: TextStyle(
            fontFamily: AppFonts.inter,
            fontSize: 15 * scale,
            fontWeight: FontWeight.w600,
            height: 20 / 15,
          ),
        ),
        child: const Text('Passer'),
      ),
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
              isPrimary: true,
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

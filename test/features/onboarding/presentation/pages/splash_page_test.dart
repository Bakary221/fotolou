import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_theme.dart';
import 'package:fotolou/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fotolou/features/onboarding/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('renders the Fotolou splash screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SplashPage()),
    );

    expect(find.text('Fotolou'), findsOneWidget);
    expect(find.text('Moins d’attente. Plus de temps.'), findsOneWidget);
    expect(find.text('version 1.0.0'), findsOneWidget);
  });

  testWidgets('renders on compact and tablet viewports without overflow', (
    tester,
  ) async {
    final binding = tester.view;
    addTearDown(() {
      binding.resetPhysicalSize();
      binding.resetDevicePixelRatio();
    });

    for (final size in <Size>[const Size(320, 568), const Size(768, 1024)]) {
      binding.physicalSize = size;
      binding.devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const SplashPage()),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Fotolou'), findsOneWidget);
    }
  });

  testWidgets('navigates from splash to onboarding after the splash delay', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoute.splash.path,
      routes: [
        GoRoute(
          path: AppRoute.splash.path,
          name: AppRoute.splash.name,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRoute.onboarding.path,
          name: AppRoute.onboarding.name,
          builder: (context, state) => const OnboardingPage(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );

    expect(find.text('version 1.0.0'), findsOneWidget);

    await tester.pump(SplashDesignTokens.navigationDelay);
    await tester.pump();

    expect(find.text('Prends ton ticket'), findsOneWidget);
  });
}

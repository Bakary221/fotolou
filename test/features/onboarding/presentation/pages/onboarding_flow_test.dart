import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_theme.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/core/storage/local_storage.dart';
import 'package:fotolou/features/barber/presentation/pages/barber_dashboard_page.dart';
import 'package:fotolou/features/barber/presentation/pages/barber_profile_page.dart';
import 'package:fotolou/features/barber/presentation/pages/barber_tickets_page.dart';
import 'package:fotolou/features/client/presentation/pages/client_home_page.dart';
import 'package:fotolou/features/client/presentation/pages/client_profile_page.dart';
import 'package:fotolou/features/client/presentation/pages/client_salon_detail_page.dart';
import 'package:fotolou/features/client/presentation/pages/client_tickets_page.dart';
import 'package:fotolou/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fotolou/features/onboarding/presentation/pages/otp_verification_page.dart';
import 'package:fotolou/features/onboarding/presentation/pages/phone_login_page.dart';
import 'package:fotolou/features/onboarding/presentation/widgets/onboarding_assets.dart';
import 'package:fotolou/shared/widgets/app_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('renders the three onboarding slides', (tester) async {
    await _pumpOnboarding(tester, const Size(440, 956));

    expect(find.text('Prends ton ticket'), findsOneWidget);
    expect(
      find.text('Choisi ton salon et\nprend ton ticket en 1 clic.'),
      findsOneWidget,
    );

    await tester.drag(find.byType(PageView), const Offset(-440, 0));
    await tester.pumpAndSettle();

    expect(find.text('Suis ta file en temps reel'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-440, 0));
    await tester.pumpAndSettle();

    expect(find.text('Gagne du temps'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(find.byType(SvgPicture), findsAtLeastNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('time artwork svgs use Flutter-compatible static colors', (
    tester,
  ) async {
    const svgAssets = [
      OnboardingAssets.timeBackground,
      OnboardingAssets.timeShadow,
      OnboardingAssets.timeHourglass,
      OnboardingAssets.timeCharacter,
      OnboardingAssets.timeClock,
    ];

    for (final asset in svgAssets) {
      final svg = await rootBundle.loadString(asset);
      expect(svg, isNot(contains('var(')), reason: asset);
    }
  });

  testWidgets('action arrow svgs point forward', (tester) async {
    const arrowAssets = [
      OnboardingAssets.arrowNext,
      OnboardingAssets.verifyArrow,
    ];

    for (final asset in arrowAssets) {
      final svg = await rootBundle.loadString(asset);
      expect(svg, contains('L16.2462 8.43807'), reason: asset);
    }
  });

  testWidgets(
    'onboarding renders without overflow on compact and tablet sizes',
    (tester) async {
      for (final size in _responsiveSizes) {
        await _pumpOnboarding(tester, size);
        expect(tester.takeException(), isNull);
        expect(find.text('Prends ton ticket'), findsOneWidget);
      }
    },
  );

  testWidgets('phone and otp screens render without overflow', (tester) async {
    for (final size in _responsiveSizes) {
      await _pumpPage(tester, const PhoneLoginPage(), size);
      expect(tester.takeException(), isNull);
      expect(find.text('Bienvenue 👋'), findsOneWidget);
      expect(find.text('Continuer'), findsOneWidget);

      await _pumpPage(tester, const OtpVerificationPage(), size);
      expect(tester.takeException(), isNull);
      expect(find.text('Entrez le code'), findsOneWidget);
      expect(find.text('verifier'), findsOneWidget);
    }
  });

  testWidgets('phone country selector chevron keeps Figma size', (
    tester,
  ) async {
    await _pumpPage(tester, const PhoneLoginPage(), const Size(440, 956));

    final chevronSize = tester.getSize(find.byType(SvgPicture));

    expect(chevronSize.width, closeTo(10.6667, 0.001));
    expect(chevronSize.height, closeTo(6, 0.001));
  });

  testWidgets('phone form field and country selector have borders', (
    tester,
  ) async {
    await _pumpPage(tester, const PhoneLoginPage(), const Size(440, 956));

    final frame = tester.widget<SizedBox>(
      find.byKey(PhoneLoginTokens.inputFrameKey),
    );
    final frameDecoration =
        (frame.child! as DecoratedBox).decoration as BoxDecoration;
    final countrySelector = tester.widget<DecoratedBox>(
      find.byKey(PhoneLoginTokens.countrySelectorFrameKey),
    );
    final countryDecoration = countrySelector.decoration as BoxDecoration;
    final textField = tester.widget<TextField>(find.byType(TextField));
    final decoration = textField.decoration!;

    expect(frame.child, isA<DecoratedBox>());
    expect(frameDecoration.color, AppColors.white);
    expect(frameDecoration.border, Border.all(color: AppColors.gray200));
    expect(
      frameDecoration.borderRadius,
      BorderRadius.circular(PhoneLoginTokens.inputRadius),
    );
    expect(countryDecoration.color, AppColors.white);
    expect(countryDecoration.border, Border.all(color: AppColors.gray200));
    expect(decoration.border, InputBorder.none);
    expect(decoration.enabledBorder, InputBorder.none);
    expect(decoration.focusedBorder, InputBorder.none);
    expect(decoration.filled, isFalse);
  });

  testWidgets('otp input boxes match inactive and active Figma states', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      const OtpVerificationPage(phone: '+221701234567'),
      const Size(440, 956),
    );

    final firstBox = find.byKey(OtpTokens.otpBoxKey(0));
    final firstDecoration =
        tester.widget<DecoratedBox>(firstBox).decoration as BoxDecoration;

    expect(tester.getSize(firstBox), const Size(48, 56));
    expect(firstDecoration.color, AppColors.gray50);
    expect(firstDecoration.border, Border.all(color: AppColors.gray100));
    expect(
      firstDecoration.borderRadius,
      BorderRadius.circular(OtpTokens.otpBoxRadius),
    );

    await tester.tap(find.byType(TextField).first);
    await tester.pump();

    final activeDecoration =
        tester.widget<DecoratedBox>(firstBox).decoration as BoxDecoration;
    final activeTextField = tester.widget<TextField>(
      find.byType(TextField).first,
    );

    expect(activeDecoration.color, AppColors.white);
    expect(
      activeDecoration.border,
      Border.all(color: AppColors.focusBlue, width: 2),
    );
    expect(activeTextField.decoration?.border, InputBorder.none);
    expect(activeTextField.decoration?.enabledBorder, InputBorder.none);
    expect(activeTextField.decoration?.focusedBorder, InputBorder.none);
    expect(activeTextField.decoration?.filled, isFalse);
    expect(activeTextField.style?.color, AppColors.focusBlue);
  });

  testWidgets('client home keeps search area fixed while salon list scrolls', (
    tester,
  ) async {
    await _pumpPage(tester, const ClientHomePage(), const Size(440, 568));

    final searchField = find.byKey(ClientHomeTokens.searchFieldKey);
    final sectionHeader = find.byKey(ClientHomeTokens.sectionHeaderKey);
    final initialTop = tester.getTopLeft(searchField).dy;
    final initialSectionTop = tester.getTopLeft(sectionHeader).dy;

    expect(find.text('Dakar, Sénégal'), findsOneWidget);
    expect(find.text('Salons proches'), findsOneWidget);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -220),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(searchField).dy, initialTop);
    expect(tester.getTopLeft(sectionHeader).dy, initialSectionTop);
    expect(find.text('Rechercher un salon'), findsOneWidget);
    expect(find.text('Voir tout'), findsOneWidget);
  });

  testWidgets('tapping a salon opens the client salon detail page', (
    tester,
  ) async {
    final router = _clientRouter();
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));
    await tester.tap(find.byKey(ClientHomeTokens.salonItemKey(0)));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientSalonDetailTokens.heroKey), findsOneWidget);
    expect(find.byKey(AppTopHeaderTokens.headerKey), findsOneWidget);
    expect(find.text('Dakar, Sénégal'), findsNothing);
    expect(find.byKey(ClientSalonDetailTokens.backButtonKey), findsOneWidget);
    final heroTop = tester
        .getTopLeft(find.byKey(ClientSalonDetailTokens.heroKey))
        .dy;
    final heroBottom = tester
        .getBottomRight(find.byKey(ClientSalonDetailTokens.heroKey))
        .dy;
    final headerTop = tester
        .getTopLeft(find.byKey(AppTopHeaderTokens.headerKey))
        .dy;
    final backCenterY = tester
        .getCenter(find.byKey(ClientSalonDetailTokens.backButtonKey))
        .dy;
    final notificationCenterY = tester
        .getCenter(find.byKey(AppTopHeaderTokens.notificationButtonKey))
        .dy;

    expect(headerTop, greaterThanOrEqualTo(heroTop));
    expect(headerTop, lessThan(heroBottom));
    expect(notificationCenterY, closeTo(backCenterY, 2));
    expect(find.text('King Barber'), findsOneWidget);
    expect(find.text('Prendre mon ticket'), findsOneWidget);
    expect(find.text('Mes tickets'), findsNothing);

    await tester.tap(find.byKey(ClientSalonDetailTokens.backButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Salons proches'), findsOneWidget);
  });

  testWidgets('client tickets page opens from nav item and detail button', (
    tester,
  ) async {
    final router = _clientRouter();
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));
    await tester.tap(find.text('Mes tickets'));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientTicketsTokens.pageKey), findsOneWidget);
    expect(find.byKey(AppTopHeaderTokens.headerKey), findsOneWidget);
    expect(find.text('Dakar, Sénégal'), findsNothing);
    expect(find.text('M O N  T O U R'), findsOneWidget);
    expect(find.text('Tu es le numéro'), findsOneWidget);
    expect(find.text('Quitter la file'), findsOneWidget);

    await tester.tap(find.text('Historiques'));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientTicketsTokens.historyListKey), findsOneWidget);
    expect(find.text('Passages recents'), findsOneWidget);
    expect(find.text('Filtrer'), findsOneWidget);
    expect(find.text('KingBarber'), findsOneWidget);
    expect(find.text('Cheikh Fall'), findsOneWidget);
    expect(find.text('ANNULÉ'), findsOneWidget);
    expect(find.text('SERVI'), findsWidgets);

    await tester.tap(find.text('Actuel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Accueil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ClientHomeTokens.salonItemKey(0)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prendre mon ticket'));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientTicketsTokens.pageKey), findsOneWidget);
    expect(find.byKey(ClientTicketsTokens.progressKey), findsOneWidget);

    await tester.tap(find.text('Accueil'));
    await tester.pumpAndSettle();

    expect(find.text('Salons proches'), findsOneWidget);
  });

  testWidgets('client profile page opens from bottom navigation', (
    tester,
  ) async {
    final router = _clientRouter();
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientProfileTokens.pageKey), findsOneWidget);
    expect(find.byKey(AppTopHeaderTokens.headerKey), findsOneWidget);
    expect(find.text('Dakar, Sénégal'), findsNothing);
    expect(find.byKey(ClientProfileTokens.avatarKey), findsOneWidget);
    expect(find.text('BAKARY'), findsOneWidget);
    expect(find.text('+221 77 862 70 52'), findsOneWidget);
    expect(find.text('TICKETS'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('SERVIE'), findsOneWidget);
    expect(find.text('38'), findsOneWidget);
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Aide & Support'), findsOneWidget);
    expect(find.text('Déconnexion'), findsOneWidget);

    await tester.tap(find.text('Accueil'));
    await tester.pumpAndSettle();

    expect(find.text('Salons proches'), findsOneWidget);
  });

  testWidgets('client bottom menu switches between every client section', (
    tester,
  ) async {
    final router = _clientRouter(initialLocation: AppRoute.clientTickets.path);
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));

    expect(find.byKey(AppBottomNavTokens.navKey), findsOneWidget);
    expect(find.byKey(ClientTicketsTokens.pageKey), findsOneWidget);
    expect(find.text('M O N  T O U R'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientProfileTokens.pageKey), findsOneWidget);
    expect(find.text('BAKARY'), findsOneWidget);
    expect(find.text('M O N  T O U R'), findsNothing);

    await tester.tap(find.text('Mes tickets'));
    await tester.pumpAndSettle();

    expect(find.byKey(ClientTicketsTokens.pageKey), findsOneWidget);
    expect(find.text('M O N  T O U R'), findsOneWidget);
    expect(find.text('BAKARY'), findsNothing);

    await tester.tap(find.text('Accueil'));
    await tester.pumpAndSettle();

    expect(find.text('Salons proches'), findsOneWidget);
    expect(find.text('Dakar, Sénégal'), findsOneWidget);
  });

  testWidgets('visible actions move through onboarding, phone, and otp pages', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoute.onboarding.path,
      routes: [
        GoRoute(
          path: AppRoute.onboarding.path,
          name: AppRoute.onboarding.name,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRoute.phoneLogin.path,
          name: AppRoute.phoneLogin.name,
          builder: (context, state) => const PhoneLoginPage(),
        ),
        GoRoute(
          path: AppRoute.otp.path,
          name: AppRoute.otp.name,
          builder: (context, state) =>
              OtpVerificationPage(phone: state.uri.queryParameters['phone']),
        ),
        GoRoute(
          path: AppRoute.clientHome.path,
          name: AppRoute.clientHome.name,
          builder: (context, state) => const ClientHomePage(),
        ),
        GoRoute(
          path: AppRoute.barberHome.path,
          name: AppRoute.barberHome.name,
          builder: (context, state) => const BarberDashboardPage(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));

    expect(find.text('Prends ton ticket'), findsOneWidget);

    await _tapVisibleText(tester, 'Suivant');
    expect(find.text('Suis ta file en temps reel'), findsOneWidget);

    await _tapVisibleText(tester, 'Suivant');
    expect(find.text('Gagne du temps'), findsOneWidget);

    await _tapVisibleText(tester, 'Commencer');
    expect(find.text('Bienvenue 👋'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '70 123 45 67');
    await _tapVisibleText(tester, 'Continuer');
    expect(find.text('Entrez le code'), findsOneWidget);
  });

  testWidgets('client mock phone and otp redirect to client home', (
    tester,
  ) async {
    final router = _phoneAuthRouter();
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));
    await tester.enterText(find.byType(TextField), '70 123 45 67');
    await _tapVisibleText(tester, 'Continuer');

    expect(find.text('Entrez le code'), findsOneWidget);

    await _enterOtp(tester, '123456');
    await _tapVisibleText(tester, 'verifier');

    expect(find.text('Salons proches'), findsOneWidget);
    expect(find.text('Bonjour , Diassy👋'), findsOneWidget);
  });

  testWidgets('barber mock phone and otp redirect to barber dashboard', (
    tester,
  ) async {
    final router = _phoneAuthRouter();
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));
    await tester.enterText(find.byType(TextField), '77 111 22 33');
    await _tapVisibleText(tester, 'Continuer');

    expect(find.text('Entrez le code'), findsOneWidget);

    await _enterOtp(tester, '654321');
    await _tapVisibleText(tester, 'verifier');

    expect(find.text('CLIENTS EN ATTENTE'), findsOneWidget);
    expect(find.text('Ouvert'), findsOneWidget);
    expect(find.byKey(AppTopHeaderTokens.headerKey), findsOneWidget);
    expect(find.text('Dakar, Sénégal'), findsNothing);
    expect(find.text('SERVIS'), findsOneWidget);
  });

  testWidgets('barber menu opens tickets tabs and profile workflow', (
    tester,
  ) async {
    final router = _barberRouter();
    addTearDown(router.dispose);

    await _pumpRouter(tester, router, const Size(440, 956));

    expect(find.text('CLIENTS EN ATTENTE'), findsOneWidget);
    expect(find.text('SERVIS'), findsOneWidget);
    expect(find.text('Ouvert'), findsOneWidget);
    final openToggle = tester.widget<AnimatedContainer>(
      find.byKey(BarberDashboardTokens.statusToggleKey),
    );
    final openDecoration = openToggle.decoration! as BoxDecoration;
    expect(openDecoration.color, const Color(0xFF22C55E));

    await tester.tap(find.byKey(BarberDashboardTokens.statusToggleKey));
    await tester.pumpAndSettle();

    expect(find.text('Fermé'), findsOneWidget);
    expect(find.text('Ouvert'), findsNothing);
    final closedToggle = tester.widget<AnimatedContainer>(
      find.byKey(BarberDashboardTokens.statusToggleKey),
    );
    final closedDecoration = closedToggle.decoration! as BoxDecoration;
    expect(closedDecoration.color, AppColors.danger);

    await tester.tap(find.text('Mes tickets'));
    await tester.pumpAndSettle();

    expect(find.byKey(BarberTicketsTokens.pageKey), findsOneWidget);
    expect(find.text('File en direct'), findsOneWidget);
    expect(find.text('Amadou Koulibaly'), findsOneWidget);
    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('Sauter'), findsWidgets);
    expect(find.text('Servi'), findsWidgets);
    expect(find.byKey(BarberTicketsTokens.addClientButtonKey), findsOneWidget);

    await tester.tap(find.text('Historiques'));
    await tester.pumpAndSettle();

    expect(find.byKey(BarberTicketsTokens.historyListKey), findsOneWidget);
    expect(find.text('Passages recents'), findsOneWidget);
    expect(find.text('Awa Diop'), findsOneWidget);
    expect(find.text('Cheikh Fall'), findsOneWidget);
    expect(find.text('ANNULÉ'), findsOneWidget);
    expect(find.text('SERVI'), findsWidgets);
    expect(find.byKey(BarberTicketsTokens.addClientButtonKey), findsNothing);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byKey(BarberProfileTokens.pageKey), findsOneWidget);
    expect(find.byKey(BarberProfileTokens.avatarKey), findsOneWidget);
    expect(find.text('BAKARY'), findsOneWidget);
    expect(find.text('Abonnement'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Statistiques'), findsOneWidget);
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Aide & Support'), findsOneWidget);
    expect(find.text('Déconnexion'), findsOneWidget);

    await tester.tap(find.text('Accueil'));
    await tester.pumpAndSettle();

    expect(find.text('CLIENTS EN ATTENTE'), findsOneWidget);
  });
}

class MemoryLocalStorage implements LocalStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<String?> getString(String key) async {
    return _values[key];
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> saveString(String key, String value) async {
    _values[key] = value;
  }
}

const _responsiveSizes = [Size(320, 568), Size(768, 1024)];

Future<void> _pumpOnboarding(WidgetTester tester, Size size) {
  return _pumpPage(tester, const OnboardingPage(), size);
}

Future<void> _pumpPage(WidgetTester tester, Widget page, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [localStorageProvider.overrideWithValue(MemoryLocalStorage())],
      child: MaterialApp(theme: AppTheme.light, home: page),
    ),
  );
  await tester.pump();
}

Future<void> _pumpRouter(
  WidgetTester tester,
  GoRouter router,
  Size size,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [localStorageProvider.overrideWithValue(MemoryLocalStorage())],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pump();
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text).hitTestable().first);
  await tester.pumpAndSettle();
}

GoRouter _clientRouter({String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation ?? AppRoute.clientHome.path,
    routes: [
      GoRoute(
        path: AppRoute.clientHome.path,
        name: AppRoute.clientHome.name,
        builder: (context, state) => const ClientHomePage(),
      ),
      GoRoute(
        path: AppRoute.clientSalonDetail.path,
        name: AppRoute.clientSalonDetail.name,
        builder: (context, state) => const ClientSalonDetailPage(),
      ),
      GoRoute(
        path: AppRoute.clientTickets.path,
        name: AppRoute.clientTickets.name,
        builder: (context, state) => const ClientTicketsPage(),
      ),
      GoRoute(
        path: AppRoute.clientProfile.path,
        name: AppRoute.clientProfile.name,
        builder: (context, state) => const ClientProfilePage(),
      ),
    ],
  );
}

GoRouter _phoneAuthRouter() {
  return GoRouter(
    initialLocation: AppRoute.phoneLogin.path,
    routes: [
      GoRoute(
        path: AppRoute.phoneLogin.path,
        name: AppRoute.phoneLogin.name,
        builder: (context, state) => const PhoneLoginPage(),
      ),
      GoRoute(
        path: AppRoute.otp.path,
        name: AppRoute.otp.name,
        builder: (context, state) =>
            OtpVerificationPage(phone: state.uri.queryParameters['phone']),
      ),
      GoRoute(
        path: AppRoute.clientHome.path,
        name: AppRoute.clientHome.name,
        builder: (context, state) => const ClientHomePage(),
      ),
      GoRoute(
        path: AppRoute.barberHome.path,
        name: AppRoute.barberHome.name,
        builder: (context, state) => const BarberDashboardPage(),
      ),
    ],
  );
}

GoRouter _barberRouter() {
  return GoRouter(
    initialLocation: AppRoute.barberHome.path,
    routes: [
      GoRoute(
        path: AppRoute.barberHome.path,
        name: AppRoute.barberHome.name,
        builder: (context, state) => const BarberDashboardPage(),
      ),
      GoRoute(
        path: AppRoute.barberTickets.path,
        name: AppRoute.barberTickets.name,
        builder: (context, state) => const BarberTicketsPage(),
      ),
      GoRoute(
        path: AppRoute.barberProfile.path,
        name: AppRoute.barberProfile.name,
        builder: (context, state) => const BarberProfilePage(),
      ),
    ],
  );
}

Future<void> _enterOtp(WidgetTester tester, String otp) async {
  final fields = find.byType(TextField);
  for (var index = 0; index < otp.length; index++) {
    await tester.enterText(fields.at(index), otp[index]);
  }
}

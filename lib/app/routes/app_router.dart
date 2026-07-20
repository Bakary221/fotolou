import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/routes/pages/home_page.dart';
import 'package:fotolou/app/routes/pages/not_found_page.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';
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
import 'package:fotolou/features/onboarding/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref
    ..listen<AuthState>(authControllerProvider, (previous, next) {
      refreshNotifier.refresh();
    })
    ..onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoute.splash.path,
    refreshListenable: refreshNotifier,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => navigationShell,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.clientHome.path,
                name: AppRoute.clientHome.name,
                builder: (context, state) => const ClientHomePage(),
                routes: [
                  GoRoute(
                    path: 'salon',
                    name: AppRoute.clientSalonDetail.name,
                    builder: (context, state) => ClientSalonDetailPage(
                      salonId: state.uri.queryParameters['salonId'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.clientTickets.path,
                name: AppRoute.clientTickets.name,
                builder: (context, state) => const ClientTicketsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.clientProfile.path,
                name: AppRoute.clientProfile.name,
                builder: (context, state) => const ClientProfilePage(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => navigationShell,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.barberHome.path,
                name: AppRoute.barberHome.name,
                builder: (context, state) => const BarberDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.barberTickets.path,
                name: AppRoute.barberTickets.name,
                builder: (context, state) => const BarberTicketsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.barberProfile.path,
                name: AppRoute.barberProfile.name,
                builder: (context, state) => const BarberProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        redirect: (context, state) => AppRoute.phoneLogin.path,
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final onboardingPaths = {
        AppRoute.splash.path,
        AppRoute.onboarding.path,
        AppRoute.phoneLogin.path,
        AppRoute.otp.path,
      };
      final isOnboardingRoute = onboardingPaths.contains(state.matchedLocation);
      final isEntryRoute = isOnboardingRoute;
      final isAuthenticated = authState.isAuthenticated;
      final isResolvingSession =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;

      if (isResolvingSession) {
        return isEntryRoute ? null : AppRoute.phoneLogin.path;
      }

      final user = authState.user;
      if (isAuthenticated && user != null && isEntryRoute) {
        return _roleHomePath(user.role);
      }

      if (isOnboardingRoute) {
        return null;
      }

      if (!isAuthenticated && !isOnboardingRoute) {
        return AppRoute.phoneLogin.path;
      }

      if (isAuthenticated && user != null) {
        final roleHomePath = _roleHomePath(user.role);
        final isAtRoot = state.matchedLocation == AppRoute.home.path;
        final isWrongClientArea =
            state.matchedLocation.startsWith(AppRoute.clientHome.path) &&
            user.role != UserRole.client;
        final isWrongBarberArea =
            state.matchedLocation.startsWith(AppRoute.barberHome.path) &&
            user.role != UserRole.barber;

        if (isAtRoot || isWrongClientArea || isWrongBarberArea) {
          return roleHomePath;
        }
      }

      return null;
    },
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});

String _roleHomePath(UserRole role) {
  return switch (role) {
    UserRole.client => AppRoute.clientHome.path,
    UserRole.barber => AppRoute.barberHome.path,
  };
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

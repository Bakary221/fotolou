import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/routes/pages/home_page.dart';
import 'package:fotolou/app/routes/pages/not_found_page.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';
import 'package:fotolou/features/authentication/presentation/pages/login_page.dart';
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
  return GoRouter(
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
        path: AppRoute.clientTickets.path,
        name: AppRoute.clientTickets.name,
        builder: (context, state) => const ClientTicketsPage(),
      ),
      GoRoute(
        path: AppRoute.clientProfile.path,
        name: AppRoute.clientProfile.name,
        builder: (context, state) => const ClientProfilePage(),
      ),
      GoRoute(
        path: AppRoute.clientSalonDetail.path,
        name: AppRoute.clientSalonDetail.name,
        builder: (context, state) => const ClientSalonDetailPage(),
      ),
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
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final publicPaths = {
        AppRoute.splash.path,
        AppRoute.onboarding.path,
        AppRoute.phoneLogin.path,
        AppRoute.otp.path,
      };
      final isPublicRoute = publicPaths.contains(state.matchedLocation);
      if (isPublicRoute) {
        return null;
      }

      final isLoggingIn = state.matchedLocation == AppRoute.login.path;
      final isAuthenticated = authState.isAuthenticated;
      final isResolvingSession =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;

      if (isResolvingSession) {
        return isLoggingIn ? null : AppRoute.login.path;
      }

      if (!isAuthenticated && !isLoggingIn) {
        return AppRoute.login.path;
      }

      final user = authState.user;
      if (isAuthenticated && user != null) {
        final roleHomePath = _roleHomePath(user.role);
        final isAtRoot = state.matchedLocation == AppRoute.home.path;
        final isWrongClientArea =
            state.matchedLocation.startsWith(AppRoute.clientHome.path) &&
            user.role != UserRole.client;
        final isWrongBarberArea =
            state.matchedLocation.startsWith(AppRoute.barberHome.path) &&
            user.role != UserRole.barber;

        if (isLoggingIn || isAtRoot || isWrongClientArea || isWrongBarberArea) {
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

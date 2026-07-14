import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/features/barber/presentation/widgets/barber_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:go_router/go_router.dart';

abstract final class BarberProfileTokens {
  static const pageKey = Key('barber_profile_page');
  static const avatarKey = Key('barber_profile_avatar');
  static const subscriptionCardKey = Key('barber_profile_subscription_card');
  static const statsLinkKey = Key('barber_profile_stats_link');
  static const settingsGroupKey = Key('barber_profile_settings_group');
  static const logoutButtonKey = Key('barber_profile_logout_button');
}

class BarberProfilePage extends ConsumerWidget {
  const BarberProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: BarberProfileTokens.pageKey,
        backgroundColor: AppColors.white,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: AppTopHeader(showLocation: false),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 42),
                      child: Column(
                        children: [
                          const _ProfileHeader(),
                          const SizedBox(height: 18),
                          const _SubscriptionCard(),
                          const SizedBox(height: 32),
                          const _StatsLink(),
                          const SizedBox(height: 16),
                          const _SettingsGroup(),
                          const SizedBox(height: 62),
                          _LogoutButton(onPressed: () => _logout(context, ref)),
                        ],
                      ),
                    ),
                  ),
                  const BarberBottomNav(activeIndex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logout();
    if (context.mounted) {
      context.goNamed(AppRoute.phoneLogin.name);
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ProfileAvatar(),
        SizedBox(height: 24),
        Text(
          'BAKARY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 20 / 24,
          ),
        ),
        SizedBox(height: 16),
        Text(
          '+221 77 862 70 52',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF808080),
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w300,
            height: 20 / 20,
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: BarberProfileTokens.avatarKey,
      width: 98,
      height: 98,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: const Text(
        'B',
        style: TextStyle(
          color: AppColors.white,
          fontFamily: 'Inter',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 20 / 24,
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: BarberProfileTokens.subscriptionCardKey,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Abonnement',
                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 20 / 16,
                  ),
                ),
                Text(
                  'Premium',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.star_rounded, color: AppColors.accent, size: 22),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _StatsLink extends StatelessWidget {
  const _StatsLink();

  @override
  Widget build(BuildContext context) {
    return _ProfileLink(
      key: BarberProfileTokens.statsLinkKey,
      icon: Icons.bar_chart_rounded,
      label: 'Statistiques',
      standalone: true,
      onTap: () {},
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: BarberProfileTokens.settingsGroupKey,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileLink(
            icon: Icons.settings_outlined,
            label: 'Paramètres',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.gray50),
          _ProfileLink(
            icon: Icons.info_outline,
            label: 'Aide & Support',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({
    required this.icon,
    required this.label,
    required this.onTap,
    this.standalone = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: AppColors.slate800, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.slate300,
                size: 20,
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );

    if (!standalone) {
      return child;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: BarberProfileTokens.logoutButtonKey,
      width: 200,
      height: 48,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('Déconnexion'),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF0F2F7),
          foregroundColor: AppColors.slate500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 24 / 16,
          ),
        ),
      ),
    );
  }
}

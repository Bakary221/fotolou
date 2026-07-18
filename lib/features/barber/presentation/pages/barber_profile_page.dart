import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/barber/presentation/widgets/barber_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:fotolou/shared/widgets/profile_components.dart';
import 'package:fotolou/shared/widgets/role_page_scaffold.dart';
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
    return RolePageScaffold(
      key: BarberProfileTokens.pageKey,
      bottomNavigationBar: const BarberBottomNav(activeIndex: 2),
      body: Column(
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
                  const ProfileSettingsGroup(
                    key: BarberProfileTokens.settingsGroupKey,
                    items: [
                      ProfileSettingsItem(
                        icon: Icons.settings_outlined,
                        label: 'Paramètres',
                      ),
                      ProfileSettingsItem(
                        icon: Icons.info_outline,
                        label: 'Aide & Support',
                      ),
                    ],
                  ),
                  const SizedBox(height: 62),
                  ProfileLogoutButton(
                    key: BarberProfileTokens.logoutButtonKey,
                    onPressed: () => _logout(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        ProfileAvatar(key: BarberProfileTokens.avatarKey, initials: 'B'),
        SizedBox(height: 24),
        Text(
          'BAKARY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.black,
            fontFamily: AppFonts.inter,
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
            color: AppColors.textSoft,
            fontFamily: AppFonts.inter,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            height: 20 / 20,
          ),
        ),
      ],
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
            color: AppColors.shadowBlack03,
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
              color: AppColors.indigo50,
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
                    color: AppColors.textSlate,
                    fontFamily: AppFonts.inter,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 20 / 16,
                  ),
                ),
                Text(
                  'Premium',
                  style: TextStyle(
                    color: AppColors.slate400,
                    fontFamily: AppFonts.inter,
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
                    color: AppColors.textSlate,
                    fontFamily: AppFonts.inter,
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

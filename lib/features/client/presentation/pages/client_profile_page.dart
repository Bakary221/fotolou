import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/client/presentation/widgets/client_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:fotolou/shared/widgets/profile_components.dart';
import 'package:fotolou/shared/widgets/role_page_scaffold.dart';
import 'package:go_router/go_router.dart';

abstract final class ClientProfileTokens {
  static const pageKey = Key('client_profile_page');
  static const avatarKey = Key('client_profile_avatar');
  static const settingsGroupKey = Key('client_profile_settings_group');
  static const logoutButtonKey = Key('client_profile_logout_button');
}

class ClientProfilePage extends ConsumerWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RolePageScaffold(
      key: ClientProfileTokens.pageKey,
      bottomNavigationBar: const ClientBottomNav(activeIndex: 2),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.pageTop,
              AppSpacing.pageHorizontal,
              0,
            ),
            child: AppTopHeader(showLocation: false),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 620;
                final isVeryCompact = constraints.maxHeight < 500;
                final topPadding = isVeryCompact
                    ? 10.0
                    : isCompact
                    ? 16.0
                    : 34.0;
                final bottomPadding = isCompact ? 8.0 : 30.0;
                final avatarSize = isVeryCompact
                    ? 62.0
                    : isCompact
                    ? 76.0
                    : 98.0;
                final statsHeight = isVeryCompact
                    ? 64.0
                    : isCompact
                    ? 74.0
                    : 95.0;
                final settingsTileHeight = isCompact ? 50.0 : 58.0;
                final headerGap = isVeryCompact
                    ? 8.0
                    : isCompact
                    ? 12.0
                    : 31.0;
                final settingsGap = isVeryCompact
                    ? 8.0
                    : isCompact
                    ? 14.0
                    : 42.0;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    topPadding,
                    AppSpacing.pageHorizontal,
                    bottomPadding,
                  ),
                  child: Column(
                    children: [
                      _ProfileHeader(avatarSize: avatarSize),
                      SizedBox(height: headerGap),
                      _ProfileStats(cardHeight: statsHeight),
                      SizedBox(height: settingsGap),
                      ProfileSettingsGroup(
                        key: ClientProfileTokens.settingsGroupKey,
                        tileHeight: settingsTileHeight,
                        items: const [
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
                      const Spacer(),
                      ProfileLogoutButton(
                        key: ClientProfileTokens.logoutButtonKey,
                        height: isCompact ? 42 : 48,
                        onPressed: () => _logout(context, ref),
                      ),
                    ],
                  ),
                );
              },
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
  const _ProfileHeader({required this.avatarSize});

  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(
          key: ClientProfileTokens.avatarKey,
          initials: 'B',
          size: avatarSize,
        ),
        const SizedBox(height: 8),
        const Text(
          'BAKARY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSlate,
            fontFamily: AppFonts.inter,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 32 / 24,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
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

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.cardHeight});

  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(height: cardHeight, label: 'TICKETS', value: '45'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _StatCard(height: cardHeight, label: 'SERVIS', value: '38'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.height,
    required this.label,
    required this.value,
  });

  final double height;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.textSlate),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSlate,
              fontFamily: AppFonts.inter,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 18 / 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSlate,
              fontFamily: AppFonts.inter,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              height: 28 / 24,
            ),
          ),
        ],
      ),
    );
  }
}

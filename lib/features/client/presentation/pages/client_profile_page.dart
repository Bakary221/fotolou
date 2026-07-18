import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
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
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: AppTopHeader(showLocation: false),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 34, 26, 42),
              child: Column(
                children: [
                  const _ProfileHeader(),
                  const SizedBox(height: 31),
                  const _ProfileStats(),
                  const SizedBox(height: 50),
                  const ProfileSettingsGroup(
                    key: ClientProfileTokens.settingsGroupKey,
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
                    key: ClientProfileTokens.logoutButtonKey,
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
        ProfileAvatar(key: ClientProfileTokens.avatarKey, initials: 'B'),
        SizedBox(height: 12),
        Text(
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
        SizedBox(height: 9),
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

class _ProfileStats extends StatelessWidget {
  const _ProfileStats();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(label: 'TICKETS', value: '45'),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _StatCard(label: 'SERVIE', value: '38'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/features/authentication/dependency_injection/auth_providers.dart';
import 'package:fotolou/features/client/dependency_injection/client_providers.dart';
import 'package:fotolou/features/client/domain/entities/salon.dart';
import 'package:fotolou/features/client/presentation/widgets/client_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_search_field.dart';
import 'package:fotolou/shared/widgets/app_status_badge.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:fotolou/shared/widgets/role_page_scaffold.dart';
import 'package:go_router/go_router.dart';

abstract final class ClientHomeTokens {
  static const searchFieldKey = Key('client_home_search_field');
  static const sectionHeaderKey = Key('client_home_section_header');

  static Key salonItemKey(int index) => ValueKey('client_salon_item_$index');
}

class ClientHomePage extends ConsumerWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      authControllerProvider.select((state) => state.user),
    );
    final salons = ref.watch(nearbySalonsProvider);
    final firstName = user?.name.split(' ').first ?? 'Diassy';

    return RolePageScaffold(
      bottomNavigationBar: const ClientBottomNav(activeIndex: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppTopHeader(),
                const SizedBox(height: 43),
                _Greeting(firstName: firstName),
                const SizedBox(height: 26),
                const AppSearchField(
                  key: ClientHomeTokens.searchFieldKey,
                  hintText: 'Rechercher un salon',
                ),
                const SizedBox(height: 26),
                const _SectionHeader(key: ClientHomeTokens.sectionHeaderKey),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: salons.length,
              itemBuilder: (context, index) => _SalonListItem(
                key: ClientHomeTokens.salonItemKey(index),
                salon: salons[index],
                onTap: () => _openSalonDetail(context, salons[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSalonDetail(BuildContext context, Salon salon) {
    context.pushNamed(
      AppRoute.clientSalonDetail.name,
      queryParameters: {'salonId': salon.id},
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.firstName});

  final String firstName;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Bonjour , ',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: firstName,
            style: const TextStyle(
              color: AppColors.black,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w400,
            ),
          ),
          const TextSpan(text: '👋'),
        ],
      ),
      style: const TextStyle(
        color: AppColors.slate900,
        fontFamily: AppFonts.inter,
        fontSize: 32,
        height: 36 / 32,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          'Salons proches',
          style: TextStyle(
            color: AppColors.textStrong,
            fontFamily: AppFonts.inter,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 28 / 20,
          ),
        ),
        Spacer(),
        Text(
          'Voir tout',
          style: TextStyle(
            color: AppColors.secondary,
            fontFamily: AppFonts.inter,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SalonListItem extends StatelessWidget {
  const _SalonListItem({required this.salon, required this.onTap, super.key});

  final Salon salon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    salon.listImageAsset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    salon.name,
                                    style: const TextStyle(
                                      color: AppColors.ink,
                                      fontFamily: AppFonts.inter,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  Text(
                                    salon.location,
                                    style: const TextStyle(
                                      color: AppColors.textNeutral,
                                      fontFamily: AppFonts.inter,
                                      fontSize: 14,
                                      height: 20 / 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (salon.isOpen) const AppStatusBadge.open(),
                          ],
                        ),
                        const Spacer(),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${salon.waitingCount}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text: ' personnes',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            color: AppColors.textNeutral,
                            fontFamily: AppFonts.inter,
                            height: 18 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(height: 1, color: AppColors.dividerMuted),
            ),
          ],
        ),
      ),
    );
  }
}

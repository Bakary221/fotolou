import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/features/client/presentation/widgets/client_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:go_router/go_router.dart';

abstract final class ClientHomeTokens {
  static const searchFieldKey = Key('client_home_search_field');
  static const sectionHeaderKey = Key('client_home_section_header');

  static Key salonItemKey(int index) => ValueKey('client_salon_item_$index');
}

class ClientHomePage extends ConsumerWidget {
  const ClientHomePage({super.key});

  static const _kingBarberAsset = 'assets/images/client/king_barber.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final firstName = user?.name.split(' ').first ?? 'Diassy';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
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
                      const _SearchField(key: ClientHomeTokens.searchFieldKey),
                      const SizedBox(height: 26),
                      const _SectionHeader(
                        key: ClientHomeTokens.sectionHeaderKey,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          4,
                          (index) => _SalonListItem(
                            key: ClientHomeTokens.salonItemKey(index),
                            imageAsset: _kingBarberAsset,
                            onTap: () => _openSalonDetail(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const ClientBottomNav(activeIndex: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSalonDetail(BuildContext context) {
    context.pushNamed(AppRoute.clientSalonDetail.name);
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
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const TextSpan(text: '👋'),
        ],
      ),
      style: const TextStyle(
        color: AppColors.slate900,
        fontFamily: 'Inter',
        fontSize: 32,
        height: 36 / 32,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          SizedBox(width: 20),
          Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          SizedBox(width: 9),
          Text(
            'Rechercher un salon',
            style: TextStyle(
              color: AppColors.gray600,
              fontFamily: 'Inter',
              fontSize: 16,
            ),
          ),
        ],
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
            color: Color(0xFF1A1A1A),
            fontFamily: 'Inter',
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
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SalonListItem extends StatelessWidget {
  const _SalonListItem({
    required this.imageAsset,
    required this.onTap,
    super.key,
  });

  final String imageAsset;
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
                    imageAsset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
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
                                    'King Barber',
                                    style: TextStyle(
                                      color: AppColors.ink,
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  Text(
                                    'Mermoz, Dakar',
                                    style: TextStyle(
                                      color: Color(0xFF757575),
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      height: 20 / 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _OpenBadge(),
                          ],
                        ),
                        Spacer(),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '15',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' personnes',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontFamily: 'Inter',
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
              child: Divider(height: 1, color: Color(0x4D687280)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          'Ouvert',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }
}

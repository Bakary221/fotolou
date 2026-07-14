import 'package:flutter/material.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/shared/widgets/app_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class BarberBottomNav extends StatelessWidget {
  const BarberBottomNav({
    required this.activeIndex,
    this.onHomeTap,
    this.onTicketsTap,
    this.onProfileTap,
    super.key,
  });

  final int activeIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onTicketsTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return AppBottomNav(
      activeIndex: activeIndex,
      activeColor: AppColors.primary,
      items: [
        AppBottomNavItemData(
          icon: Icons.home_rounded,
          label: 'Accueil',
          onTap: onHomeTap ?? () => context.goNamed(AppRoute.barberHome.name),
        ),
        AppBottomNavItemData(
          icon: Icons.shopping_bag_outlined,
          label: 'Mes tickets',
          onTap:
              onTicketsTap ??
              () => context.goNamed(AppRoute.barberTickets.name),
        ),
        AppBottomNavItemData(
          icon: Icons.person_outline,
          label: 'Profil',
          onTap:
              onProfileTap ??
              () => context.goNamed(AppRoute.barberProfile.name),
        ),
      ],
    );
  }
}

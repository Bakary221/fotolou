import 'package:flutter/material.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class ClientBottomNav extends StatelessWidget {
  const ClientBottomNav({
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray100)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 69,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                isActive: activeIndex == 0,
                onTap:
                    onHomeTap ??
                    (activeIndex == 0
                        ? null
                        : () => context.goNamed(AppRoute.clientHome.name)),
              ),
              _BottomNavItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Mes tickets',
                isActive: activeIndex == 1,
                onTap: activeIndex == 1 ? null : onTicketsTap,
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                label: 'Profil',
                isActive: activeIndex == 2,
                onTap: activeIndex == 2 ? null : onProfileTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.secondary : AppColors.mutedInk;

    return SizedBox(
      width: 82,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

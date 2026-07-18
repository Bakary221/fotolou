import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

abstract final class AppBottomNavTokens {
  static const navKey = Key('app_bottom_nav');

  static Key itemKey(int index) => ValueKey('app_bottom_nav_item_$index');
}

class AppBottomNavItemData {
  const AppBottomNavItemData({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.activeIndex,
    this.activeColor = AppColors.secondary,
    this.inactiveColor = AppColors.mutedInk,
    super.key,
  });

  final List<AppBottomNavItemData> items;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: AppBottomNavTokens.navKey,
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
              for (var index = 0; index < items.length; index++)
                _AppBottomNavItem(
                  key: AppBottomNavTokens.itemKey(index),
                  item: items[index],
                  isActive: activeIndex == index,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBottomNavItem extends StatelessWidget {
  const _AppBottomNavItem({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    super.key,
  });

  final AppBottomNavItemData item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return SizedBox(
      width: 82,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isActive ? null : item.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontFamily: AppFonts.inter,
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

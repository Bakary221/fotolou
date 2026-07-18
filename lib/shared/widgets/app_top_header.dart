import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

abstract final class AppTopHeaderTokens {
  static const headerKey = Key('app_top_header');
  static const locationKey = Key('app_top_header_location');
  static const notificationButtonKey = Key(
    'app_top_header_notification_button',
  );
}

class AppTopHeader extends StatelessWidget {
  const AppTopHeader({
    this.location = 'Dakar, Sénégal',
    this.showLocation = true,
    this.onNotificationTap,
    super.key,
  });

  final String location;
  final bool showLocation;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: AppTopHeaderTokens.headerKey,
      height: 48,
      child: Row(
        children: [
          if (showLocation)
            Row(
              key: AppTopHeaderTokens.locationKey,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.red500,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: AppColors.textStrong,
                    fontFamily: AppFonts.inter,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 28 / 18,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.mutedInk,
                  size: 18,
                ),
              ],
            ),
          const Spacer(),
          IconButton(
            key: AppTopHeaderTokens.notificationButtonKey,
            tooltip: 'Notifications',
            visualDensity: VisualDensity.compact,
            onPressed: onNotificationTap,
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.headerIcon,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

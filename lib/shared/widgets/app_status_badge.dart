import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.borderRadius = 4,
    this.horizontalPadding = 8,
    this.verticalPadding = 2,
    super.key,
  });

  const AppStatusBadge.open({super.key})
    : label = 'Ouvert',
      foregroundColor = AppColors.openText,
      backgroundColor = AppColors.openSurface,
      borderRadius = 4,
      horizontalPadding = 8,
      verticalPadding = 2;

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: foregroundColor,
            fontFamily: AppFonts.inter,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }
}

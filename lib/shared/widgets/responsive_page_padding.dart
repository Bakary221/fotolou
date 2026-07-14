import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_spacing.dart';

class ResponsivePagePadding extends StatelessWidget {
  const ResponsivePagePadding({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 600 ? AppSpacing.md : AppSpacing.xl;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.lg,
      ),
      child: child,
    );
  }
}

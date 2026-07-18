import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotolou/app/theme/app_breakpoints.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_system_ui.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.body,
    this.backgroundColor = AppColors.white,
    this.systemUiOverlayStyle = AppSystemUi.light,
    this.maxContentWidth = AppBreakpoints.mobileContentMaxWidth,
    this.useSafeArea = true,
    super.key,
  });

  final Widget body;
  final Color backgroundColor;
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final double maxContentWidth;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final constrainedBody = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: body,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: useSafeArea
            ? SafeArea(bottom: false, child: constrainedBody)
            : constrainedBody,
      ),
    );
  }
}

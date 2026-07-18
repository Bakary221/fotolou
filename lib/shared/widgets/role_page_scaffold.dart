import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_breakpoints.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/shared/widgets/app_page_scaffold.dart';

class RolePageScaffold extends StatelessWidget {
  const RolePageScaffold({
    required this.body,
    required this.bottomNavigationBar,
    this.backgroundColor = AppColors.white,
    this.maxContentWidth = AppBreakpoints.pageContentMaxWidth,
    super.key,
  });

  final Widget body;
  final Widget bottomNavigationBar;
  final Color backgroundColor;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      backgroundColor: backgroundColor,
      maxContentWidth: maxContentWidth,
      body: Column(
        children: [
          Expanded(child: body),
          bottomNavigationBar,
        ],
      ),
    );
  }
}

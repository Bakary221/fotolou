import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';

abstract final class AppShadows {
  static const subtle = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowSlate,
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}

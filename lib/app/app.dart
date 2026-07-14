import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_router.dart';
import 'package:fotolou/app/theme/app_theme.dart';
import 'package:fotolou/core/constants/app_constants.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';

class FotolouApp extends ConsumerWidget {
  const FotolouApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: config.environment.isDevelopment,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/app.dart';
import 'package:fotolou/app/config/app_config.dart';
import 'package:fotolou/app/config/app_environment.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/core/services/app_logger.dart';

Future<void> bootstrap({AppEnvironment? environment}) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final config = AppConfig.fromEnvironment(environment);
      final logger = AppLogger(enabled: config.enableLogs);

      _configureGlobalErrorHandling(
        logger: logger,
        isDevelopment: config.environment.isDevelopment,
      );

      runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            appLoggerProvider.overrideWithValue(logger),
          ],
          child: const FotolouApp(),
        ),
      );
    },
    (error, stackTrace) {
      final config = AppConfig.fromEnvironment(environment);
      AppLogger(enabled: config.enableLogs).error(
        'Erreur Dart non interceptée.',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

void _configureGlobalErrorHandling({
  required AppLogger logger,
  required bool isDevelopment,
}) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.error(
      'Erreur Flutter non interceptée.',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.error(
      'Erreur plateforme non interceptée.',
      error: error,
      stackTrace: stackTrace,
    );

    return !isDevelopment;
  };

  if (kDebugMode) {
    ErrorWidget.builder = (details) {
      return ErrorWidget(details.exception);
    };
  }
}

import 'package:fotolou/app/config/app_environment.dart';
import 'package:fotolou/app/config/feature_flags.dart';

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.featureFlags,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 20),
  });

  factory AppConfig.fromEnvironment([AppEnvironment? override]) {
    const environmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );

    final environment = override ?? AppEnvironment.fromName(environmentName);

    return switch (environment) {
      AppEnvironment.development => AppConfig(
        environment: environment,
        apiBaseUrl: Uri.parse('https://dev.api.fotolou.local'),
        featureFlags: const FeatureFlags(
          useMockAuthentication: true,
          enableNetworkLogs: true,
        ),
      ),
      AppEnvironment.staging => AppConfig(
        environment: environment,
        apiBaseUrl: Uri.parse('https://staging.api.fotolou.example'),
        featureFlags: const FeatureFlags(
          useMockAuthentication: false,
          enableNetworkLogs: true,
        ),
      ),
      AppEnvironment.production => AppConfig(
        environment: environment,
        apiBaseUrl: Uri.parse('https://api.fotolou.example'),
        featureFlags: const FeatureFlags(
          useMockAuthentication: false,
          enableNetworkLogs: false,
        ),
      ),
    };
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final FeatureFlags featureFlags;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get enableLogs {
    return environment.isDevelopment && featureFlags.enableNetworkLogs;
  }
}

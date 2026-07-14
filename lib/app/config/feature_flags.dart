class FeatureFlags {
  const FeatureFlags({
    required this.useMockAuthentication,
    required this.enableNetworkLogs,
  });

  final bool useMockAuthentication;
  final bool enableNetworkLogs;
}

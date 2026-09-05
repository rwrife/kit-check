enum DataMode { localOnly }

class AppConfiguration {
  const AppConfiguration._({
    required this.dataMode,
    required this.allowNetworkRequests,
    required this.requiresAccount,
  });

  const AppConfiguration.localOnly()
    : this._(
        dataMode: DataMode.localOnly,
        allowNetworkRequests: false,
        requiresAccount: false,
      );

  final DataMode dataMode;
  final bool allowNetworkRequests;
  final bool requiresAccount;
}

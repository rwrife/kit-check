import 'package:flutter/material.dart';
import 'package:kit_check/app/app_configuration.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.configuration});

  final AppConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kit Check')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Semantics(
            label: 'Local first application summary',
            child: Text(
              'Prepare reusable trip kits and independent trip checklists.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Local-only mode: '
            '${configuration.dataMode == DataMode.localOnly ? 'enabled' : 'disabled'}',
          ),
          Text(
            'Network requests allowed: ${configuration.allowNetworkRequests}',
          ),
          Text('Account required: ${configuration.requiresAccount}'),
          const SizedBox(height: 16),
          const Text(
            'No cloud account is required. All MVP data stays on-device unless '
            'the user explicitly exports it.',
          ),
        ],
      ),
    );
  }
}

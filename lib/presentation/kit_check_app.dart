import 'package:flutter/material.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/persistence/kit_check_repository.dart';
import 'package:kit_check/presentation/home_screen.dart';

class KitCheckApp extends StatelessWidget {
  KitCheckApp({
    super.key,
    required this.configuration,
    KitCheckRepository? repository,
  }) : repository = repository ?? InMemoryKitCheckRepository();

  final AppConfiguration configuration;
  final KitCheckRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kit Check',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomeScreen(configuration: configuration, repository: repository),
    );
  }
}

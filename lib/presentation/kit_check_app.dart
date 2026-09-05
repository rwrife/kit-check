import 'package:flutter/material.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/presentation/home_screen.dart';

class KitCheckApp extends StatelessWidget {
  const KitCheckApp({super.key, required this.configuration});

  final AppConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kit Check',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomeScreen(configuration: configuration),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/presentation/kit_check_app.dart';

void main() {
  runApp(KitCheckApp(configuration: const AppConfiguration.localOnly()));
}

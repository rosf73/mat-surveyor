import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mat_surveyors/providers/lifecycle_provider.dart';
import 'package:mat_surveyors/widgets/lifecycle_widgets.dart';
import 'package:provider/provider.dart';

import 'mat_surveyors_app.dart';

void main() async {
  await _init();

  runApp(const App());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  await NaverMapSdk.instance.initialize(
      clientId: FlutterConfig.get('CLIENT_ID'),
      onAuthFailed: (error) {
        // process naver map auth failure
        log("Authentication Error: $error");
      }
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const LifecycleWidget(
        child: MatSurveyorsApp(),
      ),
    );
  }
}

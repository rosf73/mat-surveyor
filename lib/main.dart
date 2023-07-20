import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mat_surveyors/permission.dart';
import 'package:provider/provider.dart';

import 'mat_surveyors_app.dart';

void main() async {
  await _init();

  runApp(const App());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!await requestLocationPermission()) {
    exit(0);
    // process to reject any permission
  }

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
      child: const MatSurveyorsApp(),
    );
  }
}

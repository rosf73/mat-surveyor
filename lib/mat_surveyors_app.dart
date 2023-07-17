import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mat_surveyors/map.dart';

enum MatSurveyorsViewType {
  map,
  list,
}

class MatSurveyorsApp extends StatelessWidget {
  const MatSurveyorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        )
      ),
      routerConfig: GoRouter(routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _MatSurveyorsHome(),
          routes: const [
          ],
        )
      ]),
    );
  }
}

class _MatSurveyorsHome extends StatelessWidget {
  const _MatSurveyorsHome();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: Column(),
      body: IndexedStack(
        children: [
          MatMap(),
          Column(),
        ],
      ),
    );
  }
}

class AppState extends ChangeNotifier {

}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mat_surveyors/floating_action.dart';
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

  void onExtend() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const IndexedStack(
        children: [
          MatMap(),
          Column(),
        ],
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddOnCurrentPositionButton(),
            AddOnNewPositionButton(),
            AddExtendButton(),
          ],
        ),
      ),
    );
  }
}

// class _HomeContainer extends StatelessWidget {
//   const _HomeContainer();
//
//   @override
//   Widget build(BuildContext context) {
//     return Ce
//   }
// }

class AppState extends ChangeNotifier {

}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    log('position = ${position.latitude}, ${position.longitude}');
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          FutureBuilder(
            future: getCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              Position pos = snapshot.data;
              return MatMap(initPosition: pos);
            },
          ),
          const Column(),
        ],
      ),
      floatingActionButton: const MarkerAddButtons(),
    );
  }
}

class MarkerAddButtons extends StatefulWidget {
  const MarkerAddButtons({super.key});

  @override
  State<StatefulWidget> createState() => _MarkerAddButtonsState();
}

class _MarkerAddButtonsState extends State<MarkerAddButtons> {
  bool extended = false;
  onExtend() {
    setState(() {
      extended = !extended;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: extended ? 130.0 : 0.0,
            curve: Curves.fastOutSlowIn,
            child: const AddOnCurrentPositionButton(),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: extended ? 65 : 0,
            curve: Curves.fastOutSlowIn,
            child: const AddOnNewPositionButton(),
          ),
          AddExtendButton(onClick: onExtend),
        ],
      ),
    );
  }
}

class AppState extends ChangeNotifier {

}

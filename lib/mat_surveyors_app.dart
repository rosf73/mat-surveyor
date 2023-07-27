import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mat_surveyors/floating_action.dart';
import 'package:mat_surveyors/map.dart';
import 'package:mat_surveyors/onboard.dart';
import 'package:mat_surveyors/providers/lifecycle_provider.dart';
import 'package:mat_surveyors/utils/view_type.dart';
import 'package:provider/provider.dart';

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
          builder: (context, state) => const MatSurveyorsHome(),
          routes: const [
          ],
        )
      ]),
    );
  }
}

class MatSurveyorsHome extends StatefulWidget {
  const MatSurveyorsHome({super.key});

  @override
  State<StatefulWidget> createState() => _MatSurveyorsHomeState();
}

class _MatSurveyorsHomeState extends State<MatSurveyorsHome> {
  late AppState _appState;

  bool enableMarker = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = Provider.of<AppState>(context);
  }

  void _onTapMap({required bool enable, double? lat, double? lon}) {
    setState(() {
      enableMarker = enable;
    });
  }

  @override
  Widget build(BuildContext context)  {
    log("build main view");
    return Scaffold(
      body: MainScreen(viewType: _appState.mainViewType, position: _appState.position, onTapMap: _onTapMap),
      floatingActionButton: MarkerAddButtons(enableMarker: enableMarker),
    );
  }
}

class MainScreen extends StatelessWidget {
  final ViewType viewType;
  final Position? position;
  final void Function({
  required bool enable,
  double? lat,
  double? lon,
  }) onTapMap;

  const MainScreen({
    super.key,
    required this.viewType,
    this.position,
    required this.onTapMap,
  });

  @override
  Widget build(BuildContext context) {
    return (viewType == ViewType.loading) ? const Center(child: Text('Loading...'))
        : (viewType == ViewType.notice) ? const LocationOnboard()
        : (position != null) ? MatMap(initPosition: position!, onTapMap: onTapMap)
        : const Center(child: Text('지도를 불러오지 못했습니다.\nError: no position data'));
  }
}

class MarkerAddButtons extends StatefulWidget {
  final bool enableMarker;
  const MarkerAddButtons({super.key, required this.enableMarker});

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
      height: 300,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: extended && widget.enableMarker ? 130.0 : 0.0,
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

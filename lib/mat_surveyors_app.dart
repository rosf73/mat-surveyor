import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'floating_action.dart';
import 'map.dart';
import 'onboard.dart';
import 'providers/lifecycle_provider.dart';
import 'res/colors.dart';
import 'utils/view_type.dart';

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
        colorSchemeSeed: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: MatColors.primary,
          foregroundColor: Colors.white,
        ),
        dialogBackgroundColor: Colors.white,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = Provider.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context)  {
    log("build main view");
    return Scaffold(
      body: MainScreen(viewType: _appState.mainViewType, position: _appState.position),
      floatingActionButton: MarkerAddButtons(enableMarker: _appState.enableMarker),
    );
  }
}

class MainScreen extends StatelessWidget {
  final ViewType viewType;
  final Position? position;

  const MainScreen({
    super.key,
    required this.viewType,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return (viewType == ViewType.loading) ? const Center(child: Text('Loading...'))
        : (viewType == ViewType.notice) ? const LocationOnboard()
        : (position != null) ? const MatMap()
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
  late AppState appState;

  bool extended = false;
  onExtend(bool extend) {
    setState(() {
      extended = extend;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppState>(context);
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
            child: AddOnCurrentPositionButton(
              enable: widget.enableMarker,
              location: appState.markerLocation,
              onClick: () {
                onExtend(false);
              }
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: extended ? 65 : 0,
            curve: Curves.fastOutSlowIn,
            child: AddOnNewPositionButton(onClick: () {
              onExtend(false);
            }),
          ),
          AddExtendButton(onClick: () => onExtend(!extended)),
        ],
      ),
    );
  }
}

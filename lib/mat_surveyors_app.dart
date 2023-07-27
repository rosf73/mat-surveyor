import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mat_surveyors/exceptions/empty.dart';
import 'package:mat_surveyors/exceptions/no_permission.dart';
import 'package:mat_surveyors/floating_action.dart';
import 'package:mat_surveyors/map.dart';
import 'package:mat_surveyors/onboard.dart';
import 'package:mat_surveyors/permission.dart';
import 'package:mat_surveyors/providers/lifecycle_provider.dart';
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
  bool enableMarker = false;
  late Position position;

  Future<Position> _getCurrentLocation(AppLifecycleState? state) async {
    final granted = await _isGrantedPermission(state);
    if (granted == null) {
      throw ReturnEmptyException("");
    } else if (!granted) {
      throw NoPermissionException("");
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      log('position = ${position.latitude}, ${position.longitude}');
      return position;
    }
  }

  Future<bool?> _isGrantedPermission(AppLifecycleState? state) async {
    if (state == AppLifecycleState.resumed || state == null) {
      return await requestLocationPermission();
    } else {
      return null;
    }
  }

  void _onTapMap({required bool enable, double? lat, double? lon}) {
    setState(() {
      enableMarker = enable;
    });
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        body: IndexedStack(
          children: [
            Consumer<AppState>(
              builder: (context, provider, child) => FutureBuilder(
                future: _getCurrentLocation(provider.lifecycleState),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    log("exception = ${snapshot.error}");
                    if (snapshot.error is NoPermissionException) {
                      return const LocationOnboard();
                    } else if (snapshot.error is ReturnEmptyException) {
                      return Container();
                    } else {
                      return Center(child: Text('지도를 불러오지 못했습니다.\nError: ${snapshot.error}'));
                    }
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('Loading...'));
                  }

                  Position pos = snapshot.data;
                  return MatMap(initPosition: pos, onTapMap: _onTapMap);
                },
              ),
            ),
            const Column(),
          ],
        ),
        floatingActionButton: MarkerAddButtons(enableMarker: enableMarker),
    );
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

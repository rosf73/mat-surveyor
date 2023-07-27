import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mat_surveyors/permission.dart';
import 'package:mat_surveyors/utils/view_type.dart';

class AppState extends ChangeNotifier {
  AppLifecycleState? _lifecycleState; // input only state resumed
  AppLifecycleState? get lifecycleState => _lifecycleState;

  ViewType _mainViewType = ViewType.loading;
  ViewType get mainViewType => _mainViewType;

  Position? _position;
  Position? get position => _position;

  AppState() {
    _setMainView();
  }

  setLifecycle(AppLifecycleState state) async {
    log("set state = $state");
    _lifecycleState = state;

    _setMainView();
  }

  _setMainView() async {
    var granted = await requestLocationPermission();
    if (granted) {
      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _mainViewType = ViewType.done;
    } else {
      _mainViewType = ViewType.notice;
    }
    log("mainViewType = $mainViewType, position = $position");

    notifyListeners();
  }
}

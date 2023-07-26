import 'dart:developer';

import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  AppLifecycleState? _lifecycleState;
  AppLifecycleState? get lifecycleState => _lifecycleState;

  setLifecycle(AppLifecycleState state) {
    log("set state = $state");
    _lifecycleState = state;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lifecycle_provider.dart';

class LifecycleWidget extends StatefulWidget {
  final Widget child;
  const LifecycleWidget({
    super.key,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _LifecycleState();
}

class _LifecycleState extends State<LifecycleWidget> with WidgetsBindingObserver {

  bool _shouldNotifyLifecycle = true;
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _shouldNotifyLifecycle = true;
    }
    if (state == AppLifecycleState.resumed) {
      if (_shouldNotifyLifecycle) {
        _shouldNotifyLifecycle = false;
        _appState.setLifecycle(state);
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

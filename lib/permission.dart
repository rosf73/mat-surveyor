import 'package:permission_handler/permission_handler.dart';

Future<bool> requestLocationPermission() async {
  Map<Permission, PermissionStatus> status = await [
    Permission.location,
  ].request();

  if (await Permission.location.isGranted) {
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

// [VERBOSE-2:dart_vm_initializer.cc(41)] Unhandled Exception: PlatformException(ERROR_ALREADY_REQUESTING_PERMISSIONS, A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time)., null, null)
// #0      StandardMethodCodec.decodeEnvelope (package:flutter/src/services/message_codecs.dart:652:7)
// #1      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:310:18)
// <asynchronous suspension>
// #2      MethodChannelPermissionHandler.requestPermissions (package:permission_handler_platform_interface/src/method_channel/method_channel_permission_handler.dart:79:9)
// <asynchronous suspension>
// #3      requestLocationPermission (package:mat_surveyors/permission.dart:5:5)
// <asynchronous suspension>
// #4      _init (package:mat_surveyors/main.dart:21:8)
// <asynchronous suspension>
// #5      main (package:mat_surveyors/main.dart:13:3)
// <asynchronous suspension>

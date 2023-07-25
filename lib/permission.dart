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

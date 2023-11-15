import 'dart:developer';
import 'package:mat_surveyors/res/colors.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mat_surveyors/exceptions/empty.dart';
import 'package:mat_surveyors/providers/lifecycle_provider.dart';
import 'package:provider/provider.dart';

import 'data/local/dao/db_helper.dart';
import 'data/local/dto/location.dart';

class MatMap extends StatefulWidget {
  const MatMap({super.key});

  @override
  State<StatefulWidget> createState() => MatMapState();
}

class MatMapState extends State<MatMap> {
  late AppState _appState;

  Image myMarker = Image.asset('assets/marker.png');
  NLatLng? latLng;
  final bool isAOS = foundation.defaultTargetPlatform == foundation.TargetPlatform.android;

  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();

  @override
  void didChangeDependencies() {
    precacheImage(myMarker.image, context);
    super.didChangeDependencies();
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_appState.position == null) {
      throw ReturnEmptyException("");
    }
    var latLng = NLatLng(_appState.position!.latitude, _appState.position!.longitude);

    log("build map view");
    return Stack(
      children: [
        Center(
          child: NaverMap(
            options: options.copyWith(
              initialCameraPosition: NCameraPosition(target: latLng, zoom: 15,),
            ),
            onMapReady: onMapReady,
            onMapTapped: onMapTapped,
            onSymbolTapped: onSymbolTapped,
            onCameraChange: onCameraChange,
            onCameraIdle: onCameraIdle,
            onSelectedIndoorChanged: onSelectedIndoorChanged,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: TagButtons(
            onPressed: () {
              DBHelper().selectAllLocation().then((value) => showMarkers(value));
            },
          ),
        ),
      ]
    );
  }

  void onMapReady(NaverMapController controller) {
    mapController = controller;
  }

  void onMapTapped(NPoint point, NLatLng latLng) {
    _setMarker(
      latLng: latLng,
      id: 'tap',
      icon: Icon(Typicons.location, color: MatColors.onPrimary, size: (isAOS) ? 60 : 20),
      onTap: () {
        mapController.deleteOverlay(
            const NOverlayInfo(type: NOverlayType.marker, id: 'tap')
        );
        _appState.setEnableMarker(enable: false);
      }
    );
    _appState.setEnableMarker(enable: true, lat: latLng.latitude, lon: latLng.longitude);
  }

  void onSymbolTapped(NSymbolInfo symbolInfo) {
    // do something
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    if (latLng == null) {
      latLng = NLatLng(_appState.position!.latitude, _appState.position!.longitude);
      _setMarker(latLng: latLng!, id: 'my', icon: myMarker);
    }
  }

  void onCameraIdle() {
    // do something
  }

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {
    // do something
  }

  void _setMarker({
    required NLatLng latLng,
    required String id,
    required Widget icon,
    Function? onTap,
  }) async {
    final markerIcon = await NOverlayImage.fromWidget(
      widget: icon,
      size: (isAOS) ? const Size(72, 72) : const Size(24, 24),
      context: context,
    );

    final marker = NMarker(id: id, position: latLng, icon: markerIcon);
    marker.setOnTapListener((overlay) => {
      onTap?.call()
    });

    mapController.addOverlay(marker);
  }

  void showMarkers(List<Location> list) async {
    mapController.clearOverlays(type: NOverlayType.circleOverlay);
    mapController.addOverlayAll(
      list.map((e) {
        return NCircleOverlay(
          id: e.id.toString(),
          center: NLatLng(e.lat, e.lon),
          radius: 15,
          color: Colors.transparent,
          outlineColor: Colors.redAccent,
          outlineWidth: 3,
        );
      }).toSet()
    );
  }
}

class TagButtons extends StatelessWidget {
  final Function() onPressed;
  const TagButtons({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Get!',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

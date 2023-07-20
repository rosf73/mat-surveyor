import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:geolocator/geolocator.dart';

class MatMap extends StatefulWidget {
  final Position initPosition;

  const MatMap({
    super.key,
    required this.initPosition,
  });

  @override
  State<StatefulWidget> createState() => MatMapState();
}

class MatMapState extends State<MatMap> {
  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();

  @override
  Widget build(BuildContext context) {
    var latLng = NLatLng(widget.initPosition.latitude, widget.initPosition.longitude);

    return Center(
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
    );
  }

  void onMapReady(NaverMapController controller) async {
    var latLng = NLatLng(widget.initPosition.latitude, widget.initPosition.longitude);
    var isAOS = foundation.defaultTargetPlatform == foundation.TargetPlatform.android;

    final markerIcon = await NOverlayImage.fromWidget(
      widget: Image.asset('assets/marker.png'),
      size: (isAOS) ? const Size(72, 72) : const Size(24, 24),
      context: context,
    );
    final marker = NMarker(id: '1', position: latLng, icon: markerIcon);
    controller.addOverlay(marker);

    mapController = controller;
  }

  void onMapTapped(NPoint point, NLatLng latLng) {
    // do something
  }

  void onSymbolTapped(NSymbolInfo symbolInfo) {
    // do something
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    // do something
  }

  void onCameraIdle() {
    // do something
  }

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {
    // do something
  }
}

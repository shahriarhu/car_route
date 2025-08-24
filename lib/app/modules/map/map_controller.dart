import 'package:car_route/app/modules/map/map_repository.dart';
import 'package:car_route/app/ui/layouts/view_state_layout.dart';
import 'package:car_route/app/utils/asset_icons.dart';
import 'package:car_route/app/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final MapRepository _repository;

  MapController(this._repository);

  GoogleMapController? mapController;

  /// Map state
  final currentCenter = const LatLng(23.8103, 90.4125).obs;
  final trafficEnabled = true.obs;

  /// Selected points
  final origin = Rxn<LatLng>();
  final destination = Rxn<LatLng>();
  final originName = ''.obs;
  final destinationName = ''.obs;

  /// Markers & Polylines
  final markers = <MarkerId, Marker>{}.obs;
  final polylines = <PolylineId, Polyline>{}.obs;

  /// Loading states
  final isOriginLoading = false.obs;
  final isDestinationLoading = false.obs;

  /// Route summary
  final distance = ''.obs;
  final duration = ''.obs;

  /// Custom icons
  late BitmapDescriptor originIcon;
  late BitmapDescriptor destinationIcon;

  /// Map State
  Rx<DataState> mapDataState = DataState.initial.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkPermission();
    await _loadIcons();
  }

  /// **************************
  /// LOCATION PERMISSION
  /// **************************
  Future<bool> _checkPermission() async {
    mapDataState(DataState.loading);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission denied", "Location access is required.");
    }

    mapDataState(DataState.success);

    return true;
  }

  /// **************************
  /// ICONS & MARKERS
  /// **************************
  Future<void> _loadIcons() async {
    originIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28)),
      AssetIcons.origin,
    );
    destinationIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28)),
      AssetIcons.destination,
    );
  }

  void _updateMarker({
    required LatLng pos,
    required String id,
    required BitmapDescriptor icon,
    required String title,
    required String snippet,
  }) {
    markers[MarkerId(id)] = Marker(
      markerId: MarkerId(id),
      position: pos,
      icon: icon,
      infoWindow: InfoWindow(title: title, snippet: snippet),
    );
    markers.refresh();
  }

  /// **************************
  /// CURRENT LOCATION
  /// **************************
  Future<void> moveToCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      currentCenter.value = LatLng(position.latitude, position.longitude);
      animateCamera(currentCenter.value, 16);
    } catch (e) {
      Get.snackbar("Error", "Unable to get location: $e");
    }
  }

  /// **************************
  /// CAMERA CONTROL
  /// **************************
  void onCameraMove(CameraPosition pos) => currentCenter.value = pos.target;

  void moveCenterTo(LatLng pos) async {
    final bothSelected = origin.value != null && destination.value != null;
    if (bothSelected) return;

    currentCenter.value = pos;
    double? currentZoom = await mapController?.getZoomLevel();
    double targetZoom = (currentZoom != null && currentZoom > 18) ? currentZoom : 18;
    animateCamera(pos, targetZoom);
  }

  void animateCamera(LatLng pos, double zoom) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: zoom)),
    );
  }

  void toggleTraffic() => trafficEnabled.value = !trafficEnabled.value;

  /// **************************
  /// SELECT POINTS
  /// **************************
  Future<void> setOrigin(LatLng pos) async => await _setPoint(
    pos: pos,
    isOrigin: true,
  );

  Future<void> setDestination(LatLng pos) async => await _setPoint(
    pos: pos,
    isOrigin: false,
  );

  Future<void> _setPoint({required LatLng pos, required bool isOrigin}) async {
    final loading = isOrigin ? isOriginLoading : isDestinationLoading;
    final nameObs = isOrigin ? originName : destinationName;
    final markerId = isOrigin ? 'origin' : 'destination';
    final icon = isOrigin ? originIcon : destinationIcon;
    final title = isOrigin ? 'Origin' : 'Destination';

    loading.value = true;

    /// Save coordinates & name
    if (isOrigin) {
      origin.value = pos;
    } else {
      destination.value = pos;
    }

    nameObs.value = await _reverseGeocode(pos);
    loading.value = false;

    /// Update marker
    _updateMarker(
      pos: pos,
      id: markerId,
      icon: icon,
      title: title,
      snippet: nameObs.value,
    );

    /// Keep the other marker visible
    if (isOrigin && destination.value != null) {
      _updateMarker(
        pos: destination.value!,
        id: 'destination',
        icon: destinationIcon,
        title: 'Destination',
        snippet: destinationName.value,
      );
    } else if (!isOrigin && origin.value != null) {
      _updateMarker(
        pos: origin.value!,
        id: 'origin',
        icon: originIcon,
        title: 'Origin',
        snippet: originName.value,
      );
    }

    animateCamera(pos, 14);
  }

  Future<String> _reverseGeocode(LatLng pos) async {
    try {
      final list = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (list.isNotEmpty) {
        final p = list.first;
        final locality = p.locality ?? p.administrativeArea ?? '';
        final country = p.country ?? '';
        return (locality.isNotEmpty && country.isNotEmpty)
            ? '$locality, $country'
            : '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
      }
    } catch (_) {}
    return '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
  }

  /// **************************
  /// ROUTE
  /// **************************
  Future<void> buildRoute() async {
    if (origin.value == null || destination.value == null) return;

    try {
      final routeResponse = await _repository.getRoute(origin.value!, destination.value!);
      if (routeResponse.routes.isEmpty) return;

      final route = routeResponse.routes.first;

      distance.value = route.distanceMeters >= 1000
          ? '${(route.distanceMeters / 1000).toStringAsFixed(2)} km'
          : '${route.distanceMeters.toStringAsFixed(0)} m';

      duration.value = DateTimeHelper.formatDuration(route.duration);

      final pts = PolylinePoints.decodePolyline(
        route.polyline.encodedPolyline,
      ).map((e) => LatLng(e.latitude, e.longitude)).toList();

      polylines[const PolylineId('route')] = Polyline(
        polylineId: const PolylineId('route'),
        points: pts,
        width: 5,
        color: Colors.black,
        zIndex: 10,
      );
      polylines.refresh();

      if (pts.isNotEmpty && mapController != null) {
        final bounds = _calculateBounds(pts);
        await mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));

        Future.delayed(const Duration(milliseconds: 300), () {
          mapController?.showMarkerInfoWindow(const MarkerId('origin'));
          mapController?.showMarkerInfoWindow(const MarkerId('destination'));
        });
      }
    } catch (e) {
      Get.snackbar('Route error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> pts) {
    double minLat = pts.first.latitude,
        maxLat = pts.first.latitude,
        minLng = pts.first.longitude,
        maxLng = pts.first.longitude;

    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// **************************
  /// SWAP & RESET
  /// **************************
  Future<void> swapLocations() async {
    if (origin.value == null || destination.value == null) return;

    final tmpPos = origin.value;
    final tmpName = originName.value;

    origin.value = destination.value;
    originName.value = destinationName.value;

    destination.value = tmpPos;
    destinationName.value = tmpName;

    /// Update markers
    if (origin.value != null) {
      _updateMarker(
        pos: origin.value!,
        id: 'origin',
        icon: originIcon,
        title: 'Origin',
        snippet: originName.value,
      );
    }
    if (destination.value != null) {
      _updateMarker(
        pos: destination.value!,
        id: 'destination',
        icon: destinationIcon,
        title: 'Destination',
        snippet: destinationName.value,
      );
    }

    await buildRoute();
  }

  void reset() {
    origin.value = null;
    destination.value = null;
    originName.value = '';
    destinationName.value = '';
    markers.clear();
    polylines.clear();
    distance.value = '';
    duration.value = '';
  }
}

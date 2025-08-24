import 'package:car_route/app/core/commons/models/route_response_model.dart';
import 'package:car_route/app/modules/authentications/map/map_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRepository {
  final MapServices _service;

  MapRepository(this._service);

  Future<RouteResponse> getRoute(LatLng origin, LatLng destination) async {
    try {
      return await _service.getRoute(origin, destination);
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }
}

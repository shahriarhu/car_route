import 'package:car_route/app/core/apis/api_client.dart';
import 'package:car_route/app/core/apis/api_endpoints.dart';
import 'package:car_route/app/core/commons/models/route_response_model.dart';
import 'package:car_route/app/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  final ApiClient _apiClient = ApiClient();

  Future<RouteResponse> getRoute(LatLng origin, LatLng destination) async {
    final body = {
      "origin": {
        "location": {
          "latLng": {"latitude": origin.latitude, "longitude": origin.longitude},
        },
      },
      "destination": {
        "location": {
          "latLng": {"latitude": destination.latitude, "longitude": destination.longitude},
        },
      },
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": true,
      "units": "METRIC",
    };

    final res = await _apiClient.dio.post(
      ApiEndpoints.computeRoutes,
      data: body,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": AppConstants.googleMapApiKey,
          "X-Goog-FieldMask": "routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline",
        },
      ),
    );

    if (res.statusCode == 200) {
      return RouteResponse.fromJson(res.data);
    } else {
      throw Exception("Routes API error: ${res.data}");
    }
  }
}

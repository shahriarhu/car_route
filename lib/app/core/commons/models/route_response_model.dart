class RouteResponse {
  final List<Route> routes;

  RouteResponse({required this.routes});

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    final routesJson = json['routes'] as List? ?? [];
    final routesList = routesJson.map((e) => Route.fromJson(e)).toList();
    return RouteResponse(routes: routesList);
  }
}

class Route {
  final double distanceMeters;
  final String duration;
  final PolylineData polyline;

  Route({
    required this.distanceMeters,
    required this.duration,
    required this.polyline,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] as String? ?? '0s',
      polyline: PolylineData.fromJson(json['polyline'] ?? {}),
    );
  }
}

class PolylineData {
  final String encodedPolyline;

  PolylineData({required this.encodedPolyline});

  factory PolylineData.fromJson(Map<String, dynamic> json) {
    return PolylineData(
      encodedPolyline: json['encodedPolyline'] as String? ?? '',
    );
  }
}

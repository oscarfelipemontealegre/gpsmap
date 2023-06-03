import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<LatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) {
      return Directions(
        bounds: LatLngBounds(
          southwest: LatLng(0, 0),
          northeast: LatLng(0, 0),
        ),
        polylinePoints: [],
        totalDistance: '',
        totalDuration: '',
      );
    }

    final data = map['routes'][0];

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );

    // Distance and Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    // Polyline Points
    final List<PointLatLng> polylineCoordinates =
    PolylinePoints().decodePolyline(data['overview_polyline']['points']);
    final List<LatLng> polylinePoints = polylineCoordinates
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    return Directions(
      bounds: bounds,
      polylinePoints: polylinePoints,
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}

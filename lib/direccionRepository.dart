import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Direcction.dart';

class DirectionsRepository {
  static const _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
    required String apiKey,
  }) async {
    final response = await _dio.get(
      '$_baseUrl'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'key=AIzaSyD2KlFJcWqAnxgVebhKeMI1r89kM4Wf3Qg',
    );

    if (response.statusCode == 200) {
      final data = Map<String, dynamic>.from(json.decode(response.data));
      return Directions.fromMap(data);
    }

    return null;
  }
}

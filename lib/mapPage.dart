


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'Direcction.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController _mapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;


// ...

@override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Ir a configuración de ubicación');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
    });

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPSMAPS'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },

            polylines: {

                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info?.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList() ??[],
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)

           Positioned(
                top: 20,
                child: Container(
                 padding: const EdgeInsets.symmetric(
                   vertical: 10.0,
                    horizontal: 70.0,
                 ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ]
                  ),
                  child: Text(
                    '${_info?.totalDuration}, ${_info?.totalDuration }',
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),

                 ),
                ),
            ),
        ]
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          position: pos,
          infoWindow:const InfoWindow(title: 'Origen'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        );
        _destination = null;
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          position: pos,
          infoWindow:  const InfoWindow(title: 'Destino'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
      });

      final directions = await DirectionsRepository()
          .getDirections(origin: _origin!.position, destination: pos, apiKey: '');

      setState(() => _info = directions);
    }
  }
}

class DirectionsRepository {
  final _directionsService = DirectionsService();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination, required String apiKey,
  }) async {
    final directions = _directionsService.route(
      origin: origin,
      destination: destination,
    );
    return directions;
  }
}

class DirectionsService {
  Directions route({required LatLng origin, required LatLng destination}) {
    // Lógica para obtener la ruta y la información de dirección
    return Directions(
      bounds: LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0)),
      polylinePoints: [],
      totalDistance: '',
      totalDuration: '',
    );
  }
}




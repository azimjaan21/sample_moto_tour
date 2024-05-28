// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sample_moto_tour/tools/file_importer.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapControllerCompleter = Completer<YandexMapController>();

  Distance distance = Distance();

  var mapZoom = 0.0;

  List<PolylineMapObject> drivingMapLines = [];

  Point? currentLocation;
  String? startStreet;
  String? finalStreet;

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
    _getCurrentLocation();
  }

  void _handleLocationChange(Position position) {
    if (mounted) {
      setState(() {
        // Update the currentLocation with the new position
        currentLocation = Point(latitude: position.latitude, longitude: position.longitude);
      });

      // Move the map camera to the updated location
      _moveToCurrentLocation(currentLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },

            onCameraPositionChanged: (cameraPosition, _, __) {
              setState(() {
                mapZoom = cameraPosition.zoom;
              });
            },

            onMapTap: (Point point) async {
              if (distance.startLocation != null) {
                distance.finalLocation = point;
                List<Placemark> placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
                if (placemarks.isNotEmpty) {
                  setState(() {
                    finalStreet = placemarks[0].street;
                  });
                }
              } else {
                distance.startLocation = point;
                List<Placemark> placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
                if (placemarks.isNotEmpty) {
                  setState(() {
                    startStreet = placemarks[0].street;
                  });
                }
              }
              print(distance.getPoints());
            },

            mapObjects: [
              ..._getDrivingPlacemarks(context, drivingPoints: distance.getPoints()),
              ...drivingMapLines,
              if (currentLocation != null)
                PlacemarkMapObject(
                  mapId: const MapObjectId('user_location'),
                  point: currentLocation!,
                  icon: PlacemarkIcon.single(
                    PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage('assets/current.png'),
                      scale: 0.4,
                    ),
                  ),
                ),
            ],
          ),

          MapCustomBottomSheet(
            startLocation: startStreet ?? '',
            finalLocation: finalStreet ?? '',
            distance: calculateDistance(
              distance.startLocation?.latitude ?? 0,
              distance.startLocation?.longitude ?? 0,
              distance.finalLocation?.latitude ?? 0,
              distance.finalLocation?.longitude ?? 0,
            ).toStringAsFixed(2),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      distance.startLocation?.latitude ?? 0,
      distance.startLocation?.longitude ?? 0,
      distance.finalLocation?.latitude ?? 0,
      distance.finalLocation?.longitude ?? 0,
    );
    double distanceInKilometers = distanceInMeters / 1000;
    return distanceInKilometers;
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(Point(latitude: location.lat, longitude: location.long));
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Geolocator.getPositionStream().listen(_handleLocationChange);

      setState(() {
        currentLocation = Point(latitude: position.latitude, longitude: position.longitude);
      });

      _moveToCurrentLocation(currentLocation!);
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  Future<void> _moveToCurrentLocation(Point currentLocation) async {
    final mapController = await mapControllerCompleter.future;
    mapController.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 15,
        ),
      ),
    );
  }

  List<PlacemarkMapObject> _getDrivingPlacemarks(BuildContext context, {required List<Point> drivingPoints}) {
    return drivingPoints
        .map(
          (point) => PlacemarkMapObject(
            mapId: MapObjectId('MapObject $point'),
            point: Point(latitude: point.latitude, longitude: point.longitude),
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage('assets/image.png'),
                scale: 0.1,
              ),
            ),
          ),
        )
        .toList();
  }
}

class Distance {
  Point? startLocation;
  Point? finalLocation;

  Distance({this.startLocation, this.finalLocation});

  List<Point> getPoints() {
    List<Point> result = [];
    if (startLocation != null) {
      result.add(startLocation!);
    }
    if (finalLocation != null) {
      result.add(finalLocation!);
    }
    return result;
  }
}

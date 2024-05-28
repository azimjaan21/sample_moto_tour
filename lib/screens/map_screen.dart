// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:geocoding/geocoding.dart';
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

  var mapZoom = 15.0;

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
        currentLocation =
            Point(latitude: position.latitude, longitude: position.longitude);
      });

      // Move the map camera to the updated location
      _moveToCurrentLocation(currentLocation!);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/user.jpg'),
            ),
          )
        ],
        leading: Card(
          margin: const EdgeInsets.all(5),

          shape: const CircleBorder(),
          color: Colors.black, // Background color for the Card widget
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
        ),
      ),
      drawer: const Drawer(child: DrawerOptions()),
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
              _moveToCurrentLocation(point);
              if (!distance.startSelected) {
                distance.finalLocation = point;
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    point.latitude, point.longitude);
                if (placemarks.isNotEmpty) {
                  setState(() {
                    finalStreet = placemarks[0].street;
                  });
                }
              } else {
                distance.startLocation = point;
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    point.latitude, point.longitude);
                if (placemarks.isNotEmpty) {
                  setState(() {
                    startStreet = placemarks[0].street;
                  });
                }
              }
            },
            mapObjects: [
              ..._getDrivingPlacemarks(context,
                  drivingPoints: distance.getPoints()),
              ...drivingMapLines,
              if (currentLocation != null)
                PlacemarkMapObject(
                  mapId: const MapObjectId('user_location'),
                  point: currentLocation!,
                  icon: PlacemarkIcon.single(
                    PlacemarkIconStyle(
                      image:
                          BitmapDescriptor.fromAssetImage('assets/current.png'),
                      scale: 0.4,
                    ),
                  ),
                ),
              PolylineMapObject(
                mapId: const MapObjectId('route'),
                polyline: Polyline(points: distance.getPoints()),
                strokeColor: const Color(0xFF00FF0D),
                strokeWidth: 4,
              ),
            ],
          ),
          MapCustomBottomSheet(
            startLocation: startStreet ?? 'Select start',
            finalLocation: finalStreet ?? 'Select final',
            distance: calculateDistance(
              distance.startLocation?.latitude ?? 0,
              distance.startLocation?.longitude ?? 0,
              distance.finalLocation?.latitude ?? 0,
              distance.finalLocation?.longitude ?? 0,
            ),
            startSelected: distance.startSelected,
            onSelected: (int index) {
              setState(() {
                distance.startSelected = index == 0;
              });
            },
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  String calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    if (endLatitude == 0 && endLongitude == 0) {
      return "Select";
    }
    double distanceInMeters = Geolocator.distanceBetween(
      distance.startLocation?.latitude ?? 0,
      distance.startLocation?.longitude ?? 0,
      distance.finalLocation?.latitude ?? 0,
      distance.finalLocation?.longitude ?? 0,
    );
    double distanceInKilometers = distanceInMeters / 1000;
    return distanceInKilometers.toStringAsFixed(2) + " км";
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation =
            Point(latitude: position.latitude, longitude: position.longitude);
      });

      _moveToCurrentLocation(currentLocation!);
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  Future<void> _moveToCurrentLocation(Point currentLocation) async {
    final mapController = await mapControllerCompleter.future;
    mapController.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 16.5,
        ),
      ),
    );
  }

  List<PlacemarkMapObject> _getDrivingPlacemarks(BuildContext context,
      {required List<Point> drivingPoints}) {
    return drivingPoints
        .map(
          (point) => PlacemarkMapObject(
            mapId: MapObjectId('MapObject $point'),
            point: Point(latitude: point.latitude, longitude: point.longitude),
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage('assets/image.png'),
                scale: 0.3,
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
  bool startSelected;

  Distance({this.startLocation, this.finalLocation, this.startSelected = true});

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

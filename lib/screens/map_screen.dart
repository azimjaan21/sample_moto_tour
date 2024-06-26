// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print

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
//
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

  ///////////////  ####  Add Rides  ####   //////////////////////
  void _saveRide() async {
    await Future.delayed(const Duration(seconds: 1));
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
      width: 280,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      onDismissCallback: (type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dismissed by $type'),
          ),
        );
      },
    );

    if (startStreet != null && finalStreet != null) {
      int waitTime =
          Random().nextInt(6) + 5; // Random time between 5-10 minutes
      Ride newRide = Ride(
        startStreet: startStreet!,
        finalStreet: finalStreet!,
        waitTime: waitTime,
        status: "waiting",
        startTime: DateTime.now(), // Set the start time to the current time
      );
      await DatabaseHelper().insertRide(newRide);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RidesScreen()),
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        actions: const [],
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
      drawer: Drawer(
        shape: const BeveledRectangleBorder(),
        backgroundColor: AppColors.motoTourColor,
        child: DrawerOptions(),
      ),
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
                strokeWidth: 5,
              ),
            ],
          ),

          //   ######### bottom sheet ###########

          MapCustomBottomSheet(
            startLocation: startStreet ?? 'Откуда',
            finalLocation: finalStreet ?? 'Куда',
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
            onPressed: _saveRide,
          ),
        ],
      ),
    );
  }

  String calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    if (endLatitude == 0 && endLongitude == 0) {
      return "Маршрут";
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

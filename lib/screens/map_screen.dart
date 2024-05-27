import 'dart:async';

import 'package:sample_moto_tour/services/app_location.service.dart';
import 'package:sample_moto_tour/tools/file_importer.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
 const MapScreen({super.key});

 @override
 State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
 final mapControllerCompleter = Completer<YandexMapController>();

@override
void initState() {
 super.initState();
 _initPermission().ignore();
}

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
      centerTitle: true,
       title: const Text('Текущее местоположение'),
     ),
     body: YandexMap(
       onMapCreated: (controller) {
         mapControllerCompleter.complete(controller);
       },
     ),
   );
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
 _moveToCurrentLocation(location);
}
Future<void> _moveToCurrentLocation(
 AppLatLong appLatLong,
) async {
 (await mapControllerCompleter.future).moveCamera(
   animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
   CameraUpdate.newCameraPosition(
     CameraPosition(
       target: Point(
         latitude: appLatLong.lat,
         longitude: appLatLong.long,
       ),
       zoom: 12,
     ),
   ),
 );
}
}
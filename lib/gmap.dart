import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class GMap extends StatefulWidget {
  GMap({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GMapState();

  var currentPosition = Position(
      accuracy: 0,
      speed: 0,
      altitude: 0,
      heading: 0,
      latitude: 0,
      longitude: 0,
      speedAccuracy: 0,
      timestamp: DateTime.now());

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class GMapState extends State<GMap> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          const CameraPosition(target: LatLng(0, 0), zoom: 0),
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    widget.currentPosition = await widget._determinePosition();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            widget.currentPosition.latitude, widget.currentPosition.longitude),
        zoom: 15.0)));
    // lol
  }
}

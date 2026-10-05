import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Location service on ache kina check kora
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location service off thakle settings open korar jonno
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // 2. Permission check kora
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // 3. Current position fetch kora
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
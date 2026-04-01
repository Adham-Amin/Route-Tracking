import 'package:location/location.dart';

class LocationServices {
  final Location _location = Location();

  Future<void> _ensureInitialized() async {
    bool serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service disabled');
      }
    }

    PermissionStatus permission = await _location.hasPermission();

    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();

      if (permission != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      throw Exception('Location permission permanently denied');
    }
  }

  Future<LocationData> getCurrentLocation() async {
    await _ensureInitialized();
    return await _location.getLocation();
  }

  Stream<LocationData> getLocationStream() async* {
    await _ensureInitialized();

    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );

    yield* _location.onLocationChanged;
  }
}

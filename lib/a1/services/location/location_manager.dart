import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  static bool locationEnabled;

  static LocationPermission permission;

  static bool canUseLocation() {
    switch (permission) {
      case LocationPermission.denied:
        return false;
        break;
      case LocationPermission.deniedForever:
        return false;
        break;
      case LocationPermission.whileInUse:
        return true;
        break;
      case LocationPermission.always:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  static void initializeLocation() async {
    locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      ///
    }
  }

  static Future checkPermission() async {
    permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Denied");
        }
        break;
      case LocationPermission.deniedForever:
        print("Denied forever");
        break;
      case LocationPermission.whileInUse:
        break;
      case LocationPermission.always:
        break;
      case LocationPermission.unableToDetermine:
        // TODO: Handle this case.
        break;
    }
  }

  static Future<Position> get position async {
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    } else {
      return null;
    }
  }

  static void forcePermissions() async {
    if (Platform.isIOS) {
      await Geolocator.openAppSettings();
    } else {
      await Geolocator.openLocationSettings();
    }
  }

  static Future<Placemark> get placeMark async {
    Position pos = await position;
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    return placeMarks.first;
  }

  static Future<List<String>> get placeMarkTags async {
    Placemark placemark = await placeMark;

    return [
      placemark.subLocality,
      placemark.locality,
      placemark.administrativeArea,
      placemark.country
    ];
  }
}

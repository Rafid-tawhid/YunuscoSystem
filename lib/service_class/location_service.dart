import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationsHelperClass {
  static Future<Position?> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show a dialog to enable location services.
      await _showLocationServiceDialog(context);
      // Try to open location settings.
      await Geolocator.openLocationSettings();
      return null;
    }

    // Check location permission status.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permission.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If permission is denied, show a dialog.
        await _showPermissionDeniedDialog(context);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // If permission is permanently denied, open app settings.
      await _showPermissionDeniedForeverDialog(context);
      await Geolocator.openAppSettings();
      return null;
    }

    // When we reach here, permissions are granted and we can get the location.
    try {
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      // Handle exceptions (e.g., timeout, location service disabled after checking).
      await _showErrorDialog(context, e.toString());
      return null;
    }
  }
}

Future<void> _showLocationServiceDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enable Location Services'),
        content: Text(
            'Location services are disabled. Please enable them in your device settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            child: Text('Settings'),
          ),
        ],
      );
    },
  );
}

Future<void> _showPermissionDeniedDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission Denied'),
        content: Text(
            'Location permission is denied. Please grant location permission to continue.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> _showPermissionDeniedForeverDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission Denied Forever'),
        content: Text(
            'Location permission is permanently denied. Please enable it from the app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      );
    },
  );
}

Future<void> _showErrorDialog(BuildContext context, String message) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text('An error occurred: $message'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

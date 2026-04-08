import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceServices {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static const Uuid _uuid = Uuid();

  /// Gets device info with safe fallbacks (Recommended Version)
  static Future<Map<String, String>> getAndStoreDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String deviceId = await getStableDeviceId(prefs);

    // Attempt to get accurate location (this may trigger permission requests)
    final locationData = await _getLocationWithPermission();

    final lt = locationData['lt']!;
    final ln = locationData['ln']!;

    await prefs.setString('device_id', deviceId);
    await prefs.setString('lt', lt);
    await prefs.setString('ln', ln);

    return {'device_id': deviceId, 'lt': lt, 'ln': ln};
  }

  /// Create a stable device ID
  static Future<String> getStableDeviceId(SharedPreferences prefs) async {
    // Return previously stored ID if available
    String? storedId = prefs.getString('device_id');
    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }

    String? hardwareId;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // fallback to androidId if possible, or just build info
        hardwareId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        hardwareId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Failed to get hardware device ID: $e");
    }

    // Fallback to UUID if hardware ID is not reliable
    final stableId =
        (hardwareId != null && hardwareId.isNotEmpty && hardwareId != "unknown")
        ? hardwareId
        : _uuid.v4();

    return stableId;
  }

  /// Get location with permission check and service enabling
  static Future<Map<String, String>> _getLocationWithPermission() async {
    String lt = "0.0";
    String ln = "0.0";

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        return {'lt': lt, 'ln': ln};
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try requesting permissions again.
          debugPrint("Location permissions are denied.");
          return {'lt': lt, 'ln': ln};
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        debugPrint("Location permissions are permanently denied.");
        return {'lt': lt, 'ln': ln};
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        debugPrint("Error getting current position: $e");
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        lt = position.latitude.toStringAsFixed(6);
        ln = position.longitude.toStringAsFixed(6);
      }
    } catch (e) {
      debugPrint("Location fetch failed: $e");
    }

    return {'lt': lt, 'ln': ln};
  }

  /// Show a dialog if location is disabled or missing
  static void showLocationRequiredPopup(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text(
          "Please enable location services and grant permission.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
              if (onRetry != null) onRetry();
            },
            child: const Text("Enable / Settings"),
          ),
        ],
      ),
    );
  }
}

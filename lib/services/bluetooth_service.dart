import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:wifi_scan/wifi_scan.dart';

// --- Data Model ---

/// Enumeration for the type of device found.
enum DeviceType { bluetooth, wifi, printer }

/// A unified model to represent any scanned device.
class ConnectedDevice {
  final String id; // Unique identifier (MAC address, BLE ID, SSID)
  final String name;
  final DeviceType type;

  ConnectedDevice({required this.id, required this.name, required this.type});

  /// Custom display string for the DropdownButton.
  @override
  String toString() {
    String typeLabel;
    switch (type) {
      case DeviceType.bluetooth:
        typeLabel = 'Bluetooth';
        break;
      case DeviceType.wifi:
        typeLabel = 'Wi-Fi';
        break;
      case DeviceType.printer:
        typeLabel = 'Printer';
        break;
    }
    return '$name ($typeLabel)';
  }

  @override
  // Used for reliable storage in maps/sets
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ConnectedDevice &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

// --- Scanning Services ---

final FlutterReactiveBle _ble = FlutterReactiveBle();

/// Scans for Bluetooth Low Energy (BLE) devices for a fixed duration.
Future<List<ConnectedDevice>> scanBluetoothDevices() async {
  final Map<String, ConnectedDevice> uniqueDevices = {};
  const scanDuration = Duration(seconds: 4);

  try {
    // Start the scan and listen to the stream of discovered devices
    final scanSubscription = _ble.scanForDevices(
      withServices: [], // Scan for all devices
      scanMode: ScanMode.lowLatency,
    ).listen(
          (DiscoveredDevice device) {
        if (device.name.isNotEmpty) {
          // Use device.id as the unique identifier
          uniqueDevices[device.id] = ConnectedDevice(
            id: device.id,
            name: device.name,
            type: DeviceType.bluetooth,
          );
        }
      },
      onError: (e) => print('BLE Scan Error: $e'),
    );

    // Wait for the scan duration to elapse
    await Future.delayed(scanDuration);

    // Stop the scan and cancel the stream subscription
    await scanSubscription.cancel();

  } catch (e) {
    print('Bluetooth scanning failed (permissions/state issue): $e');
  }

  // Return unique devices collected during the scan
  return uniqueDevices.values.toList();
}


/// Scans for nearby Wi-Fi access points (SSIDs).
Future<List<ConnectedDevice>> scanWifiDevices() async {
  final List<ConnectedDevice> wifiDevices = [];

  // Check if Wi-Fi scanning is allowed (handles permissions check)
  final can = await WiFiScan.instance.canStartScan(askPermissions: true); // 1. Check permissions and status
  if (can != CanStartScan.yes) { // 2. If requirements are NOT met...
    print('Wi-Fi scan not possible: $can'); // 3. ...print the reason
    return []; // 4. ...and stop the function, returning an empty list
  }

  try {
    // Get the results of the most recent scan
    final accessPoints = await WiFiScan.instance.getScannedResults();

    for (var ap in accessPoints) {
      // Filter out empty SSIDs and use SSID as both name and ID
      if (ap.ssid.isNotEmpty) {
        wifiDevices.add(ConnectedDevice(
          id: ap.ssid,
          name: ap.ssid,
          type: DeviceType.wifi,
        ));
      }
    }
  } catch (e) {
    print('Wi-Fi scan error: $e');
  }

  // Use toSet().toList() to remove any duplicates from the access points list
  return wifiDevices.toSet().toList();
}


/// Combines results from all scanning services into a single list.
Future<List<ConnectedDevice>> fetchAllDevices() async {
  List<ConnectedDevice> devices = [];

  // 1. Fetch Bluetooth Devices
  devices.addAll(await scanBluetoothDevices());

  // 2. Fetch Wi-Fi Devices
  devices.addAll(await scanWifiDevices());

  // 3. Optional: Add printer scanning logic here if using a compatible package.

  return devices;
}
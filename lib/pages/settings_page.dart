import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/bluetooth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController urlController = TextEditingController();
  List<ConnectedDevice> devices = [];
  ConnectedDevice? selectedDevice;
  bool isLoading = false; // Add a loading state

  @override
  void initState() {
    super.initState();
    loadSavedUrl();
    loadDevices();
  }

  void loadSavedUrl() async {
    String? url = await StorageService.loadUrl();
    if (url != null) urlController.text = url;
    setState(() {});
  }

  void loadDevices() async {
    setState(() {
      isLoading = true; // Start loading
      devices = [];
      selectedDevice = null;
    });

    try {
      // Call the service function to get all Bluetooth and Wi-Fi devices
      var d = await fetchAllDevices();

      setState(() {
        devices = d;
        // Optionally select the first item found
        selectedDevice = d.isNotEmpty ? d.first : null;
      });
    } catch (e) {
      print('Error loading devices: $e');
      // Optionally show a SnackBar or AlertDialog on error
    } finally {
      setState(() {
        isLoading = false; // Stop loading regardless of success/fail
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(labelText: "Enter website URL"),
            ),
            SizedBox(height: 20),

            // --- The Dropdown Button ---
            DropdownButton<ConnectedDevice>(
              isExpanded: true,
              hint: const Text("Select Network Device"),
              // The value must be an item from the 'devices' list
              value: selectedDevice,

              // Disable the dropdown while loading or if list is empty
              onChanged: isLoading || devices.isEmpty
                  ? null
                  : (ConnectedDevice? v) {
                setState(() => selectedDevice = v);
              },

              // Map the devices list to DropdownMenuItem widgets
              items: devices
                  .map((d) => DropdownMenuItem<ConnectedDevice>(
                value: d,
                // Use the custom toString() or the explicit name/type
                // defined in the ConnectedDevice model for display.
                child: Text(d.toString()),
              ))
                  .toList(),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await StorageService.saveUrl(urlController.text);
                Navigator.pushNamed(context, "/webview");
              },
              child: Text("Save & Open WebView"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/bluetooth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController urlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: urlController,
                keyboardType: TextInputType.url,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),

                decoration: InputDecoration(
                  labelText: "Enter website URL",
                  labelStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'e.g. https://www.google.com',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),

                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  } else if (!value.startsWith('https://')) {
                    return 'URL must start with https://';
                  }
                  return null;
                },


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
                  String url = urlController.text.trim();

                  // Validation
                  if (url.isEmpty) {
                    // Show error if empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a URL")),
                    );
                    return;
                  } else if (!url.startsWith('https://')) {
                    // Show error if URL doesn't start with https://
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("URL must start with https://")),
                    );
                    return;
                  }

                  // Save URL and navigate
                  await StorageService.saveUrl(url);
                  Navigator.pushNamed(context, "/webview");
                },
                child: Text("Save & Open WebView"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

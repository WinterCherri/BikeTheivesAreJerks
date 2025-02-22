import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'views/device_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner test2',
      theme: ThemeData(primarySwatch: Colors.red),
      home: BLEScanner(),
    );
  }
}

class BLEScanner extends StatefulWidget {
  @override
  _BLEScannerState createState() => _BLEScannerState();
}

class _BLEScannerState extends State<BLEScanner> {
  List<BluetoothDevice> devicesList = [];
  bool isScanning = false;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((
      BluetoothAdapterState state,
    ) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // Bluetooth is enabled, proceed with BLE operations
      } else {
        // Bluetooth is off or in an error state, handle appropriately
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enable Bluetooth to scan for devices"),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> startScan() async {
    setState(() {
      isScanning = true;
      devicesList.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 3));
      setState(() {
        isScanning = false;
      });

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (!devicesList.contains(r.device)) {
            setState(() {
              devicesList.add(r.device);
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        isScanning = false;
      });
      if (e.toString().contains('User cancelled')) {
        // Handle user cancellation
        print('User cancelled the Bluetooth device selection');
      } else {
        // Handle other errors
        print('An error occurred: $e');
      }
    }
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      print("Connected to ${device.platformName}");

      // Listen for connection state changes
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.connected) {
          print("Successfully connected to ${device.platformName}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Connected to ${device.platformName}")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceDetailsScreen(device: device),
            ),
          );
        } else if (state == BluetoothConnectionState.disconnected) {
          print("Disconnected from ${device.platformName}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Disconnected from ${device.platformName}")),
          );
        }
      });
    } catch (e) {
      print("Failed to connect to ${device.platformName}: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to ${device.platformName}")),
      );
    }
  }

  void unpairDevice(BluetoothDevice device) async {
    await device.disconnect();
    setState(() {
      devicesList.remove(device);
    });
    print("Disconnected from ${device.platformName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLE Scanner')),
      body: Column(
        children: [
          Expanded(
            child:
                devicesList.isEmpty && !isScanning
                    ? Center(
                      child: Text(
                        "No nearby Bluetooth devices found",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount:
                          devicesList
                              .where((device) => device.platformName.isNotEmpty)
                              .length,
                      itemBuilder: (context, index) {
                        var filteredDevices =
                            devicesList
                                .where(
                                  (device) => device.platformName.isNotEmpty,
                                )
                                .toList();
                        return ListTile(
                          title: Text(filteredDevices[index].platformName),
                          subtitle: Text(
                            filteredDevices[index].remoteId.toString(),
                          ),
                          onTap: () => connectToDevice(filteredDevices[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed:
                                () => unpairDevice(filteredDevices[index]),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isScanning ? null : startScan,
              child: Text(
                kIsWeb ? "Start Scan" : (isScanning ? "Scanning..." : "Rescan"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

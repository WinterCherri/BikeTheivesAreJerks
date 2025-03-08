import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:math';

class DeviceDetailsScreen extends StatefulWidget {
  final BluetoothDevice device;

  DeviceDetailsScreen({required this.device});

  @override
  _DeviceDetailsScreenState createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  int? rssi;
  Timer? _timer;
  String receivedData = "";

  @override
  void initState() {
    super.initState();
    _startRssiUpdates();
    _startListeningForData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRssiUpdates() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      try {
        int newRssi = await widget.device.readRssi();
        if (mounted) {
          setState(() {
            rssi = newRssi;
          });
        }
      } catch (e) {
        print("Error reading RSSI: $e");
        if (e.toString().contains("device is not connected")) {
          _timer?.cancel();
          _showDisconnectedDialog();
        }
      }
    });
  }

  void _startListeningForData() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              setState(() {
                receivedData = String.fromCharCodes(value);
              });
            });
          }
        }
      }
    } catch (e) {
      print("Error discovering services: $e");
      _showDisconnectedDialog();
    }
  }

  void _showDisconnectedDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Disconnected"),
            content: Text("The device has been disconnected."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            rssi == null
                ? CircularProgressIndicator()
                : Text(
                  'Distance: ${calculateDistance(rssi!).toStringAsFixed(2)} meters',
                ),
            SizedBox(height: 20),
            Text(
              'Received Data: $receivedData',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  double calculateDistance(int rssi) {
    // Example formula to calculate distance from RSSI
    int txPower = -59; // Default value for most BLE devices
    if (rssi == 0) {
      return -1.0; // if we cannot determine accuracy, return -1.
    }

    double ratio = rssi * 1.0 / txPower;
    if (ratio < 1.0) {
      return pow(ratio, 10).toDouble();
    } else {
      double distance = (0.89976) * pow(ratio, 7.7095) + 0.111;
      return distance;
    }
  }
}

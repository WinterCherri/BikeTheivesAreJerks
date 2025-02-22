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

  @override
  void initState() {
    super.initState();
    _startRssiUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRssiUpdates() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      int newRssi = await widget.device.readRssi();
      setState(() {
        rssi = newRssi;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Details')),
      body: Center(
        child:
            rssi == null
                ? CircularProgressIndicator()
                : Text(
                  'Distance: ${calculateDistance(rssi!).toStringAsFixed(2)} meters',
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

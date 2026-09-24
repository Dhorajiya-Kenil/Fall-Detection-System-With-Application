

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(SensorApp());
}

class SensorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SensorHomePage(),
    );
  }
}

class SensorHomePage extends StatefulWidget {
  @override
  _SensorHomePageState createState() => _SensorHomePageState();
}

class _SensorHomePageState extends State<SensorHomePage> {
  // Variables to store accelerometer and gyroscope data
  double _accelX = 0.0, _accelY = 0.0, _accelZ = 0.0;
  double _gyroX = 0.0, _gyroY = 0.0, _gyroZ = 0.0;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  // Variables for shake detection
  static const double shakeThreshold = 12.0; // Adjust this value for sensitivity
  int shakeCount = 0;
  final int maxShakes = 3; // Stop collecting data after detecting this many shakes

  @override
  void initState() {
    super.initState();
    startCollectingData();
  }

  void startCollectingData() {
    // Listen to accelerometer sensor
    _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelX = event.x;
        _accelY = event.y;
        _accelZ = event.z;
      });
      detectShake(event);
    });

    // Listen to gyroscope sensor
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroX = event.x;
        _gyroY = event.y;
        _gyroZ = event.z;
      });
    });
  }

  void stopCollectingData() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    setState(() {
      shakeCount = 0; // Reset shake count for potential future data collection
    });
  }

  void detectShake(AccelerometerEvent event) {
    double totalAcceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    if (totalAcceleration > shakeThreshold) {
      shakeCount++;
      print("Shake detected: $shakeCount");

      if (shakeCount >= maxShakes) {
        stopCollectingData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data collection stopped due to shake."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Sensor Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              if (_accelSubscription == null || _gyroSubscription == null) {
                startCollectingData();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Accelerometer Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildSensorDataDisplay('X', _accelX),
            _buildSensorDataDisplay('Y', _accelY),
            _buildSensorDataDisplay('Z', _accelZ),
            SizedBox(height: 20),
            Text(
              'Gyroscope Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildSensorDataDisplay('X', _gyroX),
            _buildSensorDataDisplay('Y', _gyroY),
            _buildSensorDataDisplay('Z', _gyroZ),
            SizedBox(height: 20),
            Expanded(child: _buildSensorGraph()),
          ],
        ),
      ),
    );
  }

  // Helper widget to display sensor data
  Widget _buildSensorDataDisplay(String axis, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$axis Axis', style: TextStyle(fontSize: 18)),
          Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // Visualization of sensor data
  Widget _buildSensorGraph() {
    return CustomPaint(
      painter: SensorGraphPainter(_accelX, _accelY, _accelZ, _gyroX, _gyroY, _gyroZ),
      child: Container(),
    );
  }
}

class SensorGraphPainter extends CustomPainter {
  final double accelX, accelY, accelZ;
  final double gyroX, gyroY, gyroZ;

  SensorGraphPainter(this.accelX, this.accelY, this.accelZ, this.gyroX, this.gyroY, this.gyroZ);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw accelerometer data as lines
    final accelPath = Path();
    accelPath.moveTo(0, size.height / 2 + accelX * 10);
    accelPath.lineTo(size.width / 3, size.height / 2 + accelY * 10);
    accelPath.lineTo(2 * size.width / 3, size.height / 2 + accelZ * 10);
    canvas.drawPath(accelPath, paint);

    // Draw gyroscope data as lines
    final gyroPath = Path();
    gyroPath.moveTo(0, size.height / 2 - gyroX * 10);
    gyroPath.lineTo(size.width / 3, size.height / 2 - gyroY * 10);
    gyroPath.lineTo(2 * size.width / 3, size.height / 2 - gyroZ * 10);
    paint.color = Colors.red;
    canvas.drawPath(gyroPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:fall/Contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart'; // ✅ added for location
import '../NotificationsPage.dart';
import '../ProfilePage.dart';

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
  double _accelX = 0.0, _accelY = 0.0, _accelZ = 0.0;
  double _gyroX = 0.0, _gyroY = 0.0, _gyroZ = 0.0;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  static const double shakeThreshold = 13.0;
  final TwilioService _twilioService = TwilioService();
  Timer? _shakeTimer;
  bool _smsCancelled = false;

  @override
  void initState() {
    super.initState();
    startCollectingData();
  }

  // ✅ Notifications list
  List<Map<String, String>> _notifications = [];

  void startCollectingData() {
    _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelX = event.x;
        _accelY = event.y;
        _accelZ = event.z;
      });
      detectShake(event);
    });

    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroX = event.x;
        _gyroY = event.y;
        _gyroZ = event.z;
      });
    });
  }

  void detectShake(AccelerometerEvent event) {
    double totalAcceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    if (totalAcceleration > shakeThreshold) {
      _smsCancelled = false;
      _shakeTimer?.cancel();
      _shakeTimer = Timer(Duration(seconds: 10), () {
        if (!_smsCancelled) {
          sendShakeSMS();
        }
      });
      showCancelDialog();
    }
  }

  Future<void> sendShakeSMS() async {
    String phoneNumber = "+49155...22825"; // Replace with your number

    try {
      // ✅ Get live location
      Position position = await _determinePosition();
      String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      String message = "⚠️ Fall detected!\n\nLocation: $googleMapsUrl";

      await _twilioService.sendSMS(phoneNumber, message);

      // ✅ Add a new notification
      setState(() {
        _notifications.add({
          'icon': 'assets/images/fall.png',
          'heading': 'Fall Detected',
          'subheading': 'SMS sent with location',
        });
      });
    } catch (e) {
      print("❌ Failed to get location: $e");
    }
  }

  // ✅ Location helper
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Timer to close the dialog after 10 seconds
        Timer(Duration(seconds: 10), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // Close the dialog
            print("Dialog automatically closed after 10 seconds.");
          }
        });

        return AlertDialog(
          title: Text("Shake Detected"),
          content: Text("An SMS will be sent in 10 seconds unless you cancel."),
          actions: [
            TextButton(
              child: Text("Cancel SMS"),
              onPressed: () {
                _smsCancelled = true; // Cancel the SMS
                Navigator.of(context).pop(); // Close the dialog
                print("Dialog closed by user.");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _shakeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/e.png'),
        ),
        title: Text('An Emergency', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.mail, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationsPage(notifications: _notifications),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
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
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSensorDataDisplay('X', _accelX),
                  _buildSensorDataDisplay('Y', _accelY),
                  _buildSensorDataDisplay('Z', _accelZ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Gyroscope Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSensorDataDisplay('X', _gyroX),
                  _buildSensorDataDisplay('Y', _gyroY),
                  _buildSensorDataDisplay('Z', _gyroZ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: _buildSensorGraph()),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                sendShakeSMS();
              },
              child: Text("Send SMS", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildSensorGraph() {
    return CustomPaint(
      painter: SensorGraphPainter(
          _accelX, _accelY, _accelZ, _gyroX, _gyroY, _gyroZ),
      child: Container(
        height: 300,
      ),
    );
  }
}

class SensorGraphPainter extends CustomPainter {
  final double accelX, accelY, accelZ;
  final double gyroX, gyroY, gyroZ;

  SensorGraphPainter(
      this.accelX, this.accelY, this.accelZ, this.gyroX, this.gyroY, this.gyroZ);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final midY = size.height / 2;
    final midX = size.width / 2;
    final sectionWidth = size.width / 3;

    final centerX = midX - (sectionWidth / 1);

    final accelPath = Path()
      ..moveTo(centerX, midY + accelX * 10)
      ..lineTo(centerX + sectionWidth, midY + accelY * 10)
      ..lineTo(centerX + 2 * sectionWidth, midY + accelZ * 10);
    paint.color = Colors.blue;
    canvas.drawPath(accelPath, paint);

    final gyroPath = Path()
      ..moveTo(centerX, midY - gyroX * 10)
      ..lineTo(centerX + sectionWidth, midY - gyroY * 10)
      ..lineTo(centerX + 2 * sectionWidth, midY - gyroZ * 10);
    paint.color = Colors.red;
    canvas.drawPath(gyroPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TwilioService {
  final String accountSid = 'AC0cc......2d5b6'; // Replace with yours ASid
  final String authToken = 'b04291.......0aac3be79'; // Replace with yours At
  final String twilioNumber = '+17....60'; // Replace with your TNumber

  Future<void> sendSMS(String toNumber, String message) async {
    final uri =
    Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
    final headers = {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'From': twilioNumber,
      'To': '+491556...2825', // replace with yours
      'Body': message,
    };

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      Get.snackbar(
        'Success',
        icon: Icon(Icons.location_on,color: Colors.white,),
        'SMS sent successfully!',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      print('✅ SMS sent successfully!');
    } else {
      Get.snackbar(
        'Failed',
        icon: Icon(Icons.location_on,color: Colors.red,),
        'Failed to send SMS: ${response.body}',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      print('❌ Failed to send SMS: ${response.body}');
    }
  }
}

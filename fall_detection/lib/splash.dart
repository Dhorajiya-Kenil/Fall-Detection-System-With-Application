import 'package:fall/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and set the duration of the animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Duration of the fade effect
    );

    // Define the fade animation from fully transparent (0.0) to fully opaque (1.0)
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation
    _controller.forward();

    // Navigate to the home screen after the animation ends
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => wel()), // Replace with your main screen
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // Set your desired background color here
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/emergency.png',height: 150,width: 150,),
              SizedBox(height: 20),// Replace with your splash image path
              Text(
                'An Emergency',
                style: TextStyle(
                  fontSize: 24, // Adjust the font size as needed
                  fontWeight: FontWeight.bold, // Adjust the font weight
                  color: Colors.white, // Text color, adjust based on your background
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

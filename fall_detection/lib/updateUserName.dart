

import 'package:fall/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Authentication/authService.dart';
import 'DashBoard/Dashboard.dart';

void main() => runApp(updateUserName());

class updateUserName extends StatefulWidget {
  const updateUserName({super.key});

  @override
  State<updateUserName> createState() => _updateUserName();
}

class _updateUserName extends State<updateUserName> {
  final _formKey = GlobalKey<FormState>(); // ✅ Correct form key
  TextEditingController controllerUserName = TextEditingController();

  @override
  void dispose() {
    controllerUserName.dispose();
    super.dispose();
  }

  void updateUserName() async {
    if (!_formKey.currentState!.validate()) {
      return; // ✅ Don't proceed if validation fails
    }
    try {
      await authService.value.updateUserName(
        userName: controllerUserName.text,
      );
      Get.offAllNamed('/profile');

      Get.snackbar(
        'Success',
        'UserName Reset successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something Went Wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Update User Name",style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );// Handle back button press
          },
        ),
      ),

      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/f_fall.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Main Content
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form( // ✅ Wrap inside Form
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //SizedBox(height: 00),
                    Text(
                      'Update User Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      "assets/images/updateUserName.png",
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 30),

                    // ✅ TextFormField with validation
                    TextFormField(
                      controller: controllerUserName,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.blue, // ✅ Keep cursor white
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'New User Name',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.person_outline_outlined,color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // ✅ No visible border
                        ),
                        // ✅ Prevent red border on error
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        // ✅ Customize error message text
                        errorStyle: TextStyle(
                          color: Colors.redAccent, // error text color
                          fontSize: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "User Name cannot be empty"; // ✅ Only message shows
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

                    // Update Button
                    ElevatedButton(
                      onPressed: updateUserName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

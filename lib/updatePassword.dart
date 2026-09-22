import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Authentication/authService.dart';
import 'DashBoard/Dashboard.dart';
import 'ProfilePage.dart';

void main() => runApp(MyApp());

class updatePassword extends StatefulWidget {
  const updatePassword({
    super.key,
    this.email, // 👈 now optional
  });
  final String? email; // 👈 nullable

  @override
  State<updatePassword> createState() => _updatePassword();
}


class _updatePassword extends State<updatePassword> {


  bool _isCurrentPasswordVisible = false;
  bool _isNewConfirmPasswordVisible = false;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCurrentPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  final FormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerNewPassword.dispose();
    controllerNewPassword.dispose();
    super.dispose();
  }

  void updatePassword() async{
    if (FormKey.currentState!.validate()) {
      try {
        await authService.value.resetPasswordFromCurrentPassword(
            currentPassword: controllerCurrentPassword.text,
            newPassword: controllerNewPassword.text,
            email: controllerEmail.text
        );

        Get.offAllNamed('/home');

        Get.snackbar(
          'Success',
          'Password Reset successfully',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
      catch (e) {
        Get.snackbar(
          'Error',
          'Something Went Wrong',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Reset Password",style: TextStyle(color: Colors.white),),
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
                image: AssetImage("assets/images/f_fall.jpg"), // Your background image
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
          // forgot Password
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: FormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Text(
                      'Restet Your Password',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Please Enter Your Registered \n Email Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Email Field
                    TextFormField(
                      controller: controllerEmail,
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter email" : null,
                    ),

                    SizedBox(height: 20),
                    // Email Field
                    TextFormField(
                      controller: controllerCurrentPassword,
                      obscureText: !_isCurrentPasswordVisible,// This hides the password
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Current Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter Current Password" : null,
                    ),

                    SizedBox(height: 20),
                    // Email Field
                    TextFormField(
                      controller: controllerNewPassword,
                      obscureText: !_isNewConfirmPasswordVisible, // This hides the password
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'New Password',
                        prefixIcon: Icon(Icons.admin_panel_settings_sharp, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewConfirmPasswordVisible = !_isNewConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter New Password" : null,
                    ),

                    SizedBox(height: 30),
                    // Continue Button
                    ElevatedButton(
                      onPressed: () {
                        updatePassword();
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage(),));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Continue', style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:fall/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Authentication/authService.dart';
import 'SignupPage.dart';

class deleteAccount extends StatefulWidget {
  const deleteAccount({super.key});

  @override
  _deleteAccountState createState() => _deleteAccountState();

}

class _deleteAccountState extends State<deleteAccount>{

  bool _isPasswordVisible = false;
  //bool _isConfirmPasswordVisible = false;

  TextEditingController emailController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void delete() async {
    if (!formKey.currentState!.validate()) {
      return; // ✅ Don't proceed if validation fails
    }
    try {
      await authService.value.deleteAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // If no error, then account was deleted
      Get.snackbar(
        'Success',
        'Account deleted successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

      // Navigate after showing snackbar
      Get.offAllNamed('/signup');

    } catch (e) {
      // If deleteAccount throws error (wrong email/pass, network issue, etc.)
      Get.snackbar(
        'Error',
        'This Email and Password do not exist',
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
        title: Text("Delete Account",style: TextStyle(color: Colors.white),),
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
                image: AssetImage("assets/images/fall_bg.jpg"), // Your background image
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
          // Signup Form
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form( // ✅ Wrap inside Form
              key: formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    Text(
                      'Delete My Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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

                    SizedBox(height: 20),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email,color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter Email"; // ✅ Only message shows
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible, // This hides the password
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock,color: Colors.white,),
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter password"; // ✅ Only message shows
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    // Signup Button


                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        delete();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Delete', style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),
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

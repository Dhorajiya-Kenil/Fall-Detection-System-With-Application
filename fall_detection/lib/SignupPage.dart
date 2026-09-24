import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall/splash.dart';
import 'package:fall/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Forgotpass.dart';
import 'LoginPage.dart';
import 'FallDetected.dart'; // ✅ Import home page
import 'package:firebase_core/firebase_core.dart';

/// ------------------------
/// User Model
/// ------------------------
class UserModel{
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNo,
  });

  toJson(){
    return{
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password,
    };
  }

  /// Fetched Data From Firebase to UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      fullName: data["FullName"],
      phoneNo: data["Phone"],);
  }
}

/// ------------------------
/// User Repository
/// ------------------------
class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db =  FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).whenComplete(() =>
        Get.snackbar(
          'Success',
          'Your Account created successfully',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        ),
    ).catchError((error, stackTrace){
      Get.snackbar(
        'Error',
        'Something Went Wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(error.toString());
    });
  }

  /// Fetch All Users And Details
  Future<UserModel?> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();

    if (snapshot.docs.isEmpty) return null; // No user found

    if (snapshot.docs.length > 1) {
      debugPrint("Warning: multiple users found with the same email");
    }

    final doc = snapshot.docs.first;
    return UserModel.fromSnapshot(doc);
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }







  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }







  Future<void> updateUser(UserModel user) async {
    if (user.id == null) {
      Get.snackbar('Error', 'User ID is null, cannot update',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      await _db.collection("Users").doc(user.id).update(user.toJson());
      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.blue, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Error', 'Failed to update profile',
          backgroundColor: Colors.red, colorText: Colors.white);
      print(error.toString());
    }
  }
}

/// ------------------------
/// Authentication Repository
/// ------------------------
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => SplashScreen())
        : Get.offAll(() => SensorHomePage());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('FIREBASE - ${ex.message}');
      throw ex;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}

/// ------------------------
/// SignUp Error Handler
/// ------------------------
class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message = "An Unknown Error Occurred"]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure(
            'Please enter a strong password');
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure('Email is not valid');
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure('Account already exists');
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure('Operation not allowed');
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure('This user is disabled');
      default:
        return SignUpWithEmailAndPasswordFailure();
    }
  }
}

/// ------------------------
/// SignUp Controller
/// ------------------------
class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  var isPasswordVisible = false.obs;

  final userRepo = Get.put(UserRepository());
  final authRepo = Get.put(AuthenticationRepository());

  void registerUser(String email, String password) async {
    try {
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);

      Get.offAllNamed('/home');

      Get.snackbar(
        'Success',
        'Login successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'This Email Account Already Existed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
    registerUser(user.email, user.password);
  }

  getUserdata(){
    final email = authRepo.firebaseUser.value?.email;
    if(email != null){
      return userRepo.getUserDetails(email);
    } else{
      Get.snackbar("Error", "Login To Continue");
    }
  }
}

/// ------------------------
/// Signup Page
/// ------------------------
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late SignUpController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SignUpController());
    if (!Get.isRegistered<AuthenticationRepository>()) {
      Get.put(AuthenticationRepository());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fall_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Form
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'An Emergency',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Signup',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // Full Name
                    TextFormField(
                      controller: controller.fullName,
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Full Name',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter full name" : null,
                    ),
                    SizedBox(height: 16),
                    // Email
                    TextFormField(
                      controller: controller.email,
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter email" : null,
                    ),
                    SizedBox(height: 16),
                    // Phone Number
                    TextFormField(
                      controller: controller.phoneNo,
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter phone number" : null,
                    ),
                    SizedBox(height: 16),
                    // Password
                    Obx(() => TextFormField(
                      controller: controller.password,
                      cursorColor: Colors.blue,
                      obscureText: !controller.isPasswordVisible.value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.3),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller.isPasswordVisible.value =
                            !controller.isPasswordVisible.value;
                          },
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter password" : null,
                    ),
                    ),
                    SizedBox(height: 16),
                    // Signup Button
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final user = UserModel(
                            email: controller.email.text.trim(),
                            password: controller.password.text.trim(),
                            fullName: controller.fullName.text.trim(),
                            phoneNo: controller.phoneNo.text.trim(),
                          );
                          SignUpController.instance.createUser(user);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Already have account
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.white),
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

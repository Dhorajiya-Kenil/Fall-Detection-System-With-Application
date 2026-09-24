import 'package:fall/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Authentication/authService.dart';
import 'SignupPage.dart';

void main() {
  runApp(editProfile());
}

class editProfile extends StatefulWidget {
  const editProfile({super.key});
  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  late ProfileController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    if (!Get.isRegistered<AuthenticationRepository>()) {
      Get.put(AuthenticationRepository());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: controller.getUserdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;

                  final email = TextEditingController(text: userData.email);
                  final password =
                  TextEditingController(text: userData.password);
                  final fullName =
                  TextEditingController(text: userData.fullName);
                  final phoneNo =
                  TextEditingController(text: userData.phoneNo);

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                          "assets/images/KenilAi.jpeg"),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: Handle edit image
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),

                                TextFormField(
                                  readOnly: true,
                                  controller: email,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.withOpacity(0.7),
                                    hintText: 'Email',
                                    hintStyle:
                                    TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    Icon(Icons.email, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) =>
                                  value!.isEmpty ? "Enter email" : null,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: fullName,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.withOpacity(0.3),
                                    hintText: 'Full Name',
                                    hintStyle:
                                    TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    Icon(Icons.person, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) =>
                                  value!.isEmpty ? "Enter full name" : null,
                                ),

                                SizedBox(height: 16),
                                TextFormField(
                                  controller: phoneNo,
                                  cursorColor: Colors.blue,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.withOpacity(0.3),
                                    hintText: 'Phone Number',
                                    hintStyle:
                                    TextStyle(color: Colors.white70),
                                    prefixIcon:
                                    Icon(Icons.phone, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter phone number"
                                      : null,
                                ),


                                SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () async {
                                    final updatedUser = UserModel(
                                      id: userData.id, // ✅ keep id
                                      email: email.text.trim(),
                                      password: password.text.trim(),
                                      fullName: fullName.text.trim(),
                                      phoneNo: phoneNo.text.trim(),
                                    );

                                    await controller
                                        .updateRecord(updatedUser);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]);
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Something Went Wrong"));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

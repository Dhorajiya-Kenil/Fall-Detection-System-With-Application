import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FallDetected.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, String>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // Load contacts from SharedPreferences and populate AnimatedList
  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedContacts = prefs.getStringList('contacts');
    if (storedContacts != null) {
      List<Map<String, String>> loadedContacts = storedContacts
          .map((e) => Map<String, String>.from(json.decode(e)))
          .toList();

      for (int i = 0; i < loadedContacts.length; i++) {
        _contacts.add(loadedContacts[i]);
        _listKey.currentState?.insertItem(i, duration: Duration(milliseconds: 300));
      }
    }
  }

  // Save contacts to SharedPreferences
  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactStrings =
    _contacts.map((c) => json.encode(c)).toList();
    await prefs.setStringList('contacts', contactStrings);
  }

  // Pick a contact manually
  Future<void> _pickContact() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null) {
        String phoneNumber =
        contact.phones!.isNotEmpty ? contact.phones!.first.value! : "";

        bool isDuplicate = _contacts.any((c) => c['phone'] == phoneNumber);

        if (!isDuplicate) {
          setState(() {
            _contacts.add({
              "name": contact.displayName ?? "",
              "phone": phoneNumber
            });
          });
          _listKey.currentState?.insertItem(_contacts.length - 1, duration: Duration(milliseconds: 300));
          _saveContacts();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${contact.displayName} is already added!")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contacts permission is required")),
      );
    }
  }

  // Delete a contact with animation
  void _deleteContact(int index) {
    final removedContact = _contacts[index];
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildItem(removedContact, animation, index),
      duration: Duration(milliseconds: 300),
    );
    setState(() {
      _contacts.removeAt(index);
    });
    _saveContacts();
  }

  // Show confirmation dialog before deleting
  void _confirmDeleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: Text('Delete Contact', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete ${_contacts[index]['name']}?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteContact(index);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog before sending location
  void _confirmSendLocation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: Text('Send Location', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text('Do you want to send your location to ${_contacts[index]['name']}?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add code to send SMS with location here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location sent to ${_contacts[index]['name']}')),
              );
            },
            child: Text('Confirm', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  // Build each animated contact item
  Widget _buildItem(Map<String, String> contact, Animation<double> animation, int index) {
    final color = Colors.primaries[index % Colors.primaries.length].shade200;
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] ?? "",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  contact['phone'] ?? "",
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.location_on, color: Colors.blue),
                  onPressed: () => _confirmSendLocation(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteContact(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Contacts', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SensorHomePage()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _pickContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Add Contacts",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _contacts.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_contacts[index], animation, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}




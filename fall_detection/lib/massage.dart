
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TwilioService {
  final String accountSid = 'AC76cd971ab......8d392047a8';
  final String authToken = '95ba089...a327e17d36125c';
  final String twilioNumber = '+17...44582';

  Future<void> sendSMS(String toNumber, String message) async {
    final uri = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
    final headers = {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'From': twilioNumber,
      'To': toNumber,
      'Body': message,
    };
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('SMS sent successfully!');
    } else {
      print('Failed to send SMS: ${response.body}');
    }
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SMSPage(),
    );
  }
}

class SMSPage extends StatefulWidget {
  @override
  _SMSPageState createState() => _SMSPageState();
}

class _SMSPageState extends State<SMSPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TwilioService _twilioService = TwilioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).dialogBackgroundColor,
      appBar: AppBar(title: Text('Twilio SMS',style: TextStyle(color: Colors.white)),backgroundColor: Colors.black,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
              // maxLines: 4,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final phoneNumber = _phoneNumberController.text;
                final message = _messageController.text;

                if (phoneNumber.isNotEmpty && message.isNotEmpty) {
                  _twilioService.sendSMS(phoneNumber, message);
                }
              },
              child: Text('Send SMS',style: Theme.of(context).textTheme.headlineMedium,),//
            ),
          ],
        ),
      ),
    );
  }
}

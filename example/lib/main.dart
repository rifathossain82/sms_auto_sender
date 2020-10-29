import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sms_auto_sender/sms_auto_sender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _canSendSMS;
  bool _hasPermission;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool canSendSMS;
    bool hasPermission;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SmsAutoSender.platformVersion;
      canSendSMS = await SmsAutoSender.canSendSMS();
      hasPermission = await SmsAutoSender.hasPermissionToSendSMS();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _canSendSMS = canSendSMS;
      _platformVersion = platformVersion;
      _hasPermission = hasPermission;
    });
  }

  void sendMessage(context) async{
    String message = "Ciao da Android";
    var recipients = ["3773053631"];

    final bool res = await SmsAutoSender.sendSMS(message: message, recipients: recipients);
    showAlert(context, res ? "Message Sent" : "Sending messsage failed");
  }


  showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /**
   * Request permission
   */
  void requestPermission(BuildContext context) async{
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      final bool res = await SmsAutoSender.requestPermissionToSendSMS();
    }
  }

  /**
   * Check if the permission has been granted or not...
   */
  Future<bool> checkPermission() async{
    // Aggiorna lo stato
    final bool hasPermission = await SmsAutoSender.hasPermissionToSendSMS();
    setState(() {
      _hasPermission = hasPermission;
    });
    return hasPermission;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Auto Sender Plugin Tester'),
        ),
        body: Builder(builder: (context) => Center(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            Text('Device can send SMS: $_canSendSMS\n'),
            Text('Has permission: $_hasPermission\n'),
            FlatButton(
              onPressed: () {
                requestPermission(context);
              },
              child: Text(
                "Request permission",
              )),
            FlatButton(
              onPressed: () {
               sendMessage(context);
              },
              child: Text(
                "Send",
              ),
            )],
        )),
      ),
      ),
    );
  }
}

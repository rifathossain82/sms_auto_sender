# SMS Auto Sender for Flutter

This project is a Flutter plugin to send SMS from a flutter app without user interaction.

## Beware

This plugin is **Android only** and the functionality is **forbidden** to apps published in the *Google Play Store* .

The miminum *API version* supported by this plugin is *23*.


## Getting Started
Add the sms_auto_sender plugin to your pub file.

In your ApplicationManifest.xml add the SendSMS permission:

<pre> 
 < uses-permission android:name="android.permission.SEND_SMS"/ > 
</pre> 

In your class import the plugin class:
<pre>
import 'package:sms_auto_sender/sms_auto_sender.dart';
</pre>

Before using the plugin check if the SMS sending functionality is available:
<pre>
    canSendSMS = SmsAutoSender.canSendSMS(); // return a Future<bool>
</pre>

Before using the plugin check if the SMS sending permission has been given:
<pre>
    canSendSMS = SmsAutoSender.hasPermissionToSendSMS(); // return a Future<bool>
</pre>

If the SendSMS Permission has not be granted request it:
<pre>
    SmsAutoSender.requestPermissionToSendSMS();
</pre>


Now you can send an SMS by using calling the sendSMS method:
<pre>
   void sendMessage(context) async{
     String message = "Hello from Android";
     var recipients = ["123456778"];

     final bool res = await SmsAutoSender.sendSMS(message: message, recipients: recipients);
     showAlert(context, res ? "Message Sent" : "Sending messsage failed");
   }
</pre>



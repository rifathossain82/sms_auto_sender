import 'dart:async';

import 'package:flutter/services.dart';

class SmsAutoSender {
  static const MethodChannel _channel = const MethodChannel('sms_auto_sender');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /**
   * Check if it's possible to send SMS
   */
  static Future<bool?> canSendSMS() {
    return _channel.invokeMethod<bool>('canSendSMS');
  }

  /**
   * Send the sms message to the recipients' list
   */
  static Future<bool> sendSMS({required String message, required List<String> recipients}) async {
    var mapData = Map<dynamic, dynamic>();
    mapData["message"] = message;
    mapData["recipients"] = recipients.join(",");
    final bool res = await _channel.invokeMethod('sendSMS', mapData);
    return res;
  }

  /**
   * Check if the app the permission to send SMS
   */
  static Future<bool> hasPermissionToSendSMS() async {
    final bool res = await _channel.invokeMethod('hasPermissionToSendSMS');
    return res;
  }

  /**
   * Request permission to send SMS
   */
  static Future<bool> requestPermissionToSendSMS() async {
    final bool res = await _channel.invokeMethod('requestPermissionToSendSMS');
    return res;
  }
}

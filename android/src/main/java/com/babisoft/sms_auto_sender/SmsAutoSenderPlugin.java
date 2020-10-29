package com.babisoft.sms_auto_sender;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;

import androidx.annotation.NonNull;

import java.util.List;
import java.util.Map;
import android.os.Process;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

/** SmsAutoSenderPlugin */
public class SmsAutoSenderPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sms_auto_sender");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("canSendSMS")) {
      result.success(canSendSMS());
    } else if (call.method.equals("hasPermissionToSendSMS")) {
      result.success(hasPermissionToSendSMS());
    } else if (call.method.equals("requestPermissionToSendSMS")) {
      result.success(requestPermissionToSendSMS((String)call.arguments));
    }

   else if (call.method.equals("sendSMS")) {
    result.success(sendSms((Map)call.arguments));
  }
  else
    {
      result.notImplemented();
    }
  }

  private Boolean requestPermissionToSendSMS(String requestPermissionMessage) {
    final String permission = Manifest.permission.SEND_SMS;
    if (PackageManager.PERMISSION_GRANTED != activity.checkSelfPermission(permission)) {
        activity.requestPermissions(new String[] {permission}, 0);
        return true;
    } else {
      return false;
    }
  }

  public void onRequestPermissionsResult(int requestCode, String[] permissions,
                                         int[] grantResults) {
    System.out.println("REREREREREREAREAREREAREAREARAE");
  }


  //Send message
  private Boolean sendSms(Map arguments) {
    try {
      String message = (String) arguments.get("message");
      String recipients = (String) arguments.get("recipients");
      SmsManager smgr = SmsManager.getDefault();
      smgr.sendTextMessage( recipients,null,message,null,null);

      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  /**
   * Check if the current device can send SMS
   * @return
   */
  private Boolean canSendSMS(){
    PackageManager pm = context.getPackageManager();
    return pm.hasSystemFeature(PackageManager.FEATURE_TELEPHONY);
  }

  /**
   * Check if we have SMS permission
   */
  private Boolean hasPermissionToSendSMS(){
    return context.checkPermission(Manifest.permission.SEND_SMS, Process.myPid(), Process.myUid())
            == PackageManager.PERMISSION_GRANTED;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}

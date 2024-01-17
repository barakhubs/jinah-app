import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../app/modules/auth/controllers/auth_controller.dart';

class DeviceToken {
  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';

    try {
      OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
        deviceToken = changes.to.userId;
        print('Player ID: ' + deviceToken.toString());

        // You can call your function to handle the obtained player ID here if needed
        handlePlayerID(deviceToken);
      });

      // Initialize OneSignal
      await OneSignal.shared.setAppId("41a5fc47-4587-4084-9e84-7478c145e477");

      // Optional: Enable logging to help debug issues
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      // Check for an existing player ID
      var status = await OneSignal.shared.getDeviceState();
      deviceToken = status?.userId;
      print('Player ID (existing): ' + deviceToken.toString());
    } catch (e) {
      print(e.toString());
    }

    if (deviceToken != null) {
      debugPrint('--------Device Token---------- ' + deviceToken.toString());

      // You can also call your function to handle the obtained player ID here if needed
      handlePlayerID(deviceToken);

      // Assuming you have an AuthController in GetX for posting the device token
      Get.find<AuthController>().postDeviceToken(deviceToken);
    }

    return deviceToken;
  }

  void handlePlayerID(String? playerId) {
    // Add your logic to handle the obtained player ID here if needed
    // For example, you might want to store it locally or perform additional actions.
  }
}

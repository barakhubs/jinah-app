// ignore_for_file: unused_local_variable
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/model/body/notification_body.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/routes/app_pages.dart';
import 'helper/notification_helper.dart';
import 'translation/language.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  final box = GetStorage();
  NotificationBody? body;
  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

    // Initialize OneSignal
    await OneSignal.shared.setAppId("41a5fc47-4587-4084-9e84-7478c145e477");

    // Handle notification received from Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification received from Firebase: ${message.data}");
      // Handle Firebase notification
    });

    // Handle notification received from OneSignal while app is in the foreground
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print(
          "Received notification in the foreground: ${event.notification.body}");
      // You can decide how to handle the notification here
      event.complete(event.notification);
    });

// Handle notification opened event (user tapped on the notification)
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("Notification opened: ${result.notification.body}");
      // Handle the notification opened event here
    });
  } catch (e) {
    debugPrint(e.toString());
  }

  dynamic langValue = const Locale('en', null);
  if (box.read('languageCode') != null) {
    langValue = Locale(box.read('languageCode'), null);
  } else {
    langValue = const Locale('en', null);
  }
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: ((context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Jinah Foods",
            translations: Languages(),
            locale: langValue,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            initialBinding: SplashBinding(),
          )),
    ),
  );
}
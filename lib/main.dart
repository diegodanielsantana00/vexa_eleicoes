import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vexa_eleicoes/Views/await_screen.dart';
import 'dart:core';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Teste ;as
  _configureLocalTimeZone();
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS =
      IOSInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true, onDidReceiveLocalNotification: (id, title, body, payload) async {});
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  MobileAds.instance.initialize();

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AwaitScreen()));
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

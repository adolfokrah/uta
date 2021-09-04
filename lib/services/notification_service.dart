import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class NotificationService{
  var flutterLocalNotificationsPlugin;


  init()async{

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: selectNotification);
  }

  Future selectNotification(String? json)async{
    final obj = jsonDecode(json!);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {

    }
  }

  Future<void> showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        priority: Priority.high,
        importance: Importance.max
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android:android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json
    );
  }
}
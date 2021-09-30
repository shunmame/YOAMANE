import 'yoamane_libraries.dart';

Future<void> notice() async {
  final localNotification = FlutterLocalNotificationsPlugin();
  return localNotification
      .initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap-mdpi/ic_launcher'),
        ),
      )
      .then(
        (_) => localNotification.show(
          0,
          'title',
          'body',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              'channel_description',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        ),
      );
}

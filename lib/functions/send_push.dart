import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizzadym_deliveryman/db/db.dart';

class PushNotifications {
  final String message;
  final String token;
  final String title;

  PushNotifications({
    required this.title,
    required this.message,
    required this.token,
  });

  Future<http.Response> sendPush() {
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "key=${GlobalData.fcmServerKey}"
      },
      body: jsonEncode(
        {
          "to": token,
          "priority": "high",
          "notification": {
            "title": title,
            "body": message,
            "mutable_content": true,
            "badge": '1',
            "sound": '1',
          },
        },
      ),
    );
  }
}

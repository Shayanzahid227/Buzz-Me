import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static const String _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send';
  static const String _scope =
      'https://www.googleapis.com/auth/firebase.messaging';
  AccessToken? _accessToken;

  Future<String> _getAccessToken() async {
    if (_accessToken?.hasExpired == false) {
      return _accessToken!.data;
    }

    try {
      // Load service account json
      final serviceAccount =
          await rootBundle.loadString('assets/service-account.json');
      final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

      // Get the access token
      final client = await clientViaServiceAccount(credentials, [_scope]);
      _accessToken = client.credentials.accessToken;
      return _accessToken!.data;
    } catch (e) {
      throw Exception('Failed to get access token: $e');
    }
  }

  // Send call notification
  Future<bool> sendCallNotification({
    required String recipientToken,
    required String callerName,
    required String callerId,
    required String callType,
    required String callId,
  }) async {
    try {
      final token = await _getAccessToken();

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': {
            'token': recipientToken,
            'data': {
              'type': 'call',
              'callType': callType,
              'callerName': callerName,
              'callerId': callerId,
              'callId': callId,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            },
            'android': {
              'priority': 'high',
              'notification': {
                'channelId': 'calls',
                'priority': 'high',
                'defaultSound': true,
                'defaultVibrateTimings': true,
              },
            },
            'apns': {
              'headers': {
                'apns-priority': '10',
                'apns-push-type': 'background',
              },
              'payload': {
                'aps': {
                  'content-available': 1,
                  'sound': 'default',
                  'category': 'call',
                  'priority': 10,
                },
              },
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      print('FCM Error: ${response.body}');
      return false;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }

  // Send call ended notification
  Future<bool> sendCallEndedNotification({
    required String recipientToken,
    required String callId,
  }) async {
    try {
      final token = await _getAccessToken();

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': {
            'token': recipientToken,
            'data': {
              'type': 'call_ended',
              'callId': callId,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      print('FCM Error: ${response.body}');
      return false;
    } catch (e) {
      print('Error sending call ended notification: $e');
      return false;
    }
  }

  // Send call rejected notification
  Future<bool> sendCallRejectedNotification({
    required String recipientToken,
    required String callId,
  }) async {
    try {
      final token = await _getAccessToken();

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': {
            'token': recipientToken,
            'data': {
              'type': 'call_rejected',
              'callId': callId,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      print('FCM Error: ${response.body}');
      return false;
    } catch (e) {
      print('Error sending call rejected notification: $e');
      return false;
    }
  }
}

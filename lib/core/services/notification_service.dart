import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  static const String _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/buzz-me-a3d75/messages:send';

  Future<String> _getAccessToken() async {
    try {
      final accountCredentials = ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "buzz-me-a3d75",
          "private_key_id": "8e255172c8c9462370654eaf225a2e459c414ce7",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCpAs9LMBRQNQqi\nAcyKfJTBZNpzN1iFoaRiZJYCOis6ngsC2wyrZrrc9XhQ72aA4WP/b33ihGtMgYgH\nvID9xMOsNc4y7lTZStZPUG7VaFSUipd6wIZcaGtQGQyQKIaovsBZXrtb48oixtz/\nanyvhjfN9pvcoMtixiKKZCWvyqcToxt490qqmzIDGu0tTehFrYMkPDlb8xlxQeXh\nyW/eSAcGZHQUJf+JHenek8R2/unHDOgeHG33WfRvB/bSB8FNbjSDbI8+dakeyhPP\ngNRqH71SkXRcV0tY3dwNcTNeiBJQCkdFj61phYhGh5GaDfJaoKYfhvmLgfAfhjYv\nxc1ck5e5AgMBAAECggEABT7TFDBP0RV0WQbZREsNitsIdJ75Hlyf73XTugn4IX+a\nM+J8iC1OC2GK9GgZtFJKejkJnSgi9GLox+Sv1DBxKj0ZQzdmZsAN2rRSXEk6psmO\nXf7vrJqJChlc7HR1iXMyIRPxmK5/LYkifsLdT81ImhnXSIetCEnB9K2bBdOyT8ep\nPmjhprqYAUipnEeFBHHMnKKfkAa403x9Kypz+AzxHLppvZRX9xreFj59YWk/W4Cd\nQli3i/OutQhK1JSP1hs+4Byla2TG54hmXnx41i1aCWJziFkiqp36WxLw3hAib2Dd\nVf5tSK+vyZAcIlo4wdvwtdfVydIRmKLLIKrmiengCQKBgQDUxuBR86B2qKG5hHhB\niCDyC+gatDw0u1m02wP32kjFACUWufuK2lZwf+ZwJPc5SJl/wUK2eiejOsjMsr1M\ne0JWvJdzbD/+E9oIkSx7vjCIJjfhT5XF3tISsuD5wXndr5yJFhLczxPnRZCQR6rK\nsn9S60tKx0nXcOA/lADRw/NvwwKBgQDLV/U7uLXrco37aEB4LTXXhavyBNC2npVK\n/0Rx6TM3vtGOL928/vkqMIoivnFQvuUW75tNrqF+rPJoL/sconW/pqwjHbN9saoT\n8TJzBUWFYSZcEvcCnPRBClpdO0MBFdGWDcltyeWc0ad/4RF1LTPhdBn/nLeKXw40\nmYAceBn+0wKBgQDSchzdkTuNAL5r0XRrRCtpmpMnDkpZ0U8pTFFBa9j7V2hXcP00\nWTyTKj0Nf9IxCvge3lOQTYM0s2h05PfLVEHJrd+RXmhwcMv+Gy/G99XiYwJzyxYU\nTYyyx88x1sUkmJMXFwjy8bD61dfki62Fq0O5DFU8kZ0cA10YJNcmoUr9pwKBgH7i\n2Q02Opa8OeraZ/hVxdZB/ESeSpraJDDTTyOBsEsl0F/YcJZhyJtSBLCfg9gt9og0\nZgW4Zd/FDdKDtj9tBOrdl2amPv29InMlPCTX8kTDlYs47lf8FtKLIk4xD6OauNjY\nq4vNw3DyxoGesSUcWtZhe2OsqD85B4U9D9sz+oyvAoGATYaorpgdq/Mo+ZIDNONc\nDHzbiZ8WKz4IEK8c8wjAPhgZLQtQCCA9z0Xaru2m1qki58NPquFxu72XZrGPxXS6\n4LM6p/Z1BnWQTRddVZ7etKCF/GGv8GYs8bMI2Rpa9G2v2P6FsxYKjmgmHBp01RWe\nGWvNbH0vlEYe2o81ccDHUt8=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@buzz-me-a3d75.iam.gserviceaccount.com",
          "client_id": "101059376418645324849",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40buzz-me-a3d75.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        },
      );
      var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      AuthClient client =
          await clientViaServiceAccount(accountCredentials, scopes);

      log('accesstoken ' + client.credentials.accessToken.data);

      return client.credentials.accessToken.data;
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
                'channelId': 'Incoming Calls',
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

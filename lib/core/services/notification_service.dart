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
          "private_key_id": "82cdb8505fef9da67c58b3992a9a3ab11dbfa269",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCuqqABNiaHj5U7\nCsbnSrdrOPooZoHy1kvCtTXwwVIvoeV0DjSL4v45skUS0pKoFYOnJx06RZe/552B\nsMuvr1LU/DpEkMNT9Q7ll9WAUhm1mtcE9q/iEKUJu7pNehVMRU4/MLCih43ugQxh\nF5OskrrXEwpc56a88wBV3cTQz/lV6bcAG2tN/WLk9zUA5ykuqERsi+ipkkhPzU0e\nUZpi8zKKGWqdja/tnQaKOnhr9xjFQ7YeGmDy/fhDUTMk+64LBss7TxviMoqz7QlT\nPo//F6UDZFba0XR/FJBm8OpijT6o/k8SsFy6mTkcZp47eKFSu2NWuiDpx1N9IL/0\nQKns97yZAgMBAAECggEASLpqKmb6Txrlt/JqVNdjHUXZv+XC+TLq09WxcqCEkKnY\nSWU60v5+/dYxdb9xaoSez4R1YpSktbcC+gP8JBicJGwr9O3UL0rMW6RHtYk6BEjH\nfF0dakOk/LMKxYTuhlYbWSt0eRB5dFSOq4TuK/7ixng6qemZH3cNbjOL5qiaeP9I\nyo8gJ72RQ5u/R50RycbtYTLH8byDRRVgjTYgFRpu323/4VXN/hSR27sNoio/4emK\n5xfgNvA/DRF4IudooeG6bPSO06fZQ+sRGAPkoELjI5XPanv5ZTCe5kE25+O1fMP7\n5p/Jzm8Kp2tDZpCsUxLDYs2oQHzHTDgddGvJIDN1kwKBgQDyEapMxBEWJx3oG4tc\nM/N0R/nvXj5nGHPFiKFE3wrJCTvxc67GEzi/S0jpbkvcEPLEZY632fbj1j7RLOip\n/Ku+7B1NpH15eQpsRVdDaaiOOnXR65PI+W4cBbEf+Ln/DCWuYSCk5ItAPXZwv1NY\nrSvoaHvUs/5aA8ZoY/ifJ5GpcwKBgQC4t/AJPWq8Q57bNe5I9pcx7B8smZ+3t6ag\nypG3Mf7S+lur6bXxSe8gPZRWo/KjJpNiR8owNUjJPemAg/sis62KBV1FXeIgSzXL\n/hnW2jZe9uQRjUhzP0WhRmTxjj35r2XbJag8lCEb62bmIzTCWOVpqfFckwZhpeaJ\n0sEvsOsuwwKBgAgl7BOVbfXO70TG2JQL85/wZEtYYsVZn1wA01zcHSLTOr9P44wr\nTXey8wtYeRk5QNK3kGxD2/mjVo338wT1ylos3Heml8qk9mLamqtcPR48fYbJZToY\nm0o6LtIirzAUmpgaEN08DCvnZbs51XZgrd+u1Kw+OsuQ4PbWlqHU1SRdAoGABwpr\nyc5ffSGOsohRttI/XRXE8mxAnD4Rydsuxq7PKbeFOv5DgxjwVmhCeTLykqlrwLk/\nyaqeRZ1ogw+EyQPUP4iIz5YOgnCbclUTIw9aNzBt7QVXl5z3yHfobRSg5B19YmcD\nDJwQzwGgAHGjFy1QQUDLBF5ORfaO3P39gxXZQQUCgYBZUL3oNPg+mSvv7oR38oSj\n52nrv9paa66TgQecBbS/Aohg/FoWiXUevT38hs9dEpyBy7E2HyDvpzmNFOc/k5dN\nAvGIlE499eHedIlBEx1RhrZIYZb3rKt8IivSwJvx95nJpC85hmb6m/nLhoGfJNx2\n0DGBjkrsDENIExMqev58vg==\n-----END PRIVATE KEY-----\n",
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

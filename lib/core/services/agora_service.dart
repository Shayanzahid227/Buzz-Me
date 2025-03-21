import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static const String appId = "3c7b549ae83a4ac98b285578e3648f80";
  static const String serverUrl =
      "YOUR_TOKEN_SERVER_URL"; // Replace with your token server URL

  Future<String> generateToken(String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/rtc/$channelName/publisher/uid/0'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      }
      throw Exception('Failed to generate token');
    } catch (e) {
      // For development/testing, return a temporary token
      // In production, always use a token server
      return "007eJxTYLhj+dVpzU3fhVtPzb7hMifnEevyfvX7e6/wbzdovaJok/1FgcE42TzJ1MQyMdXCONEkMdnSIsnIwtTU3CLV2MzEIs3CQL/tVnpDICPDhqw8JkYGCATx2RiSSquqclMZGABHCSJB";
    }
  }

  Future<void> initializeEngine() async {
    final engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
  }
}

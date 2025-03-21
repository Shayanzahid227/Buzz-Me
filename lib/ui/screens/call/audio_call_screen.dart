import 'package:code_structure/core/services/agora_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/models/call.dart';
import 'package:code_structure/core/services/call_service.dart';
import 'package:provider/provider.dart';

class AudioCallScreen extends StatefulWidget {
  final Call call;

  const AudioCallScreen({
    super.key,
    required this.call,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  RtcEngine? engine;
  bool isMuted = false;
  bool isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    // Request microphone permission
    await Permission.microphone.request();

    // Create RTC engine instance
    engine = createAgoraRtcEngine();
    await engine!.initialize(RtcEngineContext(
      appId: AgoraService.appId,
    ));

    // Set event handlers
    engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint("Successfully joined channel ${connection.channelId}");
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint("Remote user joined: $remoteUid");
      },
      onUserOffline: (connection, remoteUid, reason) {
        debugPrint("Remote user left: $remoteUid");
        // End call if remote user left
        _handleCallEnd();
      },
    ));

    // Join the channel
    await engine!.joinChannel(
      token: widget.call.token,
      channelId: widget.call.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }

  void _handleCallEnd() {
    // context.read<CallService>().endCurrentCall();
    Navigator.pop(context);
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      engine?.muteLocalAudioStream(isMuted);
    });
  }

  void _toggleSpeaker() {
    setState(() {
      isSpeakerOn = !isSpeakerOn;
      engine?.setEnableSpeakerphone(isSpeakerOn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(
              widget.call.receiverName,
              style: style17.copyWith(
                color: headingColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Ongoing call',
              style: style14.copyWith(
                color: subheadingColor2,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100.r,
                    backgroundImage: AssetImage(widget.call.receiverName),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),

            // Bottom section with call controls
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCallControlButton(
                    icon: isMuted ? Icons.mic : Icons.mic_off,
                    color: PrimarybuttonColor,
                    onPressed: _toggleMute,
                  ),
                  _buildCallControlButton(
                    icon: isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    color: PrimarybuttonColor,
                    onPressed: _toggleSpeaker,
                  ),
                  _buildCallControlButton(
                    icon: Icons.call_end,
                    color: SecondarybuttonColor,
                    onPressed: _handleCallEnd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: whiteColor,
          size: 30.sp,
        ),
      ),
    );
  }

  @override
  void dispose() {
    engine?.leaveChannel();
    engine?.release();
    super.dispose();
  }
}

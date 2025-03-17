import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallScreen extends StatefulWidget {
  final String userName;
  final String profileImage;

  const AudioCallScreen({
    super.key,
    required this.userName,
    required this.profileImage,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  RtcEngine? engine;
  bool isMuted = false;
  bool isSpeakerOn = false;

  // Replace with your Agora App ID
  final String appId = "3c7b549ae83a4ac98b285578e3648f80";
  // Replace with your channel name
  final String channelName = "buzzme";
  // Replace with your temp token from Agora Console
  final String token =
      "007eJxTYHjbvGZX4fezuee/TO2MNdgo7rQ0tX2L493YLK6/THWdccsVGIyTzZNMTSwTUy2ME00Sky0tkowsTE3NLVKNzUws0iwMVu67nN4QyMiQ76LIyMgAgSA+G0NSaVVVbioDAwArCCGq";

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
      appId: appId,
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
      },
    ));

    // Join the channel
    await engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
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
              widget.userName,
              style: style17.copyWith(
                color: headingColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Calling...',
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
                    backgroundImage: AssetImage(widget.profileImage),
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
                    onPressed: () => toggleMute(),
                  ),
                  _buildCallControlButton(
                    icon: isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    color: PrimarybuttonColor,
                    onPressed: () => toggleSpeaker(),
                  ),
                  _buildCallControlButton(
                    icon: Icons.call_end,
                    color: SecondarybuttonColor,
                    onPressed: () => endCall(),
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
            offset: Offset(0, 4),
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

  void toggleMute() async {
    await engine?.muteLocalAudioStream(!isMuted);
    setState(() => isMuted = !isMuted);
  }

  void toggleSpeaker() async {
    await engine?.setEnableSpeakerphone(!isSpeakerOn);
    setState(() => isSpeakerOn = !isSpeakerOn);
  }

  void endCall() async {
    await engine?.leaveChannel();
    await engine?.release();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    engine?.leaveChannel();
    engine?.release();
    super.dispose();
  }
}

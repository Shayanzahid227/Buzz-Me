import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  final String userName;
  final String profileImage;

  const VideoCallScreen({
    super.key,
    required this.userName,
    required this.profileImage,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  double selfViewX = 20.w;
  double selfViewY = 100.h;

  // Agora Engine
  RtcEngine? _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

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
    initAgora();
  }

  Future<void> initAgora() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Create RTC Engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine!.enableVideo();
    await _engine!.startPreview();
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: lightGreyColor4,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.userName,
              style: style17.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '00:45',
              style: style14.copyWith(
                color: lightGreyColor,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Remote video view
          _remoteUid != null
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _engine!,
                    canvas: VideoCanvas(uid: _remoteUid),
                    connection: RtcConnection(channelId: channelName),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.profileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

          // Local video view
          Positioned(
            left: selfViewX,
            top: selfViewY,
            child: Draggable(
              feedback: _buildLocalVideoView(),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: _buildLocalVideoView(),
              ),
              child: _buildLocalVideoView(),
              onDragEnd: (details) {
                setState(() {
                  // Calculate new position within screen bounds
                  final screenSize = MediaQuery.of(context).size;
                  final selfViewSize = Size(100.w, 150.h);

                  selfViewX = details.offset.dx.clamp(
                    0,
                    screenSize.width - selfViewSize.width,
                  );
                  selfViewY = details.offset.dy.clamp(
                    kToolbarHeight - 50.h, // Account for AppBar
                    screenSize.height -
                        selfViewSize.height -
                        100.h, // Account for bottom controls
                  );
                });
              },
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallControlButton(
                  icon: Icons.mic_off,
                  color: PrimarybuttonColor,
                  onPressed: () {},
                ),
                _buildCallControlButton(
                  icon: Icons.videocam_off,
                  color: PrimarybuttonColor,
                  onPressed: () {},
                ),
                _buildCallControlButton(
                  icon: Icons.call_end,
                  color: SecondarybuttonColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                _buildCallControlButton(
                  icon: Icons.flip_camera_ios,
                  color: PrimarybuttonColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalVideoView() {
    return Container(
      width: 100.w,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: whiteColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: _localUserJoined
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
            : Container(color: darkGreyColor),
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
}

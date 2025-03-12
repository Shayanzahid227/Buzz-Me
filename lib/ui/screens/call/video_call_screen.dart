import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          // Full screen background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Draggable self-view camera
          Positioned(
            left: selfViewX,
            top: selfViewY,
            child: Draggable(
              feedback: _buildSelfViewCamera(),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: _buildSelfViewCamera(),
              ),
              child: _buildSelfViewCamera(),
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

  Widget _buildSelfViewCamera() {
    return Container(
      width: 100.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: darkGreyColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: whiteColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
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

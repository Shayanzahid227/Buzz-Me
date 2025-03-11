import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoCallScreen extends StatelessWidget {
  final String userName;
  final String profileImage;

  const VideoCallScreen({
    super.key,
    required this.userName,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen background (would be camera feed in a real app)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Small self-view camera
          Positioned(
            top: 50.h,
            right: 20.w,
            child: Container(
              width: 100.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),

          // Call info at top
          Positioned(
            top: 50.h,
            left: 20.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: style17.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '00:45',
                  style: style14.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
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
                  color: Colors.grey.withOpacity(0.8),
                  onPressed: () {},
                ),
                _buildCallControlButton(
                  icon: Icons.videocam_off,
                  color: Colors.grey.withOpacity(0.8),
                  onPressed: () {},
                ),
                _buildCallControlButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                _buildCallControlButton(
                  icon: Icons.flip_camera_ios,
                  color: Colors.grey.withOpacity(0.8),
                  onPressed: () {},
                ),
              ],
            ),
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
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
    );
  }
}

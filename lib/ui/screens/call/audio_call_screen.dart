import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioCallScreen extends StatelessWidget {
  final String userName;
  final String profileImage;

  const AudioCallScreen({
    super.key,
    required this.userName,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top section with call info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70.r,
                    backgroundImage: AssetImage(profileImage),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    userName,
                    style: style17.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Calling...',
                    style: style14.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Call duration timer (would be dynamic in a real app)
                  Text(
                    '00:45',
                    style: style17.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                    icon: Icons.mic_off,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  _buildCallControlButton(
                    icon: Icons.volume_up,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  _buildCallControlButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
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

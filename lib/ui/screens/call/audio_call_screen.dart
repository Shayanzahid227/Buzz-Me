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
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(
              userName,
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
                    backgroundImage: AssetImage(profileImage),
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
                    icon: Icons.mic_off,
                    color: PrimarybuttonColor,
                    onPressed: () {},
                  ),
                  _buildCallControlButton(
                    icon: Icons.volume_up,
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
}

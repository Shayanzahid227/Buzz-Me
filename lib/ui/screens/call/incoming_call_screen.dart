import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/models/call.dart';
import 'package:code_structure/core/services/call_service.dart';
import 'package:code_structure/ui/screens/call/audio_call_screen.dart';
import 'package:code_structure/ui/screens/call/video_call_screen.dart';
import 'package:provider/provider.dart';

class IncomingCallScreen extends StatelessWidget {
  final Call call;

  const IncomingCallScreen({
    super.key,
    required this.call,
  });

  void _handleAcceptCall(BuildContext context) {
    // Update call status to ongoing
    // context.read<CallService>().endCurrentCall();

    // Navigate to appropriate call screen
    if (call.callType == 'video') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(call: call),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AudioCallScreen(call: call),
        ),
      );
    }
  }

  void _handleRejectCall(BuildContext context) {
    // context.read<CallService>().rejectCurrentCall();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100.r,
                    backgroundImage: AssetImage(call.callerName),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    call.callerName,
                    style: style17.copyWith(
                      color: headingColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Incoming ${call.callType} call...',
                    style: style14.copyWith(
                      color: subheadingColor2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCallButton(
                    icon: Icons.call_end,
                    color: SecondarybuttonColor,
                    onPressed: () => _handleRejectCall(context),
                  ),
                  _buildCallButton(
                    icon: Icons.call,
                    color: PrimarybuttonColor,
                    onPressed: () => _handleAcceptCall(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton({
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
}

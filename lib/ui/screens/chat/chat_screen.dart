import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/call/audio_call_screen.dart';
import 'package:code_structure/ui/screens/call/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF8F8F8).withAlpha(200),
        leadingWidth: 40.w,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(AppAssets().pic),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'John Doe',
                    style: style17.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Online',
                        style: style14.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioCallScreen(
                    userName: 'John Doe',
                    profileImage: AppAssets().pic,
                  ),
                ),
              );
            },
            icon: Icon(Icons.call, color: lightOrangeColor),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                    userName: 'John Doe',
                    profileImage: AppAssets().pic,
                  ),
                ),
              );
            },
            icon: Icon(Icons.videocam, color: lightOrangeColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
        shape: const Border(
          bottom: BorderSide(color: Colors.black26),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                bool isMe = index % 2 == 0;
                return Stack(
                  children: [
                    Container(
                      margin: isMe
                          ? EdgeInsets.only(
                              right: 16.w,
                              top: 8.h,
                              bottom: 8.h,
                              left: 100.w,
                            )
                          : EdgeInsets.only(
                              right: 100.w,
                              top: 8.h,
                              bottom: 8.h,
                              left: 16.w,
                            ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: isMe
                            ? LinearGradient(
                                colors: [
                                  lightOrangeColor,
                                  lightPinkColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isMe ? null : Color(0xFFDADADA),
                      ),
                      child: Text(
                        'asjdfakfja oljladf ilajs dfio ndsu nia dsa ijoa dfha sdhfs dfijsdf a sdf ds fad f adf  nkkj asjd  iasd adafdas adfasd ffasdf a ',
                        style: style17.copyWith(
                          color: isMe ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: CustomPaint(
                        painter: BubbleTailPainter(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, -1),
                  blurRadius: 7.r,
                  spreadRadius: 0,
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.black26,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type a Message...',
                              hintStyle: style14.copyWith(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.h),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showAttachmentOptions(context);
                          },
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE56B6F),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Record voice note
                    },
                    icon: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Content',
              style: style17.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                    context, Icons.photo, 'Gallery', Colors.purple),
                _buildAttachmentOption(
                    context, Icons.insert_drive_file, 'Document', Colors.blue),
                _buildAttachmentOption(
                    context, Icons.location_on, 'Location', Colors.green),
                _buildAttachmentOption(
                    context, Icons.person, 'Contact', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
      BuildContext context, IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: style14.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pink, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, 10, 10));

    var path = Path();
    path.moveTo(10, 0);
    path.lineTo(0, 10);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

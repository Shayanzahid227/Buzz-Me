import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFF8F8F8).withAlpha(200),
        title: Text(
          'Message',
          style: style17.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
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
            padding: EdgeInsets.only(
              top: 10.h,
              bottom: 15.h,
              left: 5.w,
              right: 5.w,
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: lightGreyColor,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: style14.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9B9B9B),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 5.h,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: lightOrangeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

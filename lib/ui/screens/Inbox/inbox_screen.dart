import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Message',
          style: style25B.copyWith(
            fontSize: 34.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: style17.copyWith(
                    color: Color(0xFF9B9B9B),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 26.r,
                  ),
                  fillColor: Color(0xFFE6E6E6),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: Color(0xFFDAD9E2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'ONLINE USERS',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC1C0C9)),
              ),
            ),
            14.verticalSpace,
            SizedBox(
              height: 100.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 16.w, left: 6.w),
                child: Row(
                  children: List.generate(
                    10,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: AssetImage(AppAssets().pic),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 15.w,
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(50.r),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Danny Rice'.splitMapJoin(
                                ' ',
                                onMatch: (p0) => '\n',
                              ),
                              textAlign: TextAlign.center,
                              style: style14.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: List.generate(
                  10,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage(AppAssets().pic),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      lightOrangeColor,
                                      lightPinkColor,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.w,
                                  ),
                                ),
                                child: Text(
                                  '13',
                                  style: style14.copyWith(
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          'Danny Rice',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Hey! How is it going?',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFC1C0C9),
                          ),
                        ),
                        trailing: Text(
                          '12:00',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFC1C0C9),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

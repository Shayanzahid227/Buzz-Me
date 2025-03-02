import 'package:code_structure/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabItem extends StatelessWidget {
  final String title;
  const CustomTabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyColor,
      height: 40.h,
      child: Tab(
        child: Center(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

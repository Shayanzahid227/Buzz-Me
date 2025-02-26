import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/nearby_all_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
///   custom widget of nearby screen first tab --->  all users
///

class CustomNearbyAllUserWidget extends StatelessWidget {
  final NearbyAllUsersModel nearbyAllUser;
  const CustomNearbyAllUserWidget({
    required this.nearbyAllUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ///
    ///  to change the color according to gender
    ///
    final List<Color> gradientColors =
        nearbyAllUser.gender == AppAssets().genderWoman
            ? [lightPinkColor, lightOrangeColor] // Gradient for female
            : [darkBlueColor, skyBlueColor];
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
            image: AssetImage('${nearbyAllUser.imageUrl}'), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${nearbyAllUser.name}',
                  style: style14B.copyWith(color: whiteColor),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors

                        //colors: [lightPinkColor, lightOrangeColor],
                        ),
                    borderRadius: BorderRadius.circular(60.r),
                    //  color: Colors.orange,
                  ),
                  height: 22.h,
                  width: 50.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        '${nearbyAllUser.gender}',
                        height: 10.h,
                        width: 10.h,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        '${nearbyAllUser.rating}',
                        style:
                            style14.copyWith(color: whiteColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          5.verticalSpace,
        ],
      ),
    );
  }
}

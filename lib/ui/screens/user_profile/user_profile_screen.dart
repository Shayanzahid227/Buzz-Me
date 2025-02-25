import 'package:card_swiper/card_swiper.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/a_buttons/circular_button.dart';
import 'package:code_structure/ui/screens/discover/discover_screen_view_model.dart';
import 'package:code_structure/ui/screens/user_profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileViewModel(),
      child: Consumer<UserProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                ///  main container in which user images are shown
                ///
                _userProfile(model, context),

                ///
                ///  about Section
                ///
                _about(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// profile with swiper images
  ///
  _userProfile(UserProfileViewModel model, BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Swiper(
            itemCount: model.userImagesList.length,
            itemHeight: MediaQuery.of(context).size.height * 0.7,
            itemWidth: double.infinity,
            layout: SwiperLayout.STACK,
            scrollDirection: Axis.vertical,
            pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(top: 40, right: 20),
              builder: DotSwiperPaginationBuilder(
                color: whiteColor,
                activeColor: greyColor,
              ),
            ),
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        model.userImagesList[index],
                      ),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 40.h),
                      child: CircularButton(
                          onPressed: () {}, icon: AppAssets().cancelIcon),
                    ),
                  ],
                ),
              );
            },
          ),
          20.verticalSpace,

          ///
          ///  user name and ratting
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      'Mary Burgess',
                      style: style25B.copyWith(color: headingColor),
                    ),
                    8.horizontalSpace,
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [lightPinkColor, lightOrangeColor]),
                        borderRadius: BorderRadius.circular(60.r),
                        //  color: Colors.orange,
                      ),
                      height: 22.h,
                      width: 50.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.female),
                          Text('23'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CircleAvatar(
                    backgroundColor: lightGreyColor2,
                    radius: 15.r,
                    child: Icon(
                      Icons.more_horiz_rounded,
                      color: greyColor,
                    )),
              )
            ],
          ),
          10.verticalSpace,

          ///
          /// 2nd Row for status(settle / !settle) and location
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Text(
                  'Seattle, ',
                  style:
                      style16.copyWith(color: lightGreyColor, fontSize: 15.sp),
                ),
                8.horizontalSpace,
                Text(
                  ' USA ',
                  style:
                      style16.copyWith(color: lightGreyColor, fontSize: 15.sp),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Divider(
            color: lightGreyColor3,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  ///
  /// About Section
  ///
  _about() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: style25B.copyWith(color: headingColor),
          ),
          10.verticalSpace,
          Text(
            'I am a very simple person with a very simple life. I love to travel and explore new places. I am a very simple person with a very simple life. I love to travel and explore new places.',
            style: style16.copyWith(color: subHeadingColor, fontSize: 15),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  ///
  /// friends Section
  ///
}

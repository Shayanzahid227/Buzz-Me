import 'package:card_swiper/card_swiper.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/user_profile.dart';
import 'package:code_structure/custom_widgets/a_buttons/circular_button.dart';
import 'package:code_structure/custom_widgets/buzz%20me/user_profile_interesting.dart';
import 'package:code_structure/custom_widgets/buzz%20me/user_profile_looking_for.dart';

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userProfile(model, context),
              Expanded(
                child: ListView(
                  children: [
                    _about(),
                    _friends(model, context),
                    _basicProfile(model, context),
                    _interesting(model, context),
                    20.verticalSpace,
                    _LookingFor(model, context),
                    50.verticalSpace,
                  ],
                ),
              ),
            ],
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
          SizedBox(
            //height: MediaQuery.of(context).size.height * 0.7.h,
            child: Swiper(
              itemCount: model.userImagesList.length,
              itemHeight: MediaQuery.of(context).size.height * 0.7,
              itemWidth: double.infinity,
              layout: SwiperLayout.STACK,
              scrollDirection: Axis.vertical,
              pagination: SwiperPagination(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(top: 40, right: 20),
                builder: DotSwiperPaginationBuilder(
                  color: greyColor,
                  activeColor: whiteColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
            color: lightGreyColor2,
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
  _friends(UserProfileViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Friends',
            style: style25B.copyWith(color: headingColor),
          ),
          Container(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: model.friendsImagesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage(
                      model.friendsImagesList[index],
                    ),
                  ),
                );
              },
            ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  ///
  /// basic profile
  ///
  _basicProfile(UserProfileViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Profile ',
            style: style25B.copyWith(color: headingColor),
          ),
          20.verticalSpace,
          Row(
            children: [
              Text(
                'Height: ',
                style: style16N.copyWith(color: subHeadingColor),
              ),
              Text(
                '160cm',
                style: style16N.copyWith(color: subheadingColor2),
              ),
            ],
          ),
          5.verticalSpace,
          Row(
            children: [
              Text(
                'weight: ',
                style: style16N.copyWith(color: subHeadingColor),
              ),
              Text(
                '65Kg',
                style: style16N.copyWith(color: subheadingColor2),
              ),
            ],
          ),
          5.verticalSpace,
          Row(
            children: [
              Text(
                'Relationships status: ',
                style: style16N.copyWith(color: subHeadingColor),
              ),
              Text(
                'single',
                style: style16N.copyWith(color: subheadingColor2),
              ),
            ],
          ),
          5.verticalSpace,
          Row(
            children: [
              Text(
                'joined date: ',
                style: style16N.copyWith(color: subHeadingColor),
              ),
              Text(
                'Feb 25,2025 ',
                style: style16N.copyWith(color: subheadingColor2),
              ),
            ],
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  ///
  /// Interesting section
  ///
  _interesting(UserProfileViewModel model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interesting ',
            style: style25B.copyWith(color: headingColor),
          ),
          20.verticalSpace,

          ///
          ///   using wrap it will cover the space according to the text
          ///
          Wrap(
            runSpacing: 15.0,
            spacing: 18.0,
            children: List.generate(
              6,
              (index) {
                return CustomInterestingWidget(
                    userProfileModel: UserProfileInterestingItemModel(
                        title: model.interestingItemList[index]));
              },
            ),
          )
          // GridView.builder(
          //   scrollDirection: Axis.vertical,
          //   physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       childAspectRatio: 3,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 10),
          //   itemCount: 6,
          //   shrinkWrap: true,
          //   itemBuilder: (BuildContext context, int index) {
          //     return CustomInterestingWidget();
          //   },
          // )
        ],
      ),
    );
  }

  ///
  /// looking for
  ///
  _LookingFor(UserProfileViewModel model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Looking For ',
            style: style25B.copyWith(color: headingColor),
          ),
          20.verticalSpace,

          ///
          ///   using wrap it will cover the space according to the text
          ///
          Wrap(
            runSpacing: 15.0,
            spacing: 18.0,
            children: List.generate(
              model.lookingForItemList.length,
              (index) {
                return CustomLookkingForWidget(
                    userProfileLookingForModel: UserProfileLookingForMOdel(
                        title: model.lookingForItemList[index]));
              },
            ),
          )
          // GridView.builder(
          //   scrollDirection: Axis.vertical,
          //   physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       childAspectRatio: 3,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 10),
          //   itemCount: 6,
          //   shrinkWrap: true,
          //   itemBuilder: (BuildContext context, int index) {
          //     return CustomInterestingWidget();
          //   },
          // )
        ],
      ),
    );
  }
}

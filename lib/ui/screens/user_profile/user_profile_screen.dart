import 'package:card_swiper/card_swiper.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/model/user_profile.dart';
import 'package:code_structure/custom_widgets/a_buttons/circular_button.dart';
import 'package:code_structure/custom_widgets/buzz%20me/user_profile_interesting.dart';
import 'package:code_structure/custom_widgets/buzz%20me/user_profile_looking_for.dart';

import 'package:code_structure/ui/screens/user_profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  final AppUser appUser;
  const UserProfileScreen({
    required this.appUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileViewModel(appUser.uid ?? ''),
      child: Consumer<UserProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userProfile(model, context),
                ListView(
                  shrinkWrap:
                      true, // Allows ListView to be inside SingleChildScrollView
                  physics:
                      NeverScrollableScrollPhysics(), // Prevent inner ListView scrolling
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
              ],
            ),
          ),
          floatingActionButton: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    model.giveLike(appUser.uid!);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 2), // changes position of shadow
                          )
                        ]),
                    child: Icon(
                      Icons.heart_broken,
                      color: Colors.red,
                    ),
                  ),
                ),
                20.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    model.giveSuperLike(appUser.uid!);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 2), // changes position of shadow
                          )
                        ]),
                    child: Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                  ),
                ),
                20.horizontalSpace,
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 2), // changes position of shadow
                        )
                      ]),
                  child: Icon(
                    Icons.message,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  ///
  /// profile with swiper images
  ///
  _userProfile(UserProfileViewModel model, BuildContext context) {
    ScrollController _scrollController = ScrollController();
    int _currentIndex = 0;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            _currentIndex == appUser.images!.length - 1) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOut,
          );
        }
        return false;
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          children: [
            SizedBox(
              //height: MediaQuery.of(context).size.height * 0.7.h,
              child: Swiper(
                itemCount: appUser.images?.length ?? 0,
                itemHeight: MediaQuery.of(context).size.height * 0.6,
                itemWidth: double.infinity,
                layout: SwiperLayout.STACK,
                scrollDirection: Axis.vertical,
                loop: true,
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
                          image: appUser.images?[index] != null
                              ? NetworkImage(
                                  appUser.images![index]!,
                                )
                              : AssetImage(AppAssets().pic),
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
                        appUser.userName ?? '',
                        style: style25B.copyWith(color: headingColor),
                      ),
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [lightPinkColor, lightOrangeColor]),
                          borderRadius: BorderRadius.circular(60.r),
                          //  color: Colors.orange,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              appUser.gender == "Male"
                                  ? Icons.male
                                  : Icons.female,
                              color: whiteColor,
                            ),
                            Text(
                              '${DateTime.now().year - appUser.dob!.year}',
                              style: style16.copyWith(color: whiteColor),
                            ),
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
                    appUser.address ?? 'No Address',
                    style: style16.copyWith(
                        color: lightGreyColor, fontSize: 15.sp),
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
            appUser.about ?? '',
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
                '${appUser.height}cm',
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
                '${appUser.weight}kg',
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
                appUser.relationshipStatus ?? '',
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
                DateFormat('MMM dd, yyyy').format(appUser.createdAt!),
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
              appUser.interests!.length,
              (index) {
                return CustomInterestingWidget(
                    userProfileModel: UserProfileInterestingItemModel(
                        title: appUser.interests![index]));
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
              appUser.lookingFor!.length,
              (index) {
                return CustomLookkingForWidget(
                    userProfileLookingForModel: UserProfileLookingForMOdel(
                        title: appUser.lookingFor![index]));
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

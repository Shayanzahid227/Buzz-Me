import 'package:card_swiper/card_swiper.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/custom_widgets/a_buttons/circular_button.dart';
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
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: blackColor),
                ),
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
                            color: blackColor,
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
                                    onPressed: () {},
                                    icon: AppAssets().cancelIcon),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Name'),
                            8.horizontalSpace,
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.r),
                                  color: Colors.orange),
                              height: 20.h,
                              width: 50.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.female),
                                  Text('23'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                            radius: 15.r, child: Icon(Icons.more_horiz_rounded))
                      ],
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Text('status'),
                        8.horizontalSpace,
                        Text('location'),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

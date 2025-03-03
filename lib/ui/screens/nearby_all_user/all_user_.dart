import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buzz%20me/nearby_all_user.dart';
import 'package:code_structure/ui/screens/discover/discover_screen.dart';
import 'package:code_structure/ui/screens/filter/filter_screen.dart';
import 'package:code_structure/ui/screens/nearby_all_user/all_user_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/buzz me/header.dart';

class NearbyAllUserScreen extends StatelessWidget {
  const NearbyAllUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NearbyAllUsersViewModel(),
      child: Consumer<NearbyAllUsersViewModel>(
        builder: (context, model, child) => DefaultTabController(
          length: 4,
          child: Scaffold(
            body: Column(
              children: [
                40.verticalSpace,
                customHeader(
                    heading: 'Nearby',
                    headingColor: blackColor,
                    image: AppAssets().fbIcon,
                    onTap: () {
                      Get.to(FilterScreen());
                    }),
                20.verticalSpace,
                TabBar(
                  tabAlignment: TabAlignment.fill,
                  //    isScrollable: true,
                  indicatorColor: indicatorColor,
                  unselectedLabelColor: greyColor,
                  labelColor: indicatorColor,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  //  labelStyle: style16.copyWith(color: indicatorColor),
                  tabs: [
                    Text(
                      'All Users',
                      style: style16.copyWith(
                          // fontSize: 17.sp,
                          ),
                    ),
                    Text(
                      'spotlight',
                      style: style16.copyWith(
                          //  fontSize: 17.sp,
                          ),
                    ),
                    Text(
                      'New',
                      style: style16.copyWith(
                          //fontSize: 17.sp,
                          ),
                    ),
                    Text(
                      'Nearby',
                      style: style16.copyWith(
                          //fontSize: 17.sp,
                          ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _allUsers(context, model),
                      _allUsers(context, model),
                      _allUsers(context, model),
                      _allUsers(context, model)
                    ],
                  ),
                )
                // _allUsers(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _allUsers(BuildContext context, NearbyAllUsersViewModel model) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.99,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
        ),
        itemCount: model.allUsersList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: CustomNearbyAllUserWidget(
              nearbyAllUser: model.allUsersList[index],
            ),
          );
        },
      ),
    );
  }
}

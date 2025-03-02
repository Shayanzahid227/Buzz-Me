import 'package:another_xlider/another_xlider.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/custom_widgets/buzz%20me/header.dart';
import 'package:code_structure/ui/screens/filter/custom_tabItem.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
//******* */

import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController(length: 3, vsync: this);
    return ChangeNotifierProvider(
      create: (context) => BaseViewModel(),
      child: Consumer<BaseViewModel>(
        builder: (context, model, child) => DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Column(
              children: [
                50.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: style25B.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: headingColor),
                      ),
                      Text(
                        'Done',
                        style: style25.copyWith(
                            fontSize: 17.sp, color: indicatorColor),
                      )
                    ],
                  ),
                ),
                10.verticalSpace,
                Divider(),
                20.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: tabBarColor),

                    ///
                    ///   tab bar
                    ///
                    child: TabBar(
                      labelStyle: TextStyle(color: whiteColor),
                      labelColor: whiteColor,
                      unselectedLabelColor: tabBarTextColor,

                      tabAlignment: TabAlignment.start,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient: LinearGradient(
                          colors: [lightPinkColor, lightOrangeColor],
                        ),
                      ),
                      isScrollable: true,
                      //  labelPadding: EdgeInsets.symmetric(horizontal: 30),
                      tabs: [
                        ///
                        ///  tab 1
                        ///
                        Container(
                          height: 50.h,
                          child: Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Guys',
                                style: style25.copyWith(
                                    fontSize: 17.sp,
                                    color: tabBarTextColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),

                        ///
                        /// tab 2
                        ///
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Girls',
                              style: style25.copyWith(
                                  fontSize: 17.sp,
                                  color: tabBarTextColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),

                        ///
                        /// tab 3
                        ///
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Both',
                              style: style25.copyWith(
                                  fontSize: 17.sp,
                                  color: tabBarTextColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///
                /// tabbar view
                ///

                // TabBar(
                //   tabs: [
                //     CustomTabItem(title: 'ok'),
                //     CustomTabItem(title: 'dd'),
                //     CustomTabItem(title: 'dd'),
                //   ],
                // ),
                Expanded(
                  child: Column(
                    children: [
                      FlutterSlider(
                        values: [100, 0],
                        rtl: false,
                        max: 500,
                        min: 0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

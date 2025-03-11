import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/user_profile.dart';
import 'package:code_structure/custom_widgets/buzz%20me/user_profile_interesting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  List<String> interestingItemList = [
    'Guitar & tabla',
    'Music & Games',
    'Fishing',
    'Swimming',
    'Book % Movies',
    'Dancing & Singing',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Done", style: TextStyle(color: Colors.pink)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            _buildPhotoGrid(),
            20.verticalSpace,

            // Profile Info
            _buildInfoRow("Username", "Landon Gibson"),
            _buildInfoRow("Birthday", "April 18, 1993", showArrow: true),
            _buildInfoRow("Gender", "Male", showArrow: true),

            36.verticalSpace,

            // About you
            Text(
              "About you",
              style: style25B,
            ),
            10.verticalSpace,
            Text(
              "I'm looking for the right emoji. I enjoy hiking with friends I help them have uplifting experiences many hearts and love all around...",
              style: style17.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            19.verticalSpace,
            Divider(
              height: 1,
              color: Colors.grey[300],
            ),

            _buildInfoRow('Height', '183 cm'),
            _buildInfoRow('Weight', '76 kg'),

            // Relationship status
            _buildInfoRow("Relationship status", "Single", showArrow: true),
            _buildInfoRow("Looking for", "Friends, Date More...",
                showArrow: true),

            30.verticalSpace,

            // Interesting
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Interesting",
                  style: style25B,
                ),
                20.verticalSpace,
                Wrap(
                  runSpacing: 15.0,
                  spacing: 18.0,
                  children: List.generate(
                    6,
                    (index) {
                      return CustomInterestingWidget(
                          userProfileModel: UserProfileInterestingItemModel(
                              title: interestingItemList[index]));
                    },
                  ),
                ),
                30.verticalSpace,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: lightPinkColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        "Add more interests",
                        style: TextStyle(fontSize: 14, color: lightPinkColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            30.verticalSpace,

            // Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: style25B,
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: lightGreyColor,
                    ),
                    Text(
                      "Current location",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      "Seattle, WA",
                      style: style17.copyWith(
                        color: lightGreyColor3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool showDivider = true, bool showArrow = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 17.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
              Spacer(),
              Text(
                value,
                style: style17.copyWith(
                  color: lightGreyColor3,
                  fontWeight: FontWeight.w400,
                ),
              ),
              10.horizontalSpace,
              if (showArrow)
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: lightGreyColor,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
      ],
    );
  }

  Widget _buildInterestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Column(
      spacing: 13.h,
      children: [
        SizedBox(
          height: 225.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Image.asset(AppAssets().pic, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 25.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            '1',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 13.h,
                  children: [
                    _buildPhotoItem(),
                    _buildPhotoItem(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPhotoItem(),
            _buildPhotoItem(),
            _buildPhotoItem(),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoItem() {
    return Stack(
      children: [
        Container(
          height: 106.h,
          width: 106.w,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Image.asset(AppAssets().pic, fit: BoxFit.cover),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 25.w,
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                '1',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

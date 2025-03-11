import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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
            _buildInfoRow("Birthday", "April 18, 1993"),
            _buildInfoRow("Gender", "Male"),

            20.verticalSpace,

            // About you
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About you",
                  style: style25B,
                ),
                const SizedBox(height: 10),
                const Text(
                  "I'm looking for the right emoji. I enjoy hiking with friends :) I help them have uplifting experiences :) many hearts and love all around. :)",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Height",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("183 cm",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Relationship status
            _buildInfoRow("Relationship status", "Single"),
            _buildInfoRow("Looking for", "Friends, Date More..."),

            const SizedBox(height: 20),

            // Interesting
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Interesting",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildInterestChip("Cycling"),
                    _buildInterestChip("Technology"),
                    _buildInterestChip("Biking"),
                    _buildInterestChip("Dancing"),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Add more interests",
                  style: TextStyle(fontSize: 14, color: Colors.pink[300]),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildInfoRow("Current location", "Seattle, WA",
                    showDivider: false),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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

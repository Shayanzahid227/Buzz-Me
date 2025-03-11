import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/ui/screens/edit_profile/edit_profile_screen.dart';
import 'package:code_structure/ui/screens/wallet/wallet_home/wallet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Card
                    Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 70,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFF6B8B),
                                  Color(0xFFFF8E53),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 40.h, left: 16.w, right: 16.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 10,
                                spreadRadius: 0,
                                color: Color(0xFF000000).withOpacity(0.0796),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Profile Picture
                                    Stack(
                                      children: [
                                        Container(
                                          width: 94.w,
                                          height: 94.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            image: DecorationImage(
                                              image:
                                                  AssetImage(AppAssets().pic),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 25.w,
                                            height: 25.h,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  lightOrangeColor,
                                                  lightPinkColor,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.w,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.cabin,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    // Name and Location
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Landon Gibson',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              10.horizontalSpace,
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfileScreen(),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.mode_edit_outlined,
                                                  color: lightOrangeColor,
                                                  size: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Seattle, USA',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildDivider(),
                                // Stats Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatColumn('POSTS', '2318'),
                                    _buildStatColumn('FOLLOWING', '364'),
                                    _buildStatColumn('FOLLOWED', '15'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 10,
                            spreadRadius: 0,
                            color: Color(0xFF000000).withOpacity(0.0796),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(Icons.favorite, 'Likes', Colors.red),
                          _buildDivider(),
                          _buildMenuItem(
                              Icons.location_on, 'Visits', Colors.green),
                          _buildDivider(),
                          _buildMenuItem(Icons.group, 'Groups', Colors.purple),
                        ],
                      ),
                    ), // Menu Items
                    20.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 10,
                            spreadRadius: 0,
                            color: Color(0xFF000000).withOpacity(0.0796),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            Icons.account_balance_wallet,
                            'My wallet',
                            Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletHomeScreen(),
                                ),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                              Icons.verified_user, 'VIP center', Colors.blue),
                          _buildDivider(),
                          _buildMenuItem(Icons.person_add, 'Find friends',
                              Colors.lightGreen),
                          _buildDivider(),
                          _buildMenuItem(Icons.block, 'Blacklist', Colors.grey),
                          _buildDivider(),
                          _buildMenuItem(
                              Icons.settings, 'Settings', Colors.grey),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String count) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: lightDividerColor,
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, {onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 14),
          leading: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

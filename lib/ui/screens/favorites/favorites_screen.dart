import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/providers/all_users_provider.dart';
import 'package:code_structure/core/providers/user_provider.dart';
import 'package:code_structure/custom_widgets/buzz%20me/nearby_all_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AllUsersProvider, UserProvider>(
        builder: (context, allUsersProvider, userProvider, child) {
      var likes = allUsersProvider.users.where(
        (element) => userProvider.user.liked!.contains(element.uid),
      );
      var visits = allUsersProvider.users.where(
        (element) => userProvider.user.visited!.contains(element.uid),
      );

      var superLikes = allUsersProvider.users.where(
        (element) => userProvider.user.superLiked!.contains(element.uid),
      );

      var matches = allUsersProvider.users.where(
        (element) => userProvider.user.matched!.contains(element.uid),
      );

      var allConnection = [];
      allConnection.addAll(likes);
      allConnection.addAll(superLikes);
      allConnection.addAll(visits);
      allConnection.addAll(matches);

      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              _buildHeader(),
              _buildDropdownContent(),
              Divider(),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: allConnection.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomNearbyAllUserWidget(
                      appUser: allConnection[index],
                    );
                  },
                ),
              ),
              // ... (rest of your content)
            ],
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  Widget _buildHeader() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
          color: fillColor2, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 20.h,
                  width: 34,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [lightPinkColor, lightOrangeColor],
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text('23'),
                  ),
                ),
                10.w.horizontalSpace,
                Text(
                  'All connections',
                  style: TextStyle(fontSize: 17, color: blackColor),
                ),
              ],
            ),
            IconButton(
              icon: Icon(_isDropdownOpen
                  ? Icons.keyboard_arrow_up_sharp
                  : Icons.keyboard_arrow_down_sharp),
              onPressed: _toggleDropdown,
            ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  Widget _buildDropdownContent() {
    if (!_isDropdownOpen) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Container(
          height: 50.h,
          decoration: BoxDecoration(color: fillColor2),
          child: ListTile(
            leading: Container(
              height: 24.h,
              width: 24.w,
              child: Image.asset(
                AppAssets().appLogo,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Matches'),
            onTap: () {
              _toggleDropdown();
            },
          ),
        ),
        10.verticalSpace,
        Container(
          height: 50.h,
          decoration: BoxDecoration(color: fillColor2),
          child: ListTile(
            leading: Container(
              height: 24.h,
              width: 24.w,
              child: Image.asset(
                AppAssets().appLogo,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Visits'),
            onTap: () {
              _toggleDropdown();
            },
          ),
        ),
        10.verticalSpace,
        Container(
          height: 50.h,
          decoration: BoxDecoration(color: fillColor2),
          child: ListTile(
            leading: Container(
              height: 24.h,
              width: 24.w,
              child: Image.asset(
                AppAssets().appLogo,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Likes'),
            onTap: () {
              _toggleDropdown();
            },
          ),
        ),
        10.verticalSpace,
        Container(
          height: 50.h,
          decoration: BoxDecoration(color: fillColor2),
          child: ListTile(
            leading: Container(
              height: 24.h,
              width: 24.w,
              child: Image.asset(
                AppAssets().appLogo,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('SuperLikes'),
            onTap: () {
              _toggleDropdown();
            },
          ),
        ),
      ],
    );
  }
}

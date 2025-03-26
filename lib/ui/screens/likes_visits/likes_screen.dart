import 'package:code_structure/core/providers/all_users_provider.dart';
import 'package:code_structure/core/providers/user_provider.dart';
import 'package:code_structure/custom_widgets/buzz%20me/nearby_all_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AllUsersProvider, UserProvider>(
      builder: (context, allUsersProvider, userProvider, child) {
        var likes = allUsersProvider.users
            .where((element) => userProvider.user.liked!.contains(element.uid))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Likes (${likes.length})'),
          ),
          body: Padding(
            padding: EdgeInsets.all(15.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: likes.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomNearbyAllUserWidget(
                  appUser: likes[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

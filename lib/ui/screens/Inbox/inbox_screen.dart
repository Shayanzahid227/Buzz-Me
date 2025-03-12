import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: Text(
          'Inbox',
          style: style25B.copyWith(
            fontSize: 34.sp,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: lightPinkColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: lightPinkColor,
          indicatorWeight: 3,
          labelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Chat'),
            Tab(text: 'Groups'),
            Tab(text: 'Stories'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(),
          _buildGroupsTab(),
          _buildStoriesTab(),
          _buildCallsTab(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: style17.copyWith(
            color: Color(0xFF9B9B9B),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 26.r,
          ),
          fillColor: Color(0xFFE6E6E6),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, String trailing,
      {Widget? leading, Widget? subtitleWidget}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h),
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitleWidget ??
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFFC1C0C9),
            ),
          ),
      trailing: Text(
        trailing,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xFFC1C0C9),
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar('Search...'),
          Divider(
            color: Color(0xFFDAD9E2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'ONLINE USERS',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC1C0C9)),
            ),
          ),
          14.verticalSpace,
          SizedBox(
            height: 100.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: 16.w, left: 6.w),
              child: Row(
                children: List.generate(
                  10,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: AssetImage(AppAssets().pic),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 15.w,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50.r),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Danny Rice'.splitMapJoin(
                              ' ',
                              onMatch: (p0) => '\n',
                            ),
                            textAlign: TextAlign.center,
                            style: style14.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: List.generate(
                10,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(),
                        ),
                      );
                    },
                    child: _buildListTile(
                      'Danny Rice',
                      'Hey! How is it going?',
                      '12:00',
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage(AppAssets().pic),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    lightOrangeColor,
                                    lightPinkColor,
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                '13',
                                style: style14.copyWith(
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar('Search groups...'),
          Divider(
            color: Color(0xFFDAD9E2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'YOUR GROUPS',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC1C0C9)),
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: List.generate(
                8,
                (index) {
                  return _buildListTile(
                    'Group ${index + 1}',
                    '${3 + index} members',
                    '${index + 1}h ago',
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage(AppAssets().pic),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  lightOrangeColor,
                                  lightPinkColor,
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.w,
                              ),
                            ),
                            child: Text(
                              '13',
                              style: style14.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesTab() {
    final List<Map<String, dynamic>> stories = [
      {'name': 'Joaquin Garcia', 'badge': '4'},
      {'name': 'Amaranth', 'badge': ''},
      {'name': 'April Janice', 'badge': ''},
      {'name': 'Emilia', 'badge': '2'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My Stories Card
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My stories',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Icon(Icons.more_horiz, color: Colors.grey, size: 20.r),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 14.r,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '42 Watch',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14.r,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '21 Comments',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Grid of Stories
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    // Story Container
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(12.r),
                        border: stories[index]['badge'].isNotEmpty
                            ? Border.all(
                                color: Color(0xFFE3F2FD),
                                width: 2.w,
                              )
                            : null,
                      ),
                    ),
                    // Notification Badge
                    if (stories[index]['badge'].isNotEmpty)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          width: 16.w,
                          height: 16.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF2196F3),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            stories[index]['badge'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    // User Info at Bottom
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            stories[index]['name'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildCallsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar('Search calls...'),
          Divider(
            color: Color(0xFFDAD9E2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'RECENT CALLS',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC1C0C9)),
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: List.generate(
                6,
                (index) {
                  bool isIncoming = index % 2 == 0;
                  bool isMissed = index % 3 == 0;

                  return _buildListTile(
                    'Contact ${index + 1}',
                    '${isIncoming ? 'Incoming' : 'Outgoing'} ${isMissed ? '(Missed)' : ''}',
                    '${index + 1}h ago',
                    leading: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(AppAssets().pic),
                    ),
                    subtitleWidget: Row(
                      children: [
                        Icon(
                          isIncoming ? Icons.call_received : Icons.call_made,
                          size: 16.r,
                          color: isMissed ? Colors.red : Colors.green,
                        ),
                        5.horizontalSpace,
                        Text(
                          '${isIncoming ? 'Incoming' : 'Outgoing'} ${isMissed ? '(Missed)' : ''}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFC1C0C9),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

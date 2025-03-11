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

  Widget _buildChatTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search...',
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
          ),
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
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
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
                      title: Text(
                        'Danny Rice',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Hey! How is it going?',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFC1C0C9),
                        ),
                      ),
                      trailing: Text(
                        '12:00',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFC1C0C9),
                        ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search groups...',
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
          ),
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
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                    leading: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.group,
                        color: Colors.grey.shade700,
                        size: 30.r,
                      ),
                    ),
                    title: Text(
                      'Group ${index + 1}',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${3 + index} members',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFC1C0C9),
                      ),
                    ),
                    trailing: Text(
                      '${index + 1}h ago',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFC1C0C9),
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

  Widget _buildStoriesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 30.r,
                    color: lightPinkColor,
                  ),
                ),
                16.horizontalSpace,
                Text(
                  'Add to your story',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xFFDAD9E2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'RECENT STORIES',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC1C0C9)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [lightOrangeColor, lightPinkColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color: lightPinkColor,
                      width: 2.w,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(AppAssets().pic),
                    ),
                  ),
                ),
                title: Text(
                  'User ${index + 1}',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${index + 1}h ago',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFC1C0C9),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCallsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search calls...',
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
          ),
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

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                    leading: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(AppAssets().pic),
                    ),
                    title: Text(
                      'Contact ${index + 1}',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}h ago',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFC1C0C9),
                          ),
                        ),
                        10.horizontalSpace,
                        Icon(
                          index % 2 == 0 ? Icons.videocam : Icons.call,
                          color: lightPinkColor,
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

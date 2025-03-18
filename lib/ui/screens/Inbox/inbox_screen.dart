import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/message.dart';
import 'package:code_structure/ui/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/core/model/chat.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/services/chat_services.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:code_structure/core/model/story.dart';
import 'package:code_structure/core/services/story_services.dart';
import 'package:code_structure/ui/screens/stories/create_story_screen.dart';
import 'package:code_structure/ui/screens/stories/story_viewer_screen.dart';

class InboxScreen extends StatefulWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  InboxScreen({
    super.key,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ChatService _chatService = ChatService();
  final DatabaseServices _databaseServices = DatabaseServices();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final StoryService _storyService = StoryService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _getLastMessagePreview(String message, MessageType type) {
    switch (type) {
      case MessageType.text:
        return message;
      case MessageType.image:
        return '📷 Image';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.audio:
        return '🎵 Voice message';
      case MessageType.file:
        return '📎 File';
      default:
        return '';
    }
  }

  Widget _buildSearchBar(String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: TextFormField(
        controller: _searchController,
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

  Widget _buildChatTab() {
    return Column(
      children: [
        _buildSearchBar('Search chats...'),
        Divider(color: Color(0xFFDAD9E2)),
        _buildOnlineUsers(),
        Expanded(
          child: StreamBuilder<List<Chat>>(
            stream: _chatService.getUserChats(widget.currentUserId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final chats = snapshot.data!
                  .where((chat) => !chat.isGroup)
                  .where((chat) =>
                      chat.lastMessage.toLowerCase().contains(_searchQuery))
                  .toList();

              if (chats.isEmpty) {
                return const Center(child: Text('No chats found'));
              }

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otherUserId = chat.participants
                      .firstWhere((id) => id != widget.currentUserId);

                  return StreamBuilder<AppUser?>(
                    stream: _databaseServices.userStream(otherUserId),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final otherUser = userSnapshot.data!;
                      return _buildChatListTile(chat, otherUser);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineUsers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '   ONLINE USERS',
          style: style17B.copyWith(
            color: lightGreyColor,
          ),
        ),
        15.verticalSpace,
        SizedBox(
          height: 100.h,
          child: StreamBuilder<List<AppUser>?>(
            stream: _databaseServices.allUsersStream(widget.currentUserId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!
                  .where((user) => user.isOnline ?? false)
                  .where((user) =>
                      user.userName!.toLowerCase().contains(_searchQuery))
                  .toList();

              if (users.isEmpty) {
                return const Center(child: Text('No online users'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildOnlineUserItem(user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineUserItem(AppUser user) {
    return GestureDetector(
      onTap: () async {
        final chatId = await _chatService.createOrGetChat(
          [widget.currentUserId, user.uid!],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chatId,
              currentUserId: widget.currentUserId,
              otherUserId: user.uid!,
              isGroup: false,
              title: user.userName ?? '',
              imageUrl: user.images![0],
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: user.images![0] != null
                      ? NetworkImage(user.images![0]!)
                      : AssetImage(AppAssets().pic) as ImageProvider,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 15.w,
                    height: 15.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              user.userName ?? '',
              style: style14.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListTile(Chat chat, AppUser otherUser) {
    final lastMessageTime = timeago.format(chat.lastMessageTime);

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chat.id,
              currentUserId: widget.currentUserId,
              otherUserId: otherUser.uid!,
              isGroup: false,
              title: otherUser.userName ?? '',
              imageUrl: otherUser.images![0],
            ),
          ),
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: otherUser.images![0] != null
                ? NetworkImage(otherUser.images![0]!)
                : AssetImage(AppAssets().pic) as ImageProvider,
          ),
          if (otherUser.isOnline ?? false)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 15.w,
                height: 15.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        otherUser.userName ?? '',
        style: style17.copyWith(
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A4A4A),
        ),
      ),
      subtitle: Text(
        _getLastMessagePreview(chat.lastMessage, chat.lastMessageType),
        style: style14.copyWith(color: Colors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMessageTime,
            style: style14.copyWith(color: Colors.grey),
          ),
          if (chat.unreadCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lightOrangeColor, lightPinkColor],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: style14.copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return Column(
      children: [
        _buildSearchBar('Search groups...'),
        Divider(color: Color(0xFFDAD9E2)),
        Expanded(
          child: StreamBuilder<List<Chat>>(
            stream: _chatService.getUserChats(widget.currentUserId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final groups = snapshot.data!
                  .where((chat) => chat.isGroup)
                  .where((chat) =>
                      chat.groupName?.toLowerCase().contains(_searchQuery) ??
                      false)
                  .toList();

              if (groups.isEmpty) {
                return const Center(child: Text('No groups found'));
              }

              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return _buildGroupListTile(group);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupListTile(Chat group) {
    final lastMessageTime = timeago.format(group.lastMessageTime);

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: group.id,
              currentUserId: widget.currentUserId,
              isGroup: true,
              title: group.groupName!,
              imageUrl: group.groupImage,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 30.r,
        backgroundImage: group.groupImage != null
            ? NetworkImage(group.groupImage!)
            : AssetImage(AppAssets().pic) as ImageProvider,
      ),
      title: Text(
        group.groupName!,
        style: style17.copyWith(
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A4A4A),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${group.participants.length} members',
            style: style14.copyWith(color: Colors.grey),
          ),
          Text(
            _getLastMessagePreview(group.lastMessage, group.lastMessageType),
            style: style14.copyWith(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMessageTime,
            style: style14.copyWith(color: Colors.grey),
          ),
          if (group.unreadCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lightOrangeColor, lightPinkColor],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                group.unreadCount.toString(),
                style: style14.copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
    );
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

  Widget _buildStoriesTab() {
    return StreamBuilder<List<Story>>(
      stream: _storyService.getStories(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final myStories = snapshot.data!
            .where((story) => story.userId == widget.currentUserId)
            .toList();
        final otherStories = snapshot.data!
            .where((story) => story.userId != widget.currentUserId)
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Story Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: InkWell(
                  onTap: () => _addNewStory(),
                  child: Container(
                    width: double.infinity,
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 48.r,
                          color: lightPinkColor,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Add New Story',
                          style: style17.copyWith(
                            color: lightPinkColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // My Stories Section
              if (myStories.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'MY STORIES',
                    style: style17B.copyWith(color: lightGreyColor),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 200.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: myStories.length,
                    itemBuilder: (context, index) {
                      return _buildStoryCard(myStories[index], isMyStory: true);
                    },
                  ),
                ),
              ],

              // Recent Stories Section
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'RECENT STORIES',
                  style: style17B.copyWith(color: lightGreyColor),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: otherStories.length,
                  itemBuilder: (context, index) {
                    return _buildStoryCard(otherStories[index]);
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoryCard(Story story, {bool isMyStory = false}) {
    return FutureBuilder<AppUser?>(
      future: _databaseServices.getUser(story.userId),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return GestureDetector(
          onTap: () => _viewStory(story),
          child: Container(
            margin: EdgeInsets.only(right: isMyStory ? 12.w : 0),
            width: isMyStory ? 140.w : double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: NetworkImage(story.mediaUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundImage: user?.images?[0] != null
                            ? NetworkImage(user!.images![0]!)
                            : AssetImage(AppAssets().pic) as ImageProvider,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          user?.userName ?? 'Unknown',
                          style: style14.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 14.r,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${story.viewCount}',
                        style: style14.copyWith(color: Colors.white70),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14.r,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${story.commentCount}',
                        style: style14.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addNewStory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateStoryScreen(userId: widget.currentUserId),
      ),
    );
  }

  void _viewStory(Story story) async {
    final userStories = await _storyService.getStoriesForUser(story.userId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          stories: userStories,
          initialIndex: userStories.indexOf(story),
          currentUserId: widget.currentUserId,
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

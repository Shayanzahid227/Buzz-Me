import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:code_structure/ui/screens/call/audio_call_screen.dart';
import 'package:code_structure/ui/screens/call/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:code_structure/core/model/message.dart';
import 'package:code_structure/core/services/chat_services.dart';
import 'package:code_structure/core/services/storage_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String? otherUserId;
  final bool isGroup;
  final String title;
  final String? imageUrl;

  const ChatScreen({
    required this.chatId,
    required this.currentUserId,
    this.otherUserId,
    required this.isGroup,
    required this.title,
    this.imageUrl,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final DatabaseServices _databaseService = DatabaseServices();
  final StorageService _storageService = StorageService();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String content, MessageType type,
      {String? filePath}) async {
    if (content.isEmpty && type == MessageType.text) return;

    final message = Message(
      id: const Uuid().v4(),
      senderId: widget.currentUserId,
      content: content,
      type: type,
      timestamp: DateTime.now(),
      filePath: filePath,
    );

    await _chatService.sendMessage(message, widget.chatId);
    _messageController.clear();
  }

  Future<void> _handleImageSelection() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String url =
          await _storageService.uploadFile(File(image.path), widget.chatId);
      await _sendMessage(url, MessageType.image);
    }
  }

  Future<void> _handleVideoSelection() async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final String url =
          await _storageService.uploadFile(File(video.path), widget.chatId);
      await _sendMessage(url, MessageType.video);
    }
  }

  Future<void> _handleFileSelection() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final File file = File(result.files.single.path!);
      final String url = await _storageService.uploadFile(file, widget.chatId);
      await _sendMessage(url, MessageType.file,
          filePath: result.files.single.name);
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _recordingPath = '${directory.path}/audio_message.m4a';
        await _audioRecorder.start(RecordConfig(), path: _recordingPath ?? '');
        setState(() => _isRecording = true);
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        final String url =
            await _storageService.uploadAudio(File(path), widget.chatId);
        await _sendMessage(url, MessageType.audio);
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF8F8F8).withAlpha(200),
        leadingWidth: 40.w,
        title: widget.otherUserId != null
            ? StreamBuilder<AppUser?>(
                stream: _databaseService.userStream(widget.otherUserId!),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final otherUser = userSnapshot.data!;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: otherUser.images![0] != null
                            ? NetworkImage(otherUser.images![0]!)
                            : AssetImage(AppAssets().pic) as ImageProvider,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: style17.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              (otherUser.isOnline ?? false)
                                  ? 'Online'
                                  : timeago.format(otherUser.lastOnline!),
                              style: style14.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
            : Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: AssetImage(AppAssets().pic),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: style17.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioCallScreen(
                    userName: widget.title,
                    profileImage: AppAssets().pic,
                  ),
                ),
              );
            },
            icon: Icon(Icons.call, color: lightOrangeColor),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                    userName: widget.title,
                    profileImage: AppAssets().pic,
                  ),
                ),
              );
            },
            icon: Icon(Icons.videocam, color: lightOrangeColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
        shape: const Border(
          bottom: BorderSide(color: Colors.black26),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isMe = message.senderId == widget.currentUserId;
                    return _buildMessageItem(message, isMe);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, -1),
                  blurRadius: 7.r,
                  spreadRadius: 0,
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.black26,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            onChanged: (value) {
                              setState(
                                  () {}); // Trigger rebuild to update button
                            },
                            decoration: InputDecoration(
                              hintText: 'Type a Message...',
                              hintStyle: style14.copyWith(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.h),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showAttachmentOptions(context);
                          },
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE56B6F),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: IconButton(
                    onPressed: _messageController.text.isNotEmpty
                        ? () => _sendMessage(
                            _messageController.text, MessageType.text)
                        : _isRecording
                            ? _stopRecording
                            : _startRecording,
                    icon: Icon(
                      _messageController.text.isNotEmpty
                          ? Icons.send
                          : _isRecording
                              ? Icons.stop
                              : Icons.mic,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message, bool isMe) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.h,
        horizontal: 16.w,
      ),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(
                  colors: [lightOrangeColor, lightPinkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : const Color(0xFFDADADA),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: _buildMessageContent(message),
      ),
    );
  }

  Widget _buildMessageContent(Message message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: style17.copyWith(
            color: message.senderId == widget.currentUserId
                ? Colors.white
                : Colors.black,
          ),
        );
      case MessageType.image:
        return GestureDetector(
          onTap: () => _showFullScreenImage(message.content),
          child: Image.network(
            message.content,
            height: 200.h,
            width: 200.w,
            fit: BoxFit.cover,
          ),
        );
      case MessageType.video:
        return _buildVideoMessage(message);
      case MessageType.audio:
        return _buildAudioMessage(message);
      case MessageType.file:
        return _buildFileMessage(message);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Content',
              style: style17.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                    context, Icons.photo, 'Gallery', Colors.purple),
                _buildAttachmentOption(
                    context, Icons.insert_drive_file, 'Document', Colors.blue),
                _buildAttachmentOption(
                    context, Icons.location_on, 'Location', Colors.green),
                _buildAttachmentOption(
                    context, Icons.person, 'Contact', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
      BuildContext context, IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: style14.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.all(20.w),
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoMessage(Message message) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement video player functionality
        // You would typically launch a video player screen here
      },
      child: Container(
        width: 200.w,
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.play_circle_fill,
              size: 40.sp,
              color: Colors.white,
            ),
            Positioned(
              bottom: 8.h,
              left: 8.w,
              child: Text(
                'Video',
                style: style14.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioMessage(Message message) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_arrow,
            size: 24.sp,
            color: message.senderId == widget.currentUserId
                ? Colors.white
                : Colors.black,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Voice Message',
                  style: style14.copyWith(
                    color: message.senderId == widget.currentUserId
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 2.h,
                  color: message.senderId == widget.currentUserId
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(Message message) {
    final fileName = message.filePath ?? 'Document';
    return Container(
      width: 200.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file,
            size: 24.sp,
            color: message.senderId == widget.currentUserId
                ? Colors.white
                : Colors.black,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: style14.copyWith(
                    color: message.senderId == widget.currentUserId
                        ? Colors.white
                        : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Tap to download',
                  style: style14.copyWith(
                    color: message.senderId == widget.currentUserId
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pink, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, 10, 10));

    var path = Path();
    path.moveTo(10, 0);
    path.lineTo(0, 10);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

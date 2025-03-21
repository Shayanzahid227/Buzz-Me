import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:code_structure/core/model/story.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/services/story_services.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:code_structure/core/services/cache_manager.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class StoryViewerScreen extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final String currentUserId;

  const StoryViewerScreen({
    Key? key,
    required this.stories,
    required this.initialIndex,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  VideoPlayerController? _videoController;
  final StoryService _storyService = StoryService();
  final DatabaseServices _databaseServices = DatabaseServices();
  final CacheManager _cacheManager = CacheManager();
  int _currentIndex = 0;
  bool _isCommenting = false;
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  String? _cachedMediaPath;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextStory();
        }
      });

    _loadStory(widget.stories[_currentIndex]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _videoController?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String _getFileExtension(String url) {
    // Try to extract extension from URL
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      final fileName = pathSegments.last;
      final extension = path.extension(fileName);
      if (extension.isNotEmpty) {
        return extension.substring(1); // Remove the dot
      }
    }

    // Default based on story type
    return 'mp4';
  }

  Future<void> _loadStory(Story story) async {
    setState(() {
      _isLoading = true;
      _cachedMediaPath = null;
    });

    _progressController.reset();

    try {
      // Check if media is cached
      final extension = _getFileExtension(story.mediaUrl);
      final cachedFile =
          await _cacheManager.getCachedFile(story.mediaUrl, extension);

      if (story.type == StoryType.video) {
        _videoController?.dispose();

        if (cachedFile != null) {
          // Use cached video file
          _cachedMediaPath = cachedFile.path;
          _videoController = VideoPlayerController.file(cachedFile);
        } else {
          // Use network video
          _videoController = VideoPlayerController.network(story.mediaUrl);
        }

        await _videoController!.initialize();
        setState(() {
          _isLoading = false;
        });
        _videoController!.play();
        _progressController.duration = _videoController!.value.duration;
        _progressController.forward();
      } else {
        // For images
        if (cachedFile != null) {
          _cachedMediaPath = cachedFile.path;
        }
        setState(() {
          _isLoading = false;
        });
        _progressController.forward();
      }

      // Mark story as viewed
      if (!story.viewedBy.contains(widget.currentUserId)) {
        await _storyService.viewStory(story.id, widget.currentUserId);
      }
    } catch (e) {
      print('Error loading story: $e');
      setState(() {
        _isLoading = false;
      });
      _progressController
          .forward(); // Continue with the timer even if there's an error
    }
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 3) {
            _previousStory();
          } else if (details.globalPosition.dx > 2 * screenWidth / 3) {
            _nextStory();
          } else {
            // Pause/play video if it's a video story
            if (widget.stories[_currentIndex].type == StoryType.video &&
                _videoController != null) {
              if (_videoController!.value.isPlaying) {
                _videoController!.pause();
                _progressController.stop();
              } else {
                _videoController!.play();
                _progressController.forward();
              }
            }
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _loadStory(widget.stories[index]);
              },
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return _StoryContent(
                  story: story,
                  videoController:
                      story.type == StoryType.video ? _videoController : null,
                  cachedMediaPath: _cachedMediaPath,
                  isLoading: _isLoading,
                );
              },
            ),
            _buildHeader(),
            _buildProgress(),
            if (_isCommenting) _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final story = widget.stories[_currentIndex];
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: FutureBuilder<AppUser?>(
        future: _databaseServices.getUser(story.userId),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: user?.images?[0] != null
                      ? NetworkImage(user!.images![0]!)
                      : null,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.userName ?? 'Unknown',
                        style: style17.copyWith(color: Colors.white),
                      ),
                      Text(
                        timeago.format(story.createdAt),
                        style: style14.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgress() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60.h,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: List.generate(
            widget.stories.length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    double progress = index == _currentIndex
                        ? _progressController.value
                        : index < _currentIndex
                            ? 1.0
                            : 0.0;
                    return LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        padding: EdgeInsets.fromLTRB(
            16.w, 16.h, 16.w, MediaQuery.of(context).padding.bottom + 16.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: style17.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: style17.copyWith(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: lightPinkColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(Icons.send, color: lightPinkColor),
              onPressed: () async {
                if (_commentController.text.isNotEmpty) {
                  await _storyService
                      .addComment(widget.stories[_currentIndex].id);
                  _commentController.clear();
                  setState(() {
                    _isCommenting = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryContent extends StatelessWidget {
  final Story story;
  final VideoPlayerController? videoController;
  final String? cachedMediaPath;
  final bool isLoading;

  const _StoryContent({
    Key? key,
    required this.story,
    this.videoController,
    this.cachedMediaPath,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (story.type == StoryType.video && videoController != null) {
      return Center(
        child: AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
      );
    } else {
      if (cachedMediaPath != null) {
        return Center(
          child: Image.file(
            File(cachedMediaPath!),
            fit: BoxFit.contain,
          ),
        );
      } else {
        return Center(
          child: Image.network(
            story.mediaUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ));
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }
  }
}

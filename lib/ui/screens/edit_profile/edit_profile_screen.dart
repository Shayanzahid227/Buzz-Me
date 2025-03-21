import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/model/user_profile.dart';
import 'package:code_structure/custom_widgets/buzz%20me/user_profile_interesting.dart';
import 'package:code_structure/ui/screens/edit_profile/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:code_structure/core/services/image_cache_helper.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileViewModel(),
      child:
          Consumer<EditProfileViewModel>(builder: (context, viewModel, child) {
        return ModalProgressHUD(
          inAsyncCall: viewModel.state == ViewState.busy,
          progressIndicator: CircularProgressIndicator(
            color: lightOrangeColor,
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title:
                  const Text("Profile", style: TextStyle(color: Colors.black)),
              actions: [
                TextButton(
                  onPressed: () async {
                    await viewModel.updateUser();
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text("Done", style: TextStyle(color: Colors.pink)),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  _buildPhotoGrid(viewModel, context),
                  20.verticalSpace,

                  // Profile Info
                  _buildInfoRow(
                    "Username",
                    viewModel.appUser.userName ?? "Not set",
                    onTap: () {
                      _displayUsernameDialog(context, viewModel);
                    },
                  ),
                  _buildInfoRow(
                    "Birthday",
                    viewModel.appUser.dob != null
                        ? DateFormat('MMM dd, yyyy')
                            .format(viewModel.appUser.dob!)
                        : 'Not set',
                    showArrow: true,
                    onTap: () {
                      _displayDatePicker(context, viewModel);
                    },
                  ),
                  _buildInfoRow(
                    "Gender",
                    viewModel.appUser.gender ?? "Not set",
                    showArrow: true,
                    onTap: () {
                      _displayGenderDialog(context, viewModel);
                    },
                  ),

                  36.verticalSpace,

                  // About you
                  Text(
                    "About you",
                    style: style25B,
                  ),
                  10.verticalSpace,
                  Text(
                    viewModel.appUser.about ?? "Not set",
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

                  _buildInfoRow(
                    'Height',
                    '${viewModel.appUser.height ?? '??'} cm',
                    onTap: () {
                      _displayHeightDialog(context, viewModel);
                    },
                  ),
                  _buildInfoRow(
                    'Weight',
                    '${viewModel.appUser.weight ?? '??'} kg',
                    onTap: () {
                      _displayWeightDialog(context, viewModel);
                    },
                  ),

                  // Relationship status
                  _buildInfoRow(
                    "Relationship status",
                    viewModel.appUser.relationshipStatus ?? 'Not set',
                    showArrow: true,
                    onTap: () {
                      _displayRelationshipStatusDialog(context, viewModel);
                    },
                  ),
                  _buildInfoRow("Looking for",
                      viewModel.appUser.lookingFor?.join(', ') ?? 'Not set',
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
                          viewModel.appUser.interests?.length ?? 0,
                          (index) {
                            return CustomInterestingWidget(
                                userProfileModel:
                                    UserProfileInterestingItemModel(
                                        title: viewModel
                                            .appUser.interests![index]));
                          },
                        ),
                      ),
                      30.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          _displayAddInterestDialog(context, viewModel);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 17.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: lightPinkColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Add more interests",
                              style: TextStyle(
                                  fontSize: 14, color: lightPinkColor),
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
          ),
        );
      }),
    );
  }

  Future<void> _displayUsernameDialog(
      BuildContext context, EditProfileViewModel viewModel) async {
    TextEditingController _userNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Username'),
          content: TextField(
            controller: _userNameController,
            decoration: InputDecoration(hintText: 'Username'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                viewModel.updateName(_userNameController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayDatePicker(
      BuildContext context, EditProfileViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.appUser.dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != viewModel.appUser.dob) {
      viewModel.updateDob(picked);
    }
  }

  Future<void> _displayGenderDialog(
      BuildContext context, EditProfileViewModel viewModel) async {
    TextEditingController _genderController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Gender'),
          content: TextField(
            controller: _genderController,
            decoration: InputDecoration(hintText: 'Gender'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                viewModel.updateGender(_genderController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _displayRelationshipStatusDialog(
      BuildContext context, EditProfileViewModel viewModel) {
    TextEditingController _relationshipStatusController =
        TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Relationship Status'),
          content: TextField(
            controller: _relationshipStatusController,
            decoration: InputDecoration(hintText: 'Relationship Status'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                viewModel.updateRelationshipStatus(
                    _relationshipStatusController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _displayHeightDialog(BuildContext context, EditProfileViewModel viewModel) {
    TextEditingController _heightController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Height'),
          content: TextField(
            controller: _heightController,
            decoration: InputDecoration(hintText: 'Height'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                viewModel.updateHeight(int.parse(_heightController.text));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _displayWeightDialog(BuildContext context, EditProfileViewModel viewModel) {
    TextEditingController _weightController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Weight'),
          content: TextField(
            controller: _weightController,
            decoration: InputDecoration(hintText: 'Weight'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                viewModel.updateWeight(int.parse(_weightController.text));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _displayAddInterestDialog(
      BuildContext context, EditProfileViewModel viewModel) {
    TextEditingController _interestController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Interest'),
          content: TextField(
            controller: _interestController,
            decoration: InputDecoration(hintText: 'Interest'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                viewModel.addInterest(_interestController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool showDivider = true, bool showArrow = false, onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
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
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: lightGreyColor,
                  ),
              ],
            ),
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

  Widget _buildPhotoGrid(EditProfileViewModel viewModel, context) {
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
                child: _buildPhotoItem(viewModel, 1, context, isLarge: true),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 13.h,
                  children: [
                    _buildPhotoItem(viewModel, 2, context),
                    _buildPhotoItem(viewModel, 3, context),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPhotoItem(viewModel, 4, context),
            _buildPhotoItem(viewModel, 5, context),
            _buildPhotoItem(viewModel, 6, context),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoItem(EditProfileViewModel viewModel, int index, context,
      {bool isLarge = false}) {
    // Adjust index to match the array (array is 0-based, but UI shows 1-based)
    final arrayIndex = index - 1;

    // Check if this position has an image (either from network or newly selected)
    final hasImage = viewModel.selectedImages[arrayIndex] != null ||
        (viewModel.appUser.images?[arrayIndex] != null);

    return GestureDetector(
      onTap: () async {
        await viewModel.selectfromGallery(arrayIndex);
      },
      child: Stack(
        children: [
          Container(
            height: isLarge ? 225.h : 106.h,
            width: isLarge ? double.infinity : 106.w,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: (viewModel.selectedImages[arrayIndex] != null)
                ? Image.file(
                    viewModel.selectedImages[arrayIndex]!,
                    fit: BoxFit.cover,
                  )
                : (viewModel.appUser.images?[arrayIndex] != null)
                    ? CachedProfileImage(
                        imageUrl: viewModel.appUser.images![arrayIndex]!,
                        width: isLarge ? double.infinity : 106.w,
                        height: isLarge ? 225.h : 106.h,
                      )
                    : Container(
                        color: lightGreyColor,
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: lightGreyColor4,
                        ),
                      ),
          ),

          // Position indicator
          Positioned(
            right: 5,
            bottom: 5,
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  index.toString(),
                ),
              ),
            ),
          ),

          // Delete button - only show if there's an actual image
          if (hasImage)
            Positioned(
              right: 5,
              top: 5,
              child: GestureDetector(
                onTap: () {
                  _showDeleteConfirmation(context, viewModel, arrayIndex);
                },
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18.r,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Confirmation dialog before deleting an image
  void _showDeleteConfirmation(
      BuildContext context, EditProfileViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('DELETE'),
              onPressed: () async {
                Navigator.pop(context);
                await viewModel.deleteImage(index);
              },
            ),
          ],
        );
      },
    );
  }
}

class CachedProfileImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const CachedProfileImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<CachedProfileImage> createState() => _CachedProfileImageState();
}

class _CachedProfileImageState extends State<CachedProfileImage> {
  bool _isLoading = true;
  String? _cachedImagePath;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      // Check if the image is already cached or download it
      final cachedFile =
          await ImageCacheHelper.getOrDownloadImage(widget.imageUrl);

      if (cachedFile != null) {
        setState(() {
          _cachedImagePath = cachedFile.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading image: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(lightPinkColor),
          ),
        ),
      );
    } else if (_hasError) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        ),
      );
    } else if (_cachedImagePath != null) {
      return Image.file(
        File(_cachedImagePath!),
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
      );
    } else {
      // Fallback to network image
      return Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(lightPinkColor),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
          );
        },
      );
    }
  }
}

class CachedCircleAvatar extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final Widget? fallbackWidget;

  const CachedCircleAvatar({
    Key? key,
    this.imageUrl,
    required this.radius,
    this.fallbackWidget,
  }) : super(key: key);

  @override
  State<CachedCircleAvatar> createState() => _CachedCircleAvatarState();
}

class _CachedCircleAvatarState extends State<CachedCircleAvatar> {
  bool _isLoading = true;
  String? _cachedImagePath;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null) {
      _loadImage();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(CachedCircleAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      if (widget.imageUrl != null) {
        _loadImage();
      } else {
        setState(() {
          _isLoading = false;
          _cachedImagePath = null;
        });
      }
    }
  }

  Future<void> _loadImage() async {
    if (widget.imageUrl == null) return;

    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Check if the image is already cached or download it
      final cachedFile =
          await ImageCacheHelper.getOrDownloadImage(widget.imageUrl!);

      if (cachedFile != null) {
        setState(() {
          _cachedImagePath = cachedFile.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading circle avatar image: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl == null) {
      return widget.fallbackWidget ??
          CircleAvatar(
            radius: widget.radius,
            backgroundImage: AssetImage(AppAssets().pic),
          );
    }

    if (_isLoading) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.grey[300],
        child: SizedBox(
          width: widget.radius,
          height: widget.radius,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(lightPinkColor),
            strokeWidth: 2,
          ),
        ),
      );
    } else if (_hasError) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.grey[300],
        child:
            Icon(Icons.error_outline, color: Colors.red, size: widget.radius),
      );
    } else if (_cachedImagePath != null) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: FileImage(File(_cachedImagePath!)),
      );
    } else {
      // Fallback to network image
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: NetworkImage(widget.imageUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          // Handle error silently
        },
      );
    }
  }
}

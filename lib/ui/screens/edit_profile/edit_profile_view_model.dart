import 'dart:io';

import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:code_structure/core/services/storage_services.dart';
import 'package:code_structure/core/services/image_cache_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final DatabaseServices _databaseServices = DatabaseServices();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  AppUser appUser = AppUser();
  List<File?> selectedImages = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  EditProfileViewModel() {
    getUser();
  }

  getUser() async {
    setState(ViewState.busy);
    appUser =
        await _databaseServices.getUser(_auth.currentUser!.uid) ?? AppUser();
    setState(ViewState.idle);
  }

  updateUser() async {
    setState(ViewState.busy);
    appUser.uid = _auth.currentUser!.uid;
    appUser.createdAt ??= DateTime.now();
    appUser.fcmToken = await _firebaseMessaging.getToken();

    // Update images array based on deletions and new selections
    for (int i = 0; i < appUser.images!.length; i++) {
      // If a position has been marked for deletion (null in the appUser array)
      // but doesn't have a new selection, keep it as null
      if (appUser.images![i] == null && selectedImages[i] == null) {
        continue;
      }

      // If there's a new selected image, upload it
      if (selectedImages[i] != null) {
        String url = await _storageService.uploadProfileImage(
            selectedImages[i]!, _auth.currentUser!.uid);
        appUser.images![i] = url;

        // Cache the uploaded image
        try {
          await ImageCacheHelper.cacheLocalFile(url, selectedImages[i]!);
        } catch (e) {
          print('Error caching uploaded image: $e');
        }
      }
    }

    await _databaseServices.setUser(appUser);
    setState(ViewState.idle);
  }

  updateName(String name) {
    appUser.userName = name;
    notifyListeners();
  }

  updateAbout(String about) {
    appUser.about = about;
    notifyListeners();
  }

  updateGender(String gender) {
    appUser.gender = gender;
    notifyListeners();
  }

  updateRelationshipStatus(String status) {
    appUser.relationshipStatus = status;
    notifyListeners();
  }

  updateDob(DateTime dob) {
    appUser.dob = dob;
    notifyListeners();
  }

  updateHeight(int height) {
    appUser.height = height;
    notifyListeners();
  }

  updateWeight(int weight) {
    appUser.weight = weight;
    notifyListeners();
  }

  addInterest(String interest) {
    appUser.interests?.add(interest);
    notifyListeners();
  }

  updateLookingFor(List<String> lookingFor) {
    appUser.lookingFor = lookingFor;
    notifyListeners();
  }

  updateImages(List<String> images) {
    appUser.images = images;
    notifyListeners();
  }

  updateAddress(String address) {
    appUser.address = address;
    notifyListeners();
  }

  // updateLocation(String location) {
  //   appUser.location = location;
  //   notifyListeners();
  // }

  selectfromCamera(int index) {
    _imagePicker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        selectedImages[index] = File(value.path);
        notifyListeners();
      }
    });
  }

  selectfromGallery(int index) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImages[index] = File(image.path);
      notifyListeners();
    }
  }

  /// Deletes an image at the specified index
  deleteImage(int index) async {
    try {
      setState(ViewState.busy);

      // Get the URL of the image to delete
      final imageUrl = appUser.images?[index];

      if (imageUrl != null) {
        // Delete from Firebase Storage if it exists
        try {
          await _storageService.deleteFile(imageUrl);
          print('Image deleted from storage: $imageUrl');
        } catch (e) {
          print('Error deleting image from storage: $e');
          // Continue with local deletion even if remote deletion fails
        }

        // Clear the cached version
        try {
          await ImageCacheHelper.removeFromCache(imageUrl);
        } catch (e) {
          print('Error removing image from cache: $e');
        }
      }

      // Update the app user model
      appUser.images![index] = null;

      // Clear any selected image for this index
      selectedImages[index] = null;
      updateUser();

      setState(ViewState.idle);
      notifyListeners();
    } catch (e) {
      print('Error in deleteImage: $e');
      setState(ViewState.idle);
    }
  }
}

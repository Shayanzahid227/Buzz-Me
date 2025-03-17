import 'dart:io';

import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseServices _databaseServices = DatabaseServices();
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

  selectfromGallery(int index) {
    _imagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        selectedImages[index] = File(value.path);
        notifyListeners();
      }
    });
  }
}

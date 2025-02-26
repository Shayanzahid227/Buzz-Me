import 'dart:ui';

import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/model/nearby_all_user.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:flutter/material.dart';

class NearbyAllUsersViewModel extends BaseViewModel {
  List<NearbyAllUsersModel> allUsersList = [
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderMan,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderMan,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderMan,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderMan,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderMan,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderWoman,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().pic,
        name: 'shanzoo',
        gender: AppAssets().genderMan,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().discoverBack,
        name: 'shanzoo',
        gender: AppAssets().genderWoman,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().discoverBack,
        name: 'shanzoo',
        gender: AppAssets().genderWoman,
        rating: '23'),
    NearbyAllUsersModel(
        imageUrl: AppAssets().discoverBack,
        name: 'shanzoo',
        gender: AppAssets().genderWoman,
        rating: '23')
  ];
}

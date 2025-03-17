import 'dart:ui';

import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/model/discover_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/core/providers/all_users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class DiscoverSCreenViewModel extends BaseViewModel {
  List<Color> colorList = [
    Color(0xffFF0000),
    Color(0xff00FF00),
    Color(0xff0000FF),
    Color(0xffFFFF00),
    Color(0xff00FFFF),
  ];

  List<String> imageList = [
    'https://www.vogue.com/photos/6491c6d543823e841f8c2fc9/1:1/w_1424,h_1424,c_limit/cid_f_lj02spbw0-3.jpeg',
    'https://i.guim.co.uk/img/media/67944850a1b5ebd6a0fba9e3528d448ebe360c60/359_0_2469_1482/master/2469.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=03f3e07a7f367f36a738f1ad8132b3bb',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://pyxis.nymag.com/v1/imgs/a5f/165/cf12f71bac777059733b1b9fdb498894d5-billie-eilish-new-album.1x.rsquare.w1400.jpg',
  ];
  List<DiscoverModel> discoverList = [
    DiscoverModel(
      imageUrl: AppAssets().pic,
      name: 'Billie Eilish',
      additionalInfo: 'Singer',
      location: 'Los Angeles, California',
      score: '23',
    ),
    DiscoverModel(
      imageUrl: AppAssets().pic,
      name: 'Billie Eilish',
      additionalInfo: 'Singer',
      location: 'Los Angeles, California',
      score: '23',
    ),
    DiscoverModel(
      imageUrl: AppAssets().pic,
      name: 'Billie Eilish',
      additionalInfo: 'Singer',
      location: 'Los Angeles, California',
      score: '23',
    ),
    DiscoverModel(
      imageUrl: AppAssets().pic,
      name: 'Billie Eilish',
      additionalInfo: 'Singer',
      location: 'Los Angeles, California',
      score: '23',
    ),
    DiscoverModel(
      imageUrl: AppAssets().pic,
      name: 'Billie Eilish',
      additionalInfo: 'Singer',
      location: 'Los Angeles, California',
      score: '23',
    ),
  ];

  List<SwipeItem> _swipeItems = [];
  MatchEngine? matchEngine;

  DiscoverSCreenViewModel(List<AppUser> users) {
    _initializeCards(users);
  }

  void _initializeCards(List<AppUser> users) {
    print('users: $users');
    _swipeItems = users.map((discover) {
      return SwipeItem(
        content: discover,
        likeAction: () {
          // Handle like action
        },
        nopeAction: () {
          // Handle nope action
        },
        superlikeAction: () {
          // Handle superlike action
        },
      );
    }).toList();

    matchEngine = MatchEngine(swipeItems: _swipeItems);
    notifyListeners();
  }

  void resetCards(List<AppUser> users) {
    _initializeCards(users);
    notifyListeners();
  }
}

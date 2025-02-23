import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/ui/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class RootViewModel extends BaseViewModel {
  // final PageController pageController = PageController(initialPage: 0);

  int selectedScreen = 0;

  List<Widget> allScreen = [
    // call screen here according to index
    // LoginScreen()
  ];

  ///
  /// Constructor
  ///
  RootViewModel(val) {
    updatedScreen(val);
    notifyListeners();
  }

  // int selectIndex = 0;

  updatedScreen(int index) {
    setState(ViewState.busy);
    selectedScreen = index;
    setState(ViewState.idle);
    notifyListeners();
  }

  // pushScreen(int index) {
  //   pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 2000), curve: Curves.bounceIn);
  //   selectedScreen = index;
  //   notifyListeners();
  // }
}

import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseServices _databaseServices = DatabaseServices();

  UserProfileViewModel(String userId) {
    addVisitor(userId);
  }

  addVisitor(String userId) async {
    try {
      setState(ViewState.busy);
      // add visitor to the user profile
      await _databaseServices.addVisitor(_auth.currentUser!.uid, userId);
      setState(ViewState.idle);
    } catch (e) {
      print(e.toString());
      setState(ViewState.idle);
    }
  }

  giveLike(String userId) async {
    try {
      setState(ViewState.busy);
      // give like to the user profile
      await _databaseServices.giveLike(_auth.currentUser!.uid, userId);
      setState(ViewState.idle);
    } catch (e) {
      print(e.toString());
      setState(ViewState.idle);
    }
  }

  giveSuperLike(String userId) async {
    try {
      setState(ViewState.busy);
      // give super like to the user profile
      await _databaseServices.giveSuperLike(_auth.currentUser!.uid, userId);
      setState(ViewState.idle);
    } catch (e) {
      print(e.toString());
      setState(ViewState.idle);
    }
  }

  ///
  ///user personal images in his/her profile
  ///
  List<String> userImagesList = [
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
  ];

  ///
  /// user friends list
  ///
  List<String> friendsImagesList = [
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/gettyimages-1175559425.jpg',
    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
  ];

  ///
  ///  interesting
  ///
  List<String> interestingItemList = [
    'Guitar & tabla',
    'Music & Games',
    'Fishing',
    'Swimming',
    'Book % Movies',
    'Dancing & Singing',
  ];

  ///
  /// looking for
  ///
  List<String> lookingForItemList = [
    'Guitar & tabla',
    'Music & Games',
    'Fishing',
    'Swimming',
    'Book % Movies',
    'Dancing & Singing',
  ];
}

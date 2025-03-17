import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/core/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserProvider extends BaseViewModel {
  DatabaseServices _databaseServices = DatabaseServices();
  FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser user = AppUser();

  UserProvider() {
    getUser();
  }

  getUser() async {
    setState(ViewState.busy);
    // get users from database
    Stream userStream =
        await _databaseServices.userStream(_auth.currentUser!.uid);

    print('got user');

    userStream.listen((event) {
      user = event;
      setState(ViewState.idle);
    });
    setState(ViewState.idle);
  }
}

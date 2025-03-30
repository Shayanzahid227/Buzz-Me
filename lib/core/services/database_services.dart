import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_structure/core/constants/collection_identifiers.dart';
import 'package:code_structure/core/model/app_user.dart';

class DatabaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  setUser(AppUser appUser) async {
    try {
      await _firestore.collection(AppUserCollection).doc(appUser.uid).set(
            appUser.toJson(),
          );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<AppUser?> getUser(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection(AppUserCollection).doc(uid).get();
      return AppUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<AppUser?> userStream(String uid) {
    try {
      return _firestore
          .collection(AppUserCollection)
          .doc(uid)
          .snapshots()
          .map((event) {
        return AppUser.fromJson(event.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  Stream<List<AppUser>?> allUsersStream() {
    try {
      return _firestore.collection(AppUserCollection).snapshots().map((event) {
        print('adfadf ${event.docs.length}');
        final List<AppUser> users = event.docs
            .map((e) => AppUser.fromJson(e.data() as Map<String, dynamic>))
            .toList();
        return users;
      });
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  addVisitor(String visitorId, String userId) async {
    try {
      await _firestore.collection(AppUserCollection).doc(userId).update(
        {
          'visits': FieldValue.arrayUnion(
            [visitorId],
          ),
        },
      );
      await _firestore.collection(AppUserCollection).doc(visitorId).update(
        {
          'visited': FieldValue.arrayUnion(
            [userId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  giveLike(String likerId, String likeeId) async {
    try {
      await _firestore.collection(AppUserCollection).doc(likeeId).update(
        {
          'likes': FieldValue.arrayUnion(
            [likerId],
          ),
        },
      );
      await _firestore.collection(AppUserCollection).doc(likerId).update(
        {
          'liked': FieldValue.arrayUnion(
            [likeeId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  giveSuperLike(String likerId, String likeeId) async {
    try {
      await _firestore.collection(AppUserCollection).doc(likeeId).update(
        {
          'superLikes': FieldValue.arrayUnion(
            [likerId],
          ),
        },
      );
      await _firestore.collection(AppUserCollection).doc(likerId).update(
        {
          'superLiked': FieldValue.arrayUnion(
            [likeeId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  giveMatch(String userId, String matchedUserId) async {
    try {
      await _firestore.collection(AppUserCollection).doc(userId).update(
        {
          'matched': FieldValue.arrayUnion(
            [matchedUserId],
          ),
        },
      );
      await _firestore.collection(AppUserCollection).doc(matchedUserId).update(
        {
          'matches': FieldValue.arrayUnion(
            [userId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUserOnlineStatus(String uid, bool isOnline) async {
    try {
      await _firestore.collection(AppUserCollection).doc(uid).update({
        'isOnline': isOnline,
        'lastOnline': DateTime.now(),
      });
    } catch (e) {
      print('Error updating online status: ${e.toString()}');
    }
  }
}

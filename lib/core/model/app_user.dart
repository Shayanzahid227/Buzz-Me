import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String? uid;

  String? userName;
  List<String?>? images;
  DateTime? createdAt;
  DateTime? dob;
  String? gender;
  int? height;
  int? weight;
  String? relationshipStatus;
  String? about;

  bool? isOnline;
  DateTime? lastOnline;

  //  LatLng? location;
  String? address;

  List<String>? interests;
  List<String>? lookingFor;

  List<String>? likes;
  List<String>? superLikes;
  List<String>? matches;
  List<String>? visits;

  List<String>? liked;
  List<String>? superLiked;
  List<String>? matched;
  List<String>? visited;

  AppUser({
    this.uid,
    this.userName,
    this.images = const [
      null,
      null,
      null,
      null,
      null,
      null,
    ],
    this.createdAt,
    this.dob,
    this.gender,
    this.height,
    this.weight,
    this.relationshipStatus,
    this.about,
    this.isOnline,
    this.lastOnline,
    //  this.location,
    this.address,
    this.interests,
    this.lookingFor,
    this.likes,
    this.superLikes,
    this.matches,
    this.visits,
    this.liked,
    this.superLiked,
    this.matched,
    this.visited,
  });

  AppUser copyWith({
    String? uid,
    String? userName,
    List<String?>? images,
    DateTime? createdAt,
    DateTime? dob,
    String? gender,
    int? height,
    int? weight,
    String? relationshipStatus,
    String? about,
    bool? isOnline,
    DateTime? lastOnline,
    // LatLng? location,
    String? address,
    List<String>? interests,
    List<String>? lookingFor,
    List<String>? likes,
    List<String>? superLikes,
    List<String>? matches,
    List<String>? visits,
    List<String>? liked,
    List<String>? superLiked,
    List<String>? matched,
    List<String>? visited,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      about: about ?? this.about,
      isOnline: isOnline ?? this.isOnline,
      lastOnline: lastOnline ?? this.lastOnline,
      // location: location ?? this.location,
      address: address ?? this.address,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      likes: likes ?? this.likes,
      superLikes: superLikes ?? this.superLikes,
      matches: matches ?? this.matches,
      visits: visits ?? this.visits,
      liked: liked ?? this.liked,
      superLiked: superLiked ?? this.superLiked,
      matched: matched ?? this.matched,
      visited: visited ?? this.visited,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'images': images,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'gender': gender,
      'height': height,
      'weight': weight,
      'relationshipStatus': relationshipStatus,
      'about': about,
      'isOnline': isOnline,
      'lastOnline': lastOnline != null ? Timestamp.fromDate(lastOnline!) : null,
      // 'location': location,
      'address': address,
      'interests': interests ?? [],
      'lookingFor': lookingFor ?? [],
      'likes': likes ?? [],
      'superLikes': superLikes ?? [],
      'matches': matches ?? [],
      'visits': visits ?? [],
      'liked': liked ?? [],
      'superLiked': superLiked ?? [],
      'matched': matched ?? [],
      'visited': visited ?? [],
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      userName: json['userName'],
      images: List<String?>.from(json['images']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      dob: (json['dob'] as Timestamp).toDate(),
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      relationshipStatus: json['relationshipStatus'],
      about: json['about'],
      isOnline: json['isOnline'],
      lastOnline: (json['lastOnline'] as Timestamp).toDate(),
      // location: json['location'],
      address: json['address'],
      interests: List<String>.from(json['interests']),
      lookingFor: List<String>.from(json['lookingFor']),
      likes: List<String>.from(json['likes']),
      superLikes: List<String>.from(json['superLikes']),
      matches: List<String>.from(json['matches']),
      visits: List<String>.from(json['visits']),
      liked: List<String>.from(json['liked']),
      superLiked: List<String>.from(json['superLiked']),
      matched: List<String>.from(json['matched']),
      visited: List<String>.from(json['visited']),
    );
  }
}

import 'dart:convert';

class AccountModel {
  String userName;
  String userEmail;
  String img;
  String uid;
  bool allowMessages;
  List<dynamic> posts;
  List<dynamic> followers;

  AccountModel({
    required this.userName,
    required this.userEmail,
    required this.img,
    required this.posts,
    required this.followers,
    required this.uid,
    required this.allowMessages,
  });

  factory AccountModel.fromRawJson(String str) =>
      AccountModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        userName: json["userName"],
        userEmail: json["userEmail"],
        img: json["img"],
        posts: List<dynamic>.from(json["posts"].map((x) => x)),
        followers: List<dynamic>.from(json["followers"].map((x) => x)),
        uid: json['uid'],
        allowMessages: json['allowMessages'],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userEmail": userEmail,
        "img": img,
        "posts": List<dynamic>.from(posts.map((x) => x)),
        "followers": List<dynamic>.from(followers.map((x) => x)),
        'uid': uid,
        'allowMessages': allowMessages
      };
}

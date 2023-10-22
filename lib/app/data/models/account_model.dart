import 'dart:convert';

class AccountModel {
  String userName;
  String userEmail;
  String img;
  String postCount;
  Posts posts;
  String followerCount;
  Followers followers;

  AccountModel({
    required this.userName,
    required this.userEmail,
    required this.img,
    required this.postCount,
    required this.posts,
    required this.followerCount,
    required this.followers,
  });

  factory AccountModel.fromRawJson(String str) =>
      AccountModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        userName: json["userName"],
        userEmail: json["userEmail"],
        img: json["img"],
        postCount: json["postCount"],
        posts: Posts.fromJson(json["posts"]),
        followerCount: json["followerCount"],
        followers: Followers.fromJson(json["followers"]),
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userEmail": userEmail,
        "img": img,
        "postCount": postCount,
        "posts": posts.toJson(),
        "followerCount": followerCount,
        "followers": followers.toJson(),
      };
}

class Followers {
  String email;

  Followers({
    required this.email,
  });

  factory Followers.fromRawJson(String str) =>
      Followers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Followers.fromJson(Map<String, dynamic> json) => Followers(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}

class Posts {
  String path;

  Posts({
    required this.path,
  });

  factory Posts.fromRawJson(String str) => Posts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
      };
}

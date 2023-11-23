import 'dart:convert';

class PostModel {
  String id;
  String contentType;
  String topic;
  String topicId;
  String img;
  String title;
  String owner;
  String ownerUid;
  String description;
  String content;
  String ownerName;
  String likeCount;
  String profile;
  Map<String, Like> likes;
  String commentsCount;
  Map<String, Comment> comments;
  String share;
  String impression;

  PostModel({
    required this.id,
    required this.contentType,
    required this.topic,
    required this.topicId,
    required this.img,
    required this.title,
    required this.owner,
    required this.ownerUid,
    required this.description,
    required this.content,
    required this.ownerName,
    required this.likeCount,
    required this.profile,
    required this.likes,
    required this.commentsCount,
    required this.comments,
    required this.share,
    required this.impression,
  });

  factory PostModel.fromJson(String str) => PostModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        contentType: json["contentType"],
        topic: json["topic"],
        topicId: json["topicId"],
        img: json["img"],
        title: json["title"],
        owner: json["owner"],
        ownerUid: json['ownerUid'],
        description: json["description"],
        content: json["content"],
        ownerName: json["ownerName"],
        likeCount: json["likeCount"],
        profile: json["profile"],
        likes: Map.from(json["likes"])
            .map((k, v) => MapEntry<String, Like>(k, Like.fromMap(v))),
        commentsCount: json["commentsCount"],
        comments: Map.from(json["comments"])
            .map((k, v) => MapEntry<String, Comment>(k, Comment.fromMap(v))),
        share: json["share"],
        impression: json["impression"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "contentType": contentType,
        "topic": topic,
        "topicId": topicId,
        "img": img,
        "title": title,
        "owner": owner,
        "ownerUid": ownerUid,
        "description": description,
        "content": content,
        "ownerName": ownerName,
        "likeCount": likeCount,
        "profile": profile,
        "likes": Map.from(likes)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "commentsCount": commentsCount,
        "comments": Map.from(comments)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "share": share,
        "impression": impression,
      };
}

class Comment {
  String profile;
  String email;
  String date;
  String uid;
  String message;

  Comment({
    required this.profile,
    required this.email,
    required this.date,
    required this.uid,
    required this.message,
  });

  factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        profile: json["profile"],
        email: json["email"],
        date: json["date"],
        uid: json['uid'],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "profile": profile,
        "email": email,
        "date": date,
        'uid': uid,
        "message": message,
      };
}

class Like {
  String uid;
  String date;

  Like({
    required this.uid,
    required this.date,
  });

  factory Like.fromJson(String str) => Like.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Like.fromMap(Map<String, dynamic> json) => Like(
        uid: json["uid"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "date": date,
      };
}

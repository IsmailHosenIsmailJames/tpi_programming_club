import 'dart:convert';

class PostModel {
  String id;
  String contentType;
  String topic;
  String topicId;
  String title;
  String img;
  String owner;
  String description;
  String content;
  String likeCount;
  Likes likes;
  String commentsCount;
  Comments comments;
  String share;
  String impression;

  PostModel({
    required this.id,
    required this.contentType,
    required this.topic,
    required this.topicId,
    required this.title,
    required this.img,
    required this.owner,
    required this.description,
    required this.content,
    required this.likeCount,
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
        title: json["title"],
        img: json["img"],
        owner: json["owner"],
        description: json["description"],
        content: json["content"],
        likeCount: json["likeCount"],
        likes: Likes.fromMap(json["likes"]),
        commentsCount: json["commentsCount"],
        comments: Comments.fromMap(json["comments"]),
        share: json["share"],
        impression: json["impression"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "contentType": contentType,
        "topic": topic,
        "topicId": topicId,
        "title": title,
        "img": img,
        "owner": owner,
        "description": description,
        "content": content,
        "like_count": likeCount,
        "likes": likes.toMap(),
        "commentsCount": commentsCount,
        "comments": comments.toMap(),
        "share": share,
        "impression": impression,
      };
}

class Comments {
  CommentId commentId;

  Comments({
    required this.commentId,
  });

  factory Comments.fromJson(String str) => Comments.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Comments.fromMap(Map<String, dynamic> json) => Comments(
        commentId: CommentId.fromMap(json["commentId"]),
      );

  Map<String, dynamic> toMap() => {
        "commentId": commentId.toMap(),
      };
}

class CommentId {
  String email;
  String date;
  String message;

  CommentId({
    required this.email,
    required this.date,
    required this.message,
  });

  factory CommentId.fromJson(String str) => CommentId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommentId.fromMap(Map<String, dynamic> json) => CommentId(
        email: json["email"],
        date: json["date"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "date": date,
        "message": message,
      };
}

class Likes {
  LikeId likeId;

  Likes({
    required this.likeId,
  });

  factory Likes.fromJson(String str) => Likes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Likes.fromMap(Map<String, dynamic> json) => Likes(
        likeId: LikeId.fromMap(json["likeId"]),
      );

  Map<String, dynamic> toMap() => {
        "likeId": likeId.toMap(),
      };
}

class LikeId {
  String email;
  String date;

  LikeId({
    required this.email,
    required this.date,
  });

  factory LikeId.fromJson(String str) => LikeId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LikeId.fromMap(Map<String, dynamic> json) => LikeId(
        email: json["email"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "date": date,
      };
}

import 'package:flutter/material.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/publish/post_models.dart';

class PublishPost extends StatefulWidget {
  const PublishPost(
      {super.key,
      required this.name,
      required this.id,
      required this.content,
      required this.contentType});

  final String name;
  final String id;
  final String content;
  final String contentType;

  @override
  State<PublishPost> createState() => _PublishPostState();
}

class _PublishPostState extends State<PublishPost> {
  final String owner = "owner@email.com";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            PostModel x = PostModel.fromMap({
              "id": "0",
              "contentType": widget.contentType,
              "topic": widget.name,
              "topicId": widget.id,
              "img": "img",
              "title": "title",
              "owner": "owner",
              "description": "description",
              "content": widget.content,
              "likeCount": "0",
              "likes": {
                "likeId": {"email": "email", "date": "date"}
              },
              "commentsCount": "commentCount",
              "comments": {
                "commentId": {
                  "email": "email",
                  "date": "date",
                  "message": "message"
                }
              },
              "share": "share",
              "impression": "impression"
            });
            print(x.toJson());
          },
          child: const Text("Go"),
        ),
      ),
    );
  }
}

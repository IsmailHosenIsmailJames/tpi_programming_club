import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/quill_editor/create_post_view_quill.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/models/post_models.dart';

class SingleClassPost extends StatefulWidget {
  const SingleClassPost({
    super.key,
    required this.path,
    required this.fullData,
  });
  final String path;
  final PostModel fullData;

  @override
  State<SingleClassPost> createState() => _SingleClassPostState();
}

class _SingleClassPostState extends State<SingleClassPost> {
  List<Map<String, dynamic>> quillPostData = [];
  List<Widget> quillPostWidget = [];
  String markdownString = "";
  void getData(String path) async {
    // get the post
    final data = await FirebaseDatabase.instance.ref(path).get();
    if (data.value != null) {
      String postData = data.value as String;
      if (widget.fullData.contentType == 'quill') {
        List<dynamic> tem = jsonDecode(postData);
        for (var element in tem) {
          quillPostData.add(Map<String, dynamic>.from(element));
        }
        quillPostWidget = CreatePostViewQuill().createWidget(quillPostData);
        setState(() {
          quillPostData;
        });
      } else {
        quillPostWidget.add(
          Expanded(
            child: MarkdownBody(
              data: postData,
              selectable: true,
              onTapLink: (text, href, title) async {
                if (!await launchUrl(Uri.parse(href!))) {
                  throw Exception('Could not launch $href');
                }
              },
            ),
          ),
        );
      }
    }
  }

  void getComments() async {
    var commentsData =
        await FirebaseDatabase.instance.ref("${widget.path}/comments").get();

    if (commentsData.exists) {
      Map<String, dynamic> comments =
          Map<String, dynamic>.from(jsonDecode(jsonEncode(commentsData.value)));

      List<Widget> commentsWidget = [];
      comments.forEach((key, value) {
        if (key != 'commentId') {
          final date = value['date'];
          final message = value['message'];
          final email = value['email'];
          final profile = value['profile'];
          String? userEmail = FirebaseAuth.instance.currentUser!.email;
          commentsWidget.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.thumb_up_outlined,
                    color: Colors.grey,
                  ),
                  label: Text(widget.fullData.likeCount),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                  label: Text(
                    widget.fullData.commentsCount,
                  ),
                ),
              ],
            ),
          );
          if (userEmail == widget.fullData.owner) {
            commentsWidget.add(
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(80, 116, 116, 116),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          email,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          date,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profile != "null"
                            ? Image.network(
                                profile,
                                fit: BoxFit.fill,
                              )
                            : const Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            commentsWidget.add(
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(80, 116, 116, 116),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profile != "null"
                            ? Image.network(
                                profile,
                                fit: BoxFit.fill,
                              )
                            : const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          email,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          date,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
      });
      quillPostWidget.add(Column(
        children: commentsWidget,
      ));
      setState(() {
        quillPostWidget;
      });
    }
  }

  @override
  void initState() {
    getData(widget.fullData.content);
    // getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fullData.title),
      ),
      body: SafeArea(
          child: ListView(
        children: quillPostWidget,
      )),
    );
  }
}

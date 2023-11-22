import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/views/accounts/account_info_controller.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/quill_editor/create_post_view_quill.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

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
  final accountInfo = Get.put(AccountInfoController());
  TextEditingController commentTextController = TextEditingController();
  @override
  void initState() {
    creatWidget(widget.fullData, true);
    super.initState();
  }

  List<Widget> createCommentsWidget(Map<String, Comment> comments) {
    List<Widget> widgets = [];
    String? userMail = FirebaseAuth.instance.currentUser?.email;

    comments.forEach((key, value) {
      if (key != 'id' && key != 'commentId') {
        if (userMail == value.email) {
          widgets.add(
            Row(
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(70, 143, 143, 143),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          value.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        value.date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(60, 143, 143, 143),
                        ),
                        child: Text(
                          value.message,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          widgets.add(
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(70, 143, 143, 143),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Text(
                          value.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        value.date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(60, 143, 143, 143),
                        ),
                        child: Text(
                          value.message,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }
      }
    });
    return widgets;
  }

  Widget profile = Container();
  List<Widget> post = [];
  Widget likeCommentSattus = Container();
  List<Widget> comments = [];
  List<Widget> fullPostTogether = [];

  bool isAlreadyLiked(Map<String, Like> likes) {
    bool liked = false;
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    likes.forEach((key, value) {
      if (value.email == userEmail) {
        liked = true;
      }
    });
    return liked;
  }

  void creatWidget(PostModel postData, bool rebuilFutuer) async {
    List<Widget> allSectionTogeter = [];
    if (rebuilFutuer == true) {
      setState(() {
        profile = Container(
          height: 73,
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(80, 143, 143, 143),
          ),
          child: FutureBuilder(
            future: FirebaseDatabase.instance
                .ref("user/${postData.owner.replaceAll('.', ",")}")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  if (snapshot.hasData) {
                    final data = jsonDecode(jsonEncode(snapshot.data!.value));
                    return Row(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: data['img'] == 'null'
                                ? Center(
                                    child: Text(
                                      postData.ownerName.substring(0, 2),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: data['img'],
                                    fit: BoxFit.scaleDown,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) {
                                      return Center(
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postData.ownerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              postData.owner,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }
              }

              return Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Center(
                      child: Text(
                        postData.ownerName.substring(0, 2),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postData.ownerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        postData.owner,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      });

      final firebasePostData =
          await FirebaseDatabase.instance.ref(postData.content).get();
      String contentData = "";

      if (firebasePostData.exists) {
        final data = firebasePostData.value;
        if (data != null) {
          try {
            final box = Hive.box("tpi_programming_club");
            box.put(postData.content, data.toString());
            contentData = data.toString();
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        } else {
          try {
            final box = Hive.box("tpi_programming_club");
            contentData = box.get(postData.content).toString();
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
      } else {
        try {
          final box = Hive.box("tpi_programming_club");
          contentData = box.get(postData.content).toString();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }

      if (contentData.isNotEmpty) {
        if (postData.contentType == 'quill') {
          setState(() {
            post = CreatePostViewQuill().createWidgetFromString(contentData);
          });
        } else {
          setState(() {
            post = [
              MarkdownBody(
                data: contentData,
              )
            ];
          });
        }
      }
    }
    setState(() {
      comments = createCommentsWidget(widget.fullData.comments);
    });

    allSectionTogeter.add(profile);
    allSectionTogeter.addAll(post);
    allSectionTogeter.add(
      const SizedBox(
        height: 5,
      ),
    );
    allSectionTogeter.add(
      Container(
        margin: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(80, 143, 143, 143),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () async {
                String userEmail = FirebaseAuth.instance.currentUser!.email!;
                bool isDisLike = false;
                String dislikeKey = "";
                postData.likes.forEach((key, value) async {
                  if (value.email == userEmail) {
                    isDisLike = true;
                    dislikeKey = key;
                  }
                });
                if (isDisLike) {
                  int likeCount = int.parse(postData.likeCount);
                  likeCount--;
                  await FirebaseDatabase.instance
                      .ref("${widget.path}/likeCount")
                      .set(likeCount.toString());
                  postData.likeCount = likeCount.toString();

                  await FirebaseDatabase.instance
                      .ref("${widget.path}/likes/$dislikeKey/")
                      .remove();
                  postData.likes.remove(dislikeKey);
                  creatWidget(postData, false);
                } else {
                  int likeCount = int.parse(postData.likeCount);
                  final date = DateTime.now();
                  Like likeData = Like(
                      email: userEmail,
                      date:
                          "${date.second}:${date.minute}:${date.hour} ${date.day}/${date.month}/${date.year}");
                  await FirebaseDatabase.instance
                      .ref("${widget.path}/likes/$likeCount/")
                      .set(likeData.toMap());
                  postData.likes.addAll({likeCount.toString(): likeData});
                  likeCount++;
                  await FirebaseDatabase.instance
                      .ref("${widget.path}/likeCount")
                      .set(likeCount.toString());
                  postData.likeCount = likeCount.toString();
                  creatWidget(postData, false);
                }
              },
              icon: isAlreadyLiked(postData.likes)
                  ? const Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.thumb_up,
                      color: Colors.grey,
                    ),
              label: Text(
                widget.fullData.likeCount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: commentTextController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.cancel),
                                      label: const Text("Cancle"),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        final time = DateTime.now();
                                        final coments =
                                            widget.fullData.comments;
                                        coments.addAll({
                                          widget.fullData.commentsCount:
                                              Comment(
                                            profile: accountInfo.img.value,
                                            email: FirebaseAuth
                                                .instance.currentUser!.email
                                                .toString(),
                                            date:
                                                "Date: ${time.day}/${time.month}/${time.year} at ${time.hour}:${time.minute}:${time.second}",
                                            message: commentTextController.text
                                                .trim(),
                                          ),
                                        });
                                        await FirebaseDatabase.instance
                                            .ref(
                                                "${widget.path}/commentsCount/")
                                            .set(
                                                "${int.parse(postData.commentsCount) + 1}");
                                        Map<String, dynamic> tem = {};
                                        coments.forEach((key, value) {
                                          tem.addAll({key: value.toMap()});
                                        });
                                        await FirebaseDatabase.instance
                                            .ref("${widget.path}/comments/")
                                            .update(tem);
                                        commentTextController.clear();

                                        setState(() {
                                          postData.commentsCount = (int.parse(
                                                      postData.commentsCount) +
                                                  1)
                                              .toString();
                                          final x = widget.fullData.toMap();
                                          x["comments"] = tem;

                                          postData = PostModel.fromMap(x);
                                        });
                                        creatWidget(postData, false);
                                      },
                                      icon: const Icon(Icons.done),
                                      label: const Text("Ok"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.comment,
                color: Colors.green,
              ),
              label: Text(
                postData.commentsCount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    allSectionTogeter.addAll([
      const SizedBox(
        height: 5,
      ),
      const Center(
        child: Text("Comments"),
      ),
      const SizedBox(
        height: 5,
      ),
    ]);

    allSectionTogeter.addAll(comments);
    setState(() {
      fullPostTogether = allSectionTogeter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fullData.title,
        ),
      ),
      drawer: const HomeDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: fullPostTogether,
      ),
    );
  }
}

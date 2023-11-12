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
  String cmcount = "";
  Map<String, Comment> cmMessage = {};
  @override
  void initState() {
    cmcount = widget.fullData.commentsCount;
    cmMessage = widget.fullData.comments;
    super.initState();
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
        children: [
          Container(
            height: 73,
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(80, 143, 143, 143),
            ),
            child: FutureBuilder(
              future: FirebaseDatabase.instance
                  .ref("user/${widget.fullData.owner.replaceAll('.', ",")}")
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
                                        widget.fullData.ownerName
                                            .substring(0, 2),
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
                                widget.fullData.ownerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.fullData.owner,
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
                          widget.fullData.ownerName.substring(0, 2),
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
                          widget.fullData.ownerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.fullData.owner,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 6, left: 3, right: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(80, 119, 119, 119),
            ),
            padding: const EdgeInsets.all(3),
            child: FutureBuilder(
              future:
                  FirebaseDatabase.instance.ref(widget.fullData.content).get(),
              builder: (context, snapshot) {
                String contentData = "";
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    try {
                      final box = Hive.box("tpi_programming_club");
                      box.put(widget.fullData.content,
                          snapshot.data!.value.toString());
                      contentData = snapshot.data!.value.toString();
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  } else {
                    try {
                      final box = Hive.box("tpi_programming_club");
                      contentData = box.get(widget.fullData.content).toString();
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }
                } else if (snapshot.connectionState == ConnectionState.active) {
                  try {
                    final box = Hive.box("tpi_programming_club");
                    contentData = box.get(widget.fullData.content).toString();
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                  return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  );
                }
                try {
                  final box = Hive.box("tpi_programming_club");
                  contentData = box.get(widget.fullData.content).toString();
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
                if (contentData.isNotEmpty) {
                  if (widget.fullData.contentType == 'quill') {
                    final x = CreatePostViewQuill()
                        .createWidgetFromString(contentData);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: jsonDecode(contentData).length,
                      itemBuilder: (context, index) => x[index],
                    );
                  } else {
                    return MarkdownBody(
                      data: contentData,
                    );
                  }
                }
                return LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                );
              },
            ),
          ),
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
                  onPressed: () {},
                  icon: const Icon(
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
                                                message: commentTextController
                                                    .text
                                                    .trim(),
                                              ),
                                            });
                                            await FirebaseDatabase.instance
                                                .ref(
                                                    "${widget.path}/commentsCount/")
                                                .set(
                                                    "${int.parse(cmcount) + 1}");
                                            Map<String, dynamic> tem = {};
                                            coments.forEach((key, value) {
                                              tem.addAll({key: value.toMap()});
                                            });
                                            await FirebaseDatabase.instance
                                                .ref("${widget.path}/comments/")
                                                .update(tem);
                                            commentTextController.clear();

                                            setState(() {
                                              cmcount = (int.parse(cmcount) + 1)
                                                  .toString();
                                              final x = widget.fullData.toMap();
                                              x["comments"] = tem;

                                              cmMessage =
                                                  PostModel.fromMap(x).comments;
                                            });
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
                    color: Colors.grey,
                  ),
                  label: Text(
                    cmcount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Center(
            child: Text("Comments"),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
            padding: const EdgeInsets.all(3),
            child: Column(
              children: createCommentsWidget(cmMessage),
            ),
          ),
        ],
      ),
    );
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
                    color: const Color.fromARGB(80, 143, 143, 143),
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
                          color: const Color.fromARGB(80, 143, 143, 143),
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
                    color: const Color.fromARGB(80, 143, 143, 143),
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
                          color: const Color.fromARGB(80, 143, 143, 143),
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
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
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
                                      widget.fullData.ownerName.substring(0, 2),
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
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (widget.fullData.contentType == 'quill') {
                      final x = CreatePostViewQuill().createWidgetFromString(
                          snapshot.data!.value.toString());
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            jsonDecode(snapshot.data!.value.toString()).length,
                        itemBuilder: (context, index) => x[index],
                      );
                    } else {
                      return MarkdownBody(
                        data: snapshot.data!.value.toString(),
                      );
                    }
                  } else {
                    return const Text("There have no data");
                  }
                } else if (snapshot.connectionState == ConnectionState.active) {
                  return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  );
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment,
                    color: Colors.grey,
                  ),
                  label: Text(
                    widget.fullData.commentsCount,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

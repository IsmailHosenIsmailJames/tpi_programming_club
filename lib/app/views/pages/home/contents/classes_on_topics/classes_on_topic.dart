import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/views/pages/home/contents/classes_on_topics/single_class_post.dart';

import '../../../../../themes/app_theme_data.dart';
import '../../../../../data/models/post_models.dart';
import '../../../drawer/drawer.dart';

class ClassesOnTopics extends StatefulWidget {
  final String path;
  final String topicsName;
  const ClassesOnTopics(
      {super.key, required this.path, required this.topicsName});

  @override
  State<ClassesOnTopics> createState() => _ClassesOnTopicsState();
}

class _ClassesOnTopicsState extends State<ClassesOnTopics> {
  Future saveDatabaseResponce(Map<String, dynamic> decodedData) async {
    var box = Hive.box("tpi_programming_club");
    box.put(widget.path, decodedData);
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.path);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topicsName,
        ),
      ),
      drawer: const HomeDrawer(),
      body: FutureBuilder(
        future: FirebaseDatabase.instance.ref().child(widget.path).get(),
        builder: (context, snapshot) {
          List<PostModel> listOfTopics = [];
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!.value;
              if (data != null) {
                final decodedData = jsonDecode(jsonEncode(data));
                saveDatabaseResponce(decodedData);

                int count = int.parse(decodedData['classCount']);

                for (var i = 0; i < count; i++) {
                  var topic = decodedData['$i'];
                  if (topic != null) {
                    PostModel obj = PostModel.fromMap(topic);
                    listOfTopics.add(obj);
                  }
                }
              }
            }
          } else if (snapshot.connectionState == ConnectionState.active) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue, size: 40),
            );
          } else {
            try {
              var box = Hive.box("tpi_programming_club");
              var data = box.get(widget.path);
              if (data != null) {
                int count = int.parse(data['classCount']);

                for (var i = 0; i < count; i++) {
                  if (data['$i'] != null) {
                    PostModel obj = PostModel.fromMap(Map.from(data['$i']));
                    listOfTopics.add(obj);
                  }
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          }
          if (listOfTopics.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 2),
                    child: SearchBar(
                      trailing: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Go",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                      hintText: "Search topics",
                      leading: const Icon(Icons.search),
                      onSubmitted: (value) {},
                      hintStyle: const MaterialStatePropertyAll(
                        TextStyle(color: Colors.grey),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      shadowColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      side: const MaterialStatePropertyAll(
                        BorderSide(color: Colors.blue, width: 3),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: listOfTopics.length,
                    itemBuilder: (context, index) {
                      return GetX<AppThemeData>(
                        builder: (controller) => GestureDetector(
                          onTap: () {
                            Get.to(
                              SingleClassPost(
                                title: listOfTopics[index].title,
                                contentType: listOfTopics[index].contentType,
                                content: listOfTopics[index].content,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: controller.containerBackGroundColor.value,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: const Color.fromARGB(
                                                83, 158, 158, 158)),
                                        child: Center(
                                          child: listOfTopics[index].img ==
                                                  'null'
                                              ? Text(
                                                  listOfTopics[index]
                                                      .ownerName
                                                      .substring(0, 2),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        listOfTopics[index].img,
                                                    fit: BoxFit.scaleDown,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Center(
                                                      child:
                                                          LoadingAnimationWidget
                                                              .staggeredDotsWave(
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            listOfTopics[index]
                                                        .ownerName
                                                        .length >
                                                    15
                                                ? "${listOfTopics[index].ownerName.substring(0, 15)}..."
                                                : listOfTopics[index].ownerName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            listOfTopics[index].owner.length >
                                                    20
                                                ? "${listOfTopics[index].owner.substring(0, 20)}..."
                                                : listOfTopics[index].owner,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: listOfTopics[index].img,
                                        fit: BoxFit.scaleDown,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: LoadingAnimationWidget
                                              .staggeredDotsWave(
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Text(
                                    listOfTopics[index].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(listOfTopics[index].description),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Spacer(),
                                      const Icon(
                                        Icons.thumb_up,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(listOfTopics[index].likeCount),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      const Icon(
                                        Icons.share,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(listOfTopics[index].share),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(
              child: Text("Error When Loading. Cheak internet connection"));
        },
      ),
    );
  }
}

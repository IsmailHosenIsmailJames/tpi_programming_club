import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/themes/app_theme_data.dart';
import 'package:tpi_programming_club/app/data/models/topics_model.dart';

import 'classes_on_topics/classes_on_topic.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  Future saveDatabaseResponce(Map<String, dynamic> decodedData) async {
    var box = Hive.box("tpi_programming_club");
    decodedData.forEach((key, value) {
      box.put("contents/topics/$key", value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseDatabase.instance.ref().child("contents/topics").get(),
      builder: (context, snapshot) {
        List<TopicsModel> listOfTopics = [];
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data!.value;
            if (data != null) {
              final decodedData = jsonDecode(jsonEncode(data));
              saveDatabaseResponce(decodedData);

              int count = int.parse(decodedData['count']);

              for (var i = 0; i < count; i++) {
                var topic = decodedData['$i'];
                if (topic != null) {
                  TopicsModel obj = TopicsModel.fromJson(topic);
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
        }

        if (listOfTopics.isEmpty) {
          try {
            var box = Hive.box("tpi_programming_club");
            int count = int.parse(box.get("contents/topics/count"));

            for (var i = 0; i < count; i++) {
              var topic = box.get("contents/topics/$i", defaultValue: null);
              if (topic != null) {
                TopicsModel obj =
                    TopicsModel.fromJson(jsonDecode(jsonEncode(topic)));
                listOfTopics.add(obj);
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
                          String path = "contents/${listOfTopics[index].id}";
                          Get.to(
                            () => ClassesOnTopics(
                              path: path,
                              topicsName: listOfTopics[index].name,
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
                                Center(
                                  child: SizedBox(
                                    height: 100,
                                    child: CachedNetworkImage(
                                      imageUrl: listOfTopics[index].img,
                                      fit: BoxFit.scaleDown,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: LoadingAnimationWidget.inkDrop(
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
                                  listOfTopics[index].name,
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
                                    Text(listOfTopics[index].like),
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

        return Center(
          child: LoadingAnimationWidget.inkDrop(color: Colors.grey, size: 40),
        );
      },
    );
  }
}

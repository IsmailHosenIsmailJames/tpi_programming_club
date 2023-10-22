import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/create_topics.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

import '../../../themes/app_theme_data.dart';
import '../home/contents/topics_model.dart';
import 'select_editing_tools.dart';

class SelectTopics extends StatefulWidget {
  const SelectTopics({super.key});

  @override
  State<SelectTopics> createState() => _SelectTopicsState();
}

class _SelectTopicsState extends State<SelectTopics> {
  Future saveDatabaseResponce(Map<String, dynamic> decodedData) async {
    var box = Hive.box("tpi_programming_club");
    decodedData.forEach((key, value) {
      box.put("/contents/topics/$key/", value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topics"),
      ),
      drawer: const HomeDrawer(),
      body: FutureBuilder(
        future:
            FirebaseDatabase.instance.ref().child('/contents/topics/').get(),
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
          } else {
            try {
              var box = Hive.box("tpi_programming_club");
              int count = int.parse(box.get("/contents/topics/count/"));

              for (var i = 0; i < count; i++) {
                var topic = box.get("/contents/topics/$i/");
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Select a topics or create your own unique topics",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Are you sure ?'),
                                  content: const Text(
                                      'Creating unnecessary topics should be always avoided. Make sure you really need to create a topics.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                        Get.to(() => const CreateTopics());
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text("Create Topic"),
                          ),
                        ],
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
                            String name = listOfTopics[index].name;
                            String id = listOfTopics[index].id;
                            Get.to(
                              SelectEditingTools(
                                name: name,
                                id: id,
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Select a topics or create your own unique topics",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(double.infinity, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure ?'),
                                content: const Text(
                                    'Creating unnecessary topics should be always avoided. Make sure you really need to create a topics.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      Get.to(() => const CreateTopics());
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Create Topic"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Text("Error When Loading. Cheak internet connection"),
            ],
          );
        },
      ),
    );
  }
}

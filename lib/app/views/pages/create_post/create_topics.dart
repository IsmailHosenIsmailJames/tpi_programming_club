import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/core/image_picker.dart';
import 'package:tpi_programming_club/app/core/show_toast_meassage.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';
import 'package:tpi_programming_club/app/data/models/topics_model.dart';

import 'select_topics.dart';

class CreateTopics extends StatefulWidget {
  const CreateTopics({super.key});

  @override
  State<CreateTopics> createState() => _CreateTopicsState();
}

class _CreateTopicsState extends State<CreateTopics> {
  final validationKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? imgUrl;
  String? title;
  String? description;

  Widget imagePlacholder = const SizedBox(
    child: Center(
      child: Icon(Icons.add_photo_alternate_outlined),
    ),
  );
  Widget loadingIconOnUploadIMage = const SizedBox(
    child: Text("Choice an Image"),
  );
  Widget loadingIconOnPublishTopics = const SizedBox(
    child: Text("Publish"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Topic"),
      ),
      drawer: const HomeDrawer(),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(83, 33, 149, 243),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: imagePlacholder,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: const Size(200, 35),
                ),
                onPressed: () async {
                  setState(() {
                    loadingIconOnUploadIMage = SizedBox(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 40),
                    );
                  });
                  final count = await FirebaseDatabase.instance
                      .ref()
                      .child("/contents/topics/count/")
                      .get();
                  int id = 0;
                  if (count.value != null) {
                    id = int.parse(count.value.toString());
                  }
                  PickPhotoFileWithUrlMobile img =
                      await pickPhotoMobile("/contents/topics/$id");
                  if (img.imageFile != null) {
                    setState(() {
                      imagePlacholder = SizedBox(
                        child: Image.file(img.imageFile!, fit: BoxFit.cover),
                      );
                    });
                  }
                  if (img.url != null) {
                    imgUrl = img.url;
                  }
                  setState(() {
                    loadingIconOnUploadIMage = const SizedBox(
                      child: Text("Choice an Image"),
                    );
                  });
                },
                child: loadingIconOnUploadIMage,
              ),
              Form(
                key: validationKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: titleController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Too short description";
                          }
                        },
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            child: const Icon(
                              Icons.info,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Type your topic's title",
                          labelText: "Title",
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: null,
                        validator: (value) {
                          if (value!.length > 20) {
                            return null;
                          } else {
                            return "Too short description";
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            child: const Icon(
                              Icons.info,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Type your topic's description",
                          labelText: "Description",
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          setState(() {
                            loadingIconOnPublishTopics = SizedBox(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white, size: 40),
                            );
                          });
                          if (validationKey.currentState!.validate()) {
                            if (imgUrl != null) {
                              int id = DateTime.now().millisecondsSinceEpoch;

                              TopicsModel topicsModel = TopicsModel(
                                id: "$id",
                                name: titleController.text,
                                description: descriptionController.text,
                                img: imgUrl!,
                                like: "0",
                                share: "0",
                                classNumber: "0",
                              );
                              final ref = FirebaseDatabase.instance
                                  .ref("/contents/topics/$id");
                              await ref.set(topicsModel.toJson());
                              Get.off(() => const SelectTopics());

                              // ignore: use_build_context_synchronously
                              showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Successfully Uploaded'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              showToast("Select Image firest");
                            }
                          }
                        },
                        child: loadingIconOnPublishTopics,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

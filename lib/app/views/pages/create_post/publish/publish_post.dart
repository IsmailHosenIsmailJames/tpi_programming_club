import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/data/models/post_models.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/select_topics.dart';

import '../../../../core/image_picker.dart';
import '../../drawer/drawer.dart';
import '../getx_create_post_controller.dart';

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
  final controller = Get.put(CreatePostController());

  final validationKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? imgUrl;
  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploade Post"),
      ),
      drawer: const HomeDrawer(),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(83, 33, 149, 243),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: controller.imageWidget.value,
                ),
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
                  controller.loadingIconOnUploadeImage.value = SizedBox(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 40),
                  );

                  int id = int.parse(widget.id);

                  PickPhotoFileWithUrlMobile img =
                      await pickPhotoMobile("/contents/$id/");
                  if (img.imageFile != null) {
                    controller.imageWidget.value = SizedBox(
                      child: Image.file(img.imageFile!, fit: BoxFit.cover),
                    );
                  }
                  if (img.url != null) {
                    imgUrl = img.url;
                  }
                  controller.loadingIconOnUploadeImage.value = const SizedBox(
                    child: Text("Choice an Image"),
                  );
                },
                child: Obx(
                  () => controller.loadingIconOnUploadeImage.value,
                ),
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
                      Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            if (validationKey.currentState!.validate()) {
                              if (imgUrl != null) {
                                controller.loadingIconOnUploadeTopics.value =
                                    SizedBox(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                          color: Colors.white, size: 40),
                                );
                                final count = await FirebaseDatabase.instance
                                    .ref("/contents/count/")
                                    .get();
                                int id = 0;
                                if (count.value != null) {
                                  id = int.parse(count.value.toString());
                                }
                                PostModel post = PostModel(
                                  id: "$id",
                                  contentType: widget.contentType,
                                  topic: widget.name,
                                  topicId: widget.id,
                                  title: titleController.text,
                                  img: imgUrl!,
                                  owner: owner,
                                  description: descriptionController.text,
                                  content: widget.content,
                                  likeCount: "0",
                                  likes: Likes(
                                    likeId: LikeId(
                                      email: "null",
                                      date: "null",
                                    ),
                                  ),
                                  commentsCount: "0",
                                  comments: Comments(
                                    commentId: CommentId(
                                      email: "null",
                                      date: "null",
                                      message: "null",
                                    ),
                                  ),
                                  share: "0",
                                  impression: "0",
                                );

                                int classCount = 0;
                                var classCountData = await FirebaseDatabase
                                    .instance
                                    .ref("/contents/$id/classCount")
                                    .get();

                                if (classCountData.exists) {
                                  classCount = int.parse(
                                      classCountData.value.toString());
                                }

                                Map<String, dynamic> map = post.toMap();
                                var ref = FirebaseDatabase.instance
                                    .ref("/contents/$id/$classCount");

                                await ref.set(map);
                                ref = FirebaseDatabase.instance
                                    .ref("/contents/$id/classCount");
                                ref.set(
                                  "${(classCount + 1)}",
                                );
                                controller.loadingIconOnUploadeTopics.value =
                                    const SizedBox(
                                  child: Text("Uploaded Successfully"),
                                );

                                Get.to(() => const SelectTopics());

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
                              }
                            }
                          },
                          child: controller.loadingIconOnUploadeTopics.value,
                        ),
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

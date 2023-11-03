import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostController extends GetxController {
  Rx<SizedBox> imageWidget = const SizedBox(
          child: Center(child: Icon(Icons.add_photo_alternate_outlined)))
      .obs;
  Rx<Widget> loadingIconOnUploadeImage = const SizedBox(
    child: Text("Choice an Image"),
  ).obs;
  Rx<Widget> loadingIconOnUploadeTopics = const SizedBox(
    child: Text("Publish"),
  ).obs;
}

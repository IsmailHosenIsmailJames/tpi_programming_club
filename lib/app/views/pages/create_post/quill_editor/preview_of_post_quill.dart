import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/publish_post.dart';

import 'create_post_view_quill.dart';

class PreViewOfPostQuill extends StatefulWidget {
  const PreViewOfPostQuill({
    super.key,
    required this.name,
    required this.id,
    required this.postData,
  });

  final String name;
  final String id;
  final List<Map<String, dynamic>> postData;

  @override
  State<PreViewOfPostQuill> createState() => _PreViewOfPostQuillState();
}

class _PreViewOfPostQuillState extends State<PreViewOfPostQuill> {
  List<Widget> postPreview = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Get.to(
              () => PublishPost(
                name: widget.name,
                id: widget.id,
                content: jsonEncode(widget.postData),
                contentType: 'quill',
              ),
            ),
            icon: const Icon(Icons.public),
            label: const Text("Publish"),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
          children: CreatePostViewQuill().createWidget(widget.postData),
        ),
      ),
    );
  }
}

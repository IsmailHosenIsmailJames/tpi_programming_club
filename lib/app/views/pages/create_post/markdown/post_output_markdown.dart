import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

import '../publish_post/publish_post.dart';

class MarkDownOutPut extends StatefulWidget {
  final String markdown;
  final String name;
  final String id;
  const MarkDownOutPut(
      {super.key,
      required this.markdown,
      required this.name,
      required this.id});

  @override
  State<MarkDownOutPut> createState() => _MarkDownOutPutState();
}

class _MarkDownOutPutState extends State<MarkDownOutPut> {
  TocController tocController = TocController();
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text("OUTPUT"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(
                  () => PublishPost(
                    name: widget.name,
                    id: widget.id,
                    content: widget.markdown,
                    contentType: "markdown",
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: TocWidget(
              controller: tocController,
            ),
          ),
          Expanded(
            child: MarkdownWidget(
              config: config,
              data: widget.markdown,
              tocController: tocController,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/publish/publish_post.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
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
      body: Markdown(
        data: widget.markdown,
        selectable: true,
        onTapLink: (text, href, title) async {
          if (!await launchUrl(Uri.parse(href!))) {
            throw Exception('Could not launch $href');
          }
        },
      ),
    );
  }
}

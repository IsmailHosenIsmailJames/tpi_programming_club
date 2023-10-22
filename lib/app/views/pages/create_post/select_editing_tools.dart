import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'quill_editor/quill_editor.dart';
import 'markdown/create_post_markdown.dart';

class SelectEditingTools extends StatefulWidget {
  const SelectEditingTools({super.key, required this.name, required this.id});

  final String name;
  final String id;

  @override
  State<SelectEditingTools> createState() => _SelectEditingToolsState();
}

class _SelectEditingToolsState extends State<SelectEditingTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Editing Tool"),
      ),
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Recommended for Advanced",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 26,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Recommended for advanced programmer. This editor use Markdown editing syntax. Many popular website use Markdown for thir website. If you know Markdown, then you should go with this tool.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(250, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => PostEditor(
                                    name: widget.name,
                                    id: widget.id,
                                  ));
                            },
                            child: const Text(
                              "Markdown",
                              style: TextStyle(
                                fontSize: 32,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () async {
                              if (!await launchUrl(Uri.parse(
                                  "https://www.markdownguide.org/basic-syntax/"))) {
                                throw Exception(
                                    'Could not launch https://www.markdownguide.org/basic-syntax/');
                              }
                            },
                            icon: const Icon(
                              Icons.info,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Recommended for Begainner",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 26,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Recommended for Begainners. This editor use Rich Text Editor. You can make Microshoft word like document that is very customizable. Who is used to Microshoft word, he/she can edit post.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(250, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => MyQuillHtmlEditor(
                                    name: widget.name,
                                    id: widget.id,
                                  ));
                            },
                            child: const Text(
                              "AppFlowy",
                              style: TextStyle(
                                fontSize: 32,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () async {
                              if (!await launchUrl(
                                  Uri.parse("https://appflowy.io/"))) {
                                throw Exception(
                                    'Could not launch https://appflowy.io/');
                              }
                            },
                            icon: const Icon(
                              Icons.info,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

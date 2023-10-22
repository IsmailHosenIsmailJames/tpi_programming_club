import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:tpi_programming_club/app/themes/app_theme_data.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleClassPost extends StatefulWidget {
  const SingleClassPost({
    super.key,
    required this.title,
    required this.contentType,
    required this.content,
  });
  final String title;
  final String contentType;
  final String content;

  @override
  State<SingleClassPost> createState() => _SingleClassPostState();
}

class _SingleClassPostState extends State<SingleClassPost> {
  final quillController = QuillEditorController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      drawer: const HomeDrawer(),
      body: widget.contentType == "quill"
          ? GetX<AppThemeData>(
              builder: (controller) => QuillHtmlEditor(
                controller: quillController,
                text: widget.content,
                isEnabled: false,
                minHeight: MediaQuery.of(context).size.height,
              ),
            )
          : GetX<AppThemeData>(
              builder: (controller) => Markdown(
                data: widget.content,
                selectable: true,
                onTapLink: (text, href, title) async {
                  if (!await launchUrl(Uri.parse(href!))) {
                    throw Exception('Could not launch $href');
                  }
                },
              ),
            ),
    );
  }
}

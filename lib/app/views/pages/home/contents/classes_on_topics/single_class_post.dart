import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        //   appBar: AppBar(
        //     title: Text(
        //       widget.title,
        //     ),
        //   ),
        //   drawer: const HomeDrawer(),
        //   body: widget.contentType == "quill"
        //       ? QuillHtmlEditor(
        //           controller: quillController,
        //           text: widget.content,
        //           isEnabled: false,
        //           minHeight: MediaQuery.of(context).size.height,
        //         )
        //       : Markdown(
        //           data: widget.content,
        //           selectable: true,
        //           onTapLink: (text, href, title) async {
        //             if (!await launchUrl(Uri.parse(href!))) {
        //               throw Exception('Could not launch $href');
        //             }
        //           },
        //         ),
        );
  }
}

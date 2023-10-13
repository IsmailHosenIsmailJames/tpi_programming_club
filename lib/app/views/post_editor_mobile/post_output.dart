import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/const_theme_data.dart';

class MarkDownOutPut extends StatefulWidget {
  final String markdown;
  const MarkDownOutPut({super.key, required this.markdown});

  @override
  State<MarkDownOutPut> createState() => _MarkDownOutPutState();
}

class _MarkDownOutPutState extends State<MarkDownOutPut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantThemeData().primaryColour,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                "Post",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 30,
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

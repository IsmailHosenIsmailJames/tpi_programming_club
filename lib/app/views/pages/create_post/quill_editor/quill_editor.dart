import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/publish/publish_post.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class MyQuillHtmlEditor extends StatefulWidget {
  const MyQuillHtmlEditor({super.key, required this.name, required this.id});
  final String name;
  final String id;

  @override
  State<MyQuillHtmlEditor> createState() => _MyQuillHtmlEditorState();
}

class _MyQuillHtmlEditorState extends State<MyQuillHtmlEditor> {
  QuillEditorController quillEditorController = QuillEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Document Editor",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            onPressed: () async {
              String htmlText = await quillEditorController.getText();
              Get.to(
                () => PublishPost(
                    name: widget.name,
                    id: widget.id,
                    content: htmlText,
                    contentType: "quill"),
              );
            },
            child: const Icon(
              Icons.upload,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: ListView(
          reverse: true,
          children: [
            ToolBar.scroll(
              toolBarColor: Colors.cyan.shade50,
              activeIconColor: Colors.green,
              padding: const EdgeInsets.all(8),
              iconSize: 20,
              controller: quillEditorController,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: QuillHtmlEditor(
                controller: quillEditorController,
                backgroundColor: Colors.grey.shade100,
                isEnabled: true,
                minHeight: 60,
                autoFocus: true,
                padding: const EdgeInsets.all(2),
                onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
                onEditingComplete: (s) => debugPrint('Editing completed $s'),
                onEditorResized: (height) =>
                    debugPrint('Editor resized $height'),
                onSelectionChanged: (sel) =>
                    debugPrint('${sel.index},${sel.length}'),
                loadingBuilder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.4,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

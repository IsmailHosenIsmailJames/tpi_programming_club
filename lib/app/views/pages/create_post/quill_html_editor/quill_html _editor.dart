import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class MyAppfloyEditor extends StatefulWidget {
  const MyAppfloyEditor({super.key, required this.name, required this.id});
  final String name;
  final String id;

  @override
  State<MyAppfloyEditor> createState() => _MyAppfloyEditorState();
}

class _MyAppfloyEditorState extends State<MyAppfloyEditor> {
  QuillEditorController controller = QuillEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
                onPressed: () async {
                  // String x = await controller.getText();
                  // controller.setDelta(x);
                },
                icon: Icon(Icons.forward)),
            QuillHtmlEditor(
              text: "<h1>Hello</h1>This is a quill html editor example 😊",
              hintText: 'Hint text goes here',
              controller: controller,
              isEnabled: true,
              minHeight: 300,
              autoFocus: true,
              hintTextAlign: TextAlign.start,
              padding: const EdgeInsets.only(left: 10, top: 5),
              hintTextPadding: EdgeInsets.zero,
              onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
              onTextChanged: (text) => debugPrint('widget text change $text'),
              onEditorCreated: () => debugPrint('Editor has been loaded'),
              onEditingComplete: (s) => debugPrint('Editing completed $s'),
              onEditorResized: (height) => debugPrint('Editor resized $height'),
              onSelectionChanged: (sel) =>
                  debugPrint('${sel.index},${sel.length}'),
              loadingBuilder: (context) {
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 0.4,
                ));
              },
            ),
            ToolBar(
              toolBarColor: Colors.cyan.shade50,
              activeIconColor: Colors.green,
              padding: const EdgeInsets.all(8),
              iconSize: 20,
              controller: controller,
              customButtons: [
                InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
                InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

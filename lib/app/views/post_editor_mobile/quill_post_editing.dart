import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class QuillEditor extends StatefulWidget {
  const QuillEditor({super.key});

  @override
  State<QuillEditor> createState() => _QuillEditorState();
}

class _QuillEditorState extends State<QuillEditor> {
  final QuillEditorController controller = QuillEditorController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          QuillHtmlEditor(
            hintText: 'Hint text goes here',
            controller: controller,
            isEnabled: true,
            minHeight: 300,
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

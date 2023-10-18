import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class MyAppfloyEditor extends StatefulWidget {
  const MyAppfloyEditor({super.key});

  @override
  State<MyAppfloyEditor> createState() => _MyAppfloyEditorState();
}

class _MyAppfloyEditorState extends State<MyAppfloyEditor> {
  final editorState = EditorState.blank(withInitialText: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appfloy Editor"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
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
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AppFlowyEditor(
                    editorStyle: const EditorStyle.mobile(
                      padding: EdgeInsets.all(3),
                    ),
                    autoFocus: true,
                    editorState: editorState,
                  ),
                ),
              ),
            ),
            MobileToolbar(
              borderRadius: 100,
              editorState: editorState,
              toolbarItems: [
                textDecorationMobileToolbarItem,
                headingMobileToolbarItem,
                todoListMobileToolbarItem,
                listMobileToolbarItem,
                linkMobileToolbarItem,
                quoteMobileToolbarItem,
                dividerMobileToolbarItem,
                codeMobileToolbarItem,
              ],
            )
          ],
        ),
      ),
    );
  }
}
